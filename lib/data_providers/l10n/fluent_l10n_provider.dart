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

import 'package:fluent/fluent.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:timecop/data_providers/l10n/l10n_provider.dart';

class FluentL10NProvider extends L10NProvider {
  final FluentBundle _bundle;
  final List<Error> _errors = [];

  FluentL10NProvider._internal(this._bundle);

  static Future<FluentL10NProvider> load(Locale locale) async {
    final FluentBundle bundle = FluentBundle(locale.toLanguageTag());

    String src = "l10n/${locale.languageCode}.flt";
    // special handling of zh-CN, zh-TW & nb-NO for now
    switch (locale.languageCode) {
      case "zh":
        switch (locale.countryCode) {
          case "TW":
            src = "l10n/zh-TW.flt";
            break;
          default:
            src = "l10n/zh-CN.flt";
            break;
        }
        break;
      case "nb":
        src = "l10n/nb-NO.flt";
        break;
    }

    String messages = await rootBundle.loadString(src);
    bundle.addMessages(messages);

    return FluentL10NProvider._internal(bundle);
  }

  @override
  String get about => _bundle.format("about", errors: _errors);
  @override
  String get appDescription =>
      _bundle.format("appDescription", errors: _errors);
  @override
  String get appLegalese => _bundle.format("appLegalese", errors: _errors);
  @override
  String get appName => _bundle.format("appName", errors: _errors);
  @override
  String get areYouSureYouWantToDelete =>
      _bundle.format("areYouSureYouWantToDelete", errors: _errors);
  @override
  String get cancel => _bundle.format("cancel", errors: _errors);
  @override
  String get ok => _bundle.format("ok", errors: _errors);
  @override
  String get changeLog => _bundle.format("changeLog", errors: _errors);
  @override
  String get confirmDelete => _bundle.format("confirmDelete", errors: _errors);
  @override
  String get create => _bundle.format("create", errors: _errors);
  @override
  String get createNewProject =>
      _bundle.format("createNewProject", errors: _errors);
  @override
  String get delete => _bundle.format("delete", errors: _errors);
  @override
  String get deleteTimerConfirm =>
      _bundle.format("deleteTimerConfirm", errors: _errors);
  @override
  String get remove => _bundle.format("remove", errors: _errors);
  @override
  String get stopTimer => _bundle.format("stopTimer", errors: _errors);
  @override
  String get resumeTimer => _bundle.format("resumeTimer", errors: _errors);
  @override
  String get description => _bundle.format("description", errors: _errors);
  @override
  String get duration => _bundle.format("duration", errors: _errors);
  @override
  String get editProject => _bundle.format("editProject", errors: _errors);
  @override
  String get editTimer => _bundle.format("editTimer", errors: _errors);
  @override
  String get endTime => _bundle.format("endTime", errors: _errors);
  @override
  String get exportImport => _bundle.format("exportImport", errors: _errors);
  @override
  String get exportCSV => _bundle.format("exportCSV", errors: _errors);
  @override
  String get exportDatabase =>
      _bundle.format("exportDatabase", errors: _errors);
  @override
  String get importDatabase =>
      _bundle.format("importDatabase", errors: _errors);
  @override
  String get filter => _bundle.format("filter", errors: _errors);
  @override
  String get from => _bundle.format("from", errors: _errors);
  @override
  String get logoSemantics => _bundle.format("logoSemantics", errors: _errors);
  @override
  String get noProject => _bundle.format("noProject", errors: _errors);
  @override
  String get pleaseEnterAName =>
      _bundle.format("pleaseEnterAName", errors: _errors);
  @override
  String get project => _bundle.format("project", errors: _errors);
  @override
  String get projectName => _bundle.format("projectName", errors: _errors);
  @override
  String get projects => _bundle.format("projects", errors: _errors);
  @override
  String get readme => _bundle.format("readme", errors: _errors);
  @override
  String get runningTimers => _bundle.format("runningTimers", errors: _errors);
  @override
  String get save => _bundle.format("save", errors: _errors);
  @override
  String get sourceCode => _bundle.format("sourceCode", errors: _errors);
  @override
  String get startTime => _bundle.format("startTime", errors: _errors);
  @override
  String get timeH => _bundle.format("timeH", errors: _errors);
  @override
  String get to => _bundle.format("to", errors: _errors);
  @override
  String get whatAreYouDoing =>
      _bundle.format("whatAreYouDoing", errors: _errors);
  @override
  String get whatWereYouDoing =>
      _bundle.format("whatWereYouDoing", errors: _errors);
  @override
  String get noDescription => _bundle.format("noDescription", errors: _errors);
  @override
  String get archive => _bundle.format("archive", errors: _errors);
  @override
  String get unarchive => _bundle.format("unarchive", errors: _errors);
  @override
  String get startTimer => _bundle.format("startTimer", errors: _errors);
  @override
  String get stopAllTimers => _bundle.format("stopAllTimers", errors: _errors);
  @override
  String get startNewTimer => _bundle.format("startNewTimer", errors: _errors);
  @override
  String get timerMenu => _bundle.format("timerMenu", errors: _errors);
  @override
  String get closeMenu => _bundle.format("closeMenu", errors: _errors);
  @override
  String get search => _bundle.format("search", errors: _errors);
  @override
  String get setToCurrentTime =>
      _bundle.format("setToCurrentTime", errors: _errors);
  @override
  String timeCopDatabase(String date) => _bundle.format("timeCopDatabase",
      args: <String, dynamic>{"date": date}, errors: _errors);
  @override
  String timeCopEntries(String date) => _bundle.format("timeCopEntries",
      args: <String, dynamic>{"date": date}, errors: _errors);
  @override
  String get options => _bundle.format("options", errors: _errors);
  @override
  String get groupTimers => _bundle.format("groupTimers", errors: _errors);
  @override
  String get columns => _bundle.format("columns", errors: _errors);
  @override
  String get date => _bundle.format("date", errors: _errors);
  @override
  String get combinedProjectDescription =>
      _bundle.format("combinedProjectDescription", errors: _errors);
  @override
  String get reports => _bundle.format("reports", errors: _errors);
  @override
  String nHours(String hours) => _bundle.format("nHours",
      args: <String, dynamic>{"hours": hours}, errors: _errors);
  @override
  String get averageDailyHours =>
      _bundle.format("averageDailyHours", errors: _errors);
  @override
  String get totalProjectShare =>
      _bundle.format("totalProjectShare", errors: _errors);
  @override
  String get weeklyHours => _bundle.format("weeklyHours", errors: _errors);
  @override
  String get contributors => _bundle.format("contributors", errors: _errors);
  @override
  String get settings => _bundle.format("settings", errors: _errors);
  @override
  String get theme => _bundle.format("theme", errors: _errors);
  @override
  String get auto => _bundle.format("auto", errors: _errors);
  @override
  String get light => _bundle.format("light", errors: _errors);
  @override
  String get dark => _bundle.format("dark", errors: _errors);
  @override
  String get black => _bundle.format("black", errors: _errors);
  @override
  String langName(Locale locale) {
    switch (locale.languageCode) {
      case "ar":
        return "العربية";
      case "cs":
        return "Čeština";
      case "de":
        return "Deutsch";
      case "en":
        return "English";
      case "es":
        return "Español";
      case "fr":
        return "Français";
      case "hi":
        return "हिन्दी";
      case "id":
        return "Indonesia";
      case "it":
        return "Italiano";
      case "ja":
        return "日本語";
      case "ko":
        return "한국어";
      case "nb":
        return "Norsk Bokmål";
      case "pt":
        return "Português";
      case "ru":
        return "русский";
      case "tr":
        return "Türk";
      case "zh":
        {
          switch (locale.countryCode) {
            case "CN":
              return "中文（简体）";
            case "TW":
              return "中文（繁體）";
            default:
              return "中文";
          }
        }
    }
    return "<lang name>";
  }

