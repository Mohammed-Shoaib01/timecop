// Copyright 2020 Kenton Hamaluik
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timecop/blocs/projects/bloc.dart';
import 'package:timecop/blocs/settings/settings_bloc.dart';
import 'package:timecop/components/ProjectColour.dart';
import 'package:timecop/l10n.dart';
import 'package:timecop/models/project.dart';
import 'package:timecop/screens/reports/components/ProjectBreakdown.dart';
import 'package:timecop/screens/reports/components/TimeTable.dart';
import 'package:timecop/screens/reports/components/WeekdayAverages.dart';
import 'package:timecop/screens/reports/components/WeeklyTotals.dart';
import 'package:timecop/models/clone_time.dart';

class ReportsScreen extends StatefulWidget {
  ReportsScreen({Key? key}) : super(key: key);

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _oldStartDate;
  DateTime? _oldEndDate;
  static final DateFormat _dateFormat = DateFormat("EE, MMM d, yyyy");
  List<Project?> selectedProjects = [];

  @override
  void initState() {
    super.initState();
    final ProjectsBloc projects = BlocProvider.of<ProjectsBloc>(context);
    selectedProjects = <Project?>[null]
        .followedBy(projects.state.projects
            .where((p) => !p.archived)
            .map((p) => Project.clone(p)))
        .toList();

    final SettingsBloc settings = BlocProvider.of<SettingsBloc>(context);
    _startDate = settings.getFilterStartDate();
  }