  @override
  String get language => _bundle.format("language", errors: _errors);
  @override
  String get automaticLanguage {
    String langName = _bundle.format("langName", errors: _errors);
    return _bundle.format("automaticLanguage",
        args: <String, dynamic>{"langName": langName}, errors: _errors);
  }

  @override
  String get collapseDays => _bundle.format("collapseDays", errors: _errors);
  @override
  String get autocompleteDescription =>
      _bundle.format("autocompleteDescription", errors: _errors);
  @override
  String get defaultFilterStartDateToMonday =>
      _bundle.format("defaultFilterStartDateToMonday", errors: _errors);
  @override
  String get hours => _bundle.format("hours", errors: _errors);
  @override
  String get total => _bundle.format("total", errors: _errors);
  @override
  String get oneTimerAtATime =>
      _bundle.format("oneTimerAtATime", errors: _errors);
  @override
  String get selectAll => _bundle.format("selectAll", errors: _errors);
  @override
  String get selectNone => _bundle.format("selectNone", errors: _errors);
  @override
  String get showBadgeCounts =>
      _bundle.format("showBadgeCounts", errors: _errors);
  @override
  String get defaultFilterDays =>
      _bundle.format("defaultFilterDays", errors: _errors);
  @override
  String get invalidDatabaseFile =>
      _bundle.format("invalidDatabaseFile", errors: _errors);
  @override
  String get databaseImported =>
      _bundle.format("databaseImported", errors: _errors);
  @override
  String get storageAccessRequired =>
      _bundle.format("storageAccessRequired", errors: _errors);
  @override
  String get runningTimersNotificationTitle =>
      _bundle.format("runningTimersNotificationTitle", errors: _errors);
  @override
  String get runningTimersNotificationBody =>
      _bundle.format("runningTimersNotificationBody", errors: _errors);
  @override
  String get enableRunningTimersNotification =>
      _bundle.format("enableRunningTimersNotification", errors: _errors);
  @override
  String get notes => _bundle.format("notes", errors: _errors);
  @override
  String get noItemsFound => _bundle.format("noItemsFound", errors: _errors);
  @override
  String filterFrom(String dateFrom) => _bundle.format("filterFrom",
      args: <String, dynamic>{"dateFrom": dateFrom}, errors: _errors);
  @override
  String filterUntil(String dateUntil) => _bundle.format("filterUntil",
      args: <String, dynamic>{"dateUntil": dateUntil}, errors: _errors);
  @override
  String filterFromUntil(String dateFrom, String dateUntil) =>
      _bundle.format("filterFromUntil",
          args: <String, dynamic>{"dateFrom": dateFrom, "dateUntil": dateUntil},
          errors: _errors);
}