  void setStartDate(DateTime dt) {
    setState(() {
      _startDate = dt;
      if (_endDate != null && _startDate!.isAfter(_endDate!)) {
        _endDate = _startDate!.add(
            Duration(hours: 23, minutes: 59, seconds: 59, milliseconds: 999));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProjectsBloc projectsBloc = BlocProvider.of<ProjectsBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(L10N.of(context).tr.reports),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: Platform.isLinux || Platform.isMacOS
                          ? EdgeInsets.symmetric(horizontal: 32)
                          : EdgeInsets.zero,
                      child: Builder(builder: (context) {
                        switch (index) {
                          case 0:
                            return ProjectBreakdown(
                              startDate: _startDate,
                              endDate: _endDate,
                              selectedProjects: selectedProjects,
                            );
                          case 1:
                            return WeeklyTotals(
                              startDate: _startDate,
                              endDate: _endDate,
                              selectedProjects: selectedProjects,
                            );
                          case 2:
                            return WeekdayAverages(
                              context,
                              startDate: _startDate,
                              endDate: _endDate,
                              selectedProjects: selectedProjects,
                            );
                          case 3:
                            return TimeTable(
                              startDate: _startDate,
                              endDate: _endDate,
                              selectedProjects: selectedProjects,
                            );
                        }
                        return Container();
                      }));
                },
                itemCount: 4,
                pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                  color: Theme.of(context).disabledColor,
                  activeColor: Theme.of(context).colorScheme.secondary,
                )),
                control: Platform.isLinux || Platform.isMacOS
                    ? SwiperControl(
                        iconPrevious: Icons.arrow_back_ios_new,
                        iconNext: Icons.arrow_forward_ios,
                        color: Theme.of(context).colorScheme.onBackground)
                    : null,
              ),
            ),
            ExpansionTile(
              title: Text(L10N.of(context).tr.filter,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w700)),
              initiallyExpanded: false,
              children: <Widget>[
                ListTile(
                  leading: Icon(FontAwesomeIcons.calendar),
                  title: Text(L10N.of(context).tr.from),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    _startDate == null
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            child: Text("--"))
                        : Text(_dateFormat.format(_startDate!)),
                    if (_startDate != null)
                      IconButton(
                        icon: Icon(FontAwesomeIcons.circleMinus),
                        onPressed: () {
                          setState(() {
                            _startDate = null;
                          });
                        },
                        tooltip: L10N.of(context).tr.remove,
                      )
                  ]),
                  onTap: () async {
                    _oldStartDate = _startDate?.clone();
                    _oldEndDate = _endDate?.clone();
                    DateTime? newStartDate = await DatePicker.showDatePicker(
                        context,
                        currentTime: _startDate,
                        onChanged: (DateTime dt) =>
                            setStartDate(DateTime(dt.year, dt.month, dt.day)),
                        onConfirm: (DateTime dt) =>
                            setStartDate(DateTime(dt.year, dt.month, dt.day)),
                        theme: DatePickerTheme(
                          cancelStyle: Theme.of(context).textTheme.button!,
                          doneStyle: Theme.of(context).textTheme.button!,
                          itemStyle: Theme.of(context).textTheme.bodyText2!,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                        ));

                    // if the user cancelled, this should be null
                    if (newStartDate == null) {
                      setState(() {
                        _startDate = _oldStartDate;
                        _endDate = _oldEndDate;
                      });
                    }
                  },
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.calendar),
                  title: Text(L10N.of(context).tr.to),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    _endDate == null
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            child: Text("--"))
                        : Text(_dateFormat.format(_endDate!)),
                    if (_endDate != null)
                      IconButton(
                        tooltip: L10N.of(context).tr.remove,
                        icon: Icon(FontAwesomeIcons.circleMinus),
                        onPressed: () {
                          setState(() {
                            _endDate = null;
                          });
                        },
                      )
                  ]),
                  onTap: () async {
                    _oldEndDate = _endDate?.clone();
                    DateTime? newEndDate = await DatePicker.showDatePicker(
                        context,
                        currentTime: _endDate,
                        minTime: _startDate,
                        onChanged: (DateTime dt) => setState(() => _endDate =
                            DateTime(
                                dt.year, dt.month, dt.day, 23, 59, 59, 999)),
                        onConfirm: (DateTime dt) => setState(() => _endDate =
                            DateTime(
                                dt.year, dt.month, dt.day, 23, 59, 59, 999)),
                        theme: DatePickerTheme(
                          cancelStyle: Theme.of(context).textTheme.button!,
                          doneStyle: Theme.of(context).textTheme.button!,
                          itemStyle: Theme.of(context).textTheme.bodyText2!,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                        ));

                    // if the user cancelled, this should be null
                    if (newEndDate == null) {
                      setState(() {
                        _endDate = _oldEndDate;
                      });
                    }
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: Text(L10N.of(context).tr.projects,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w700)),
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ElevatedButton(
                      child: Text(L10N.of(context).tr.selectNone),
                      onPressed: () {
                        setState(() {
                          selectedProjects.clear();
                        });
                      },
                    ),
                    ElevatedButton(
                      child: Text(L10N.of(context).tr.selectAll),
                      onPressed: () {
                        setState(() {
                          selectedProjects = <Project?>[null]
                              .followedBy(projectsBloc.state.projects
                                  .where((p) => !p.archived)
                                  .map((p) => Project.clone(p)))
                              .toList();
                        });
                      },
                    ),
                  ],
                ),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: 150,
                  ),
                  child: ListView(
                    children: <Project?>[null]
                        .followedBy(projectsBloc.state.projects
                            .where((p) => !p.archived))
                        .map((project) => CheckboxListTile(
                              secondary: ProjectColour(
                                project: project,
                              ),
                              title: Text(project?.name ??
                                  L10N.of(context).tr.noProject),
                              value: selectedProjects
                                  .any((p) => p?.id == project?.id),
                              activeColor:
                                  Theme.of(context).colorScheme.secondary,
                              onChanged: (_) => setState(() {
                                if (selectedProjects
                                    .any((p) => p?.id == project?.id)) {
                                  selectedProjects
                                      .removeWhere((p) => p?.id == project?.id);
                                } else {
                                  selectedProjects.add(project);
                                }
                              }),
                            ))
                        .toList(),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
