import 'package:filcnaplo/api/providers/update_provider.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo/ui/filter/widgets/grades.dart' as grade_filter;
import 'package:filcnaplo/ui/filter/widgets/certifications.dart' as certification_filter;
import 'package:filcnaplo/ui/filter/widgets/messages.dart' as message_filter;
import 'package:filcnaplo/ui/filter/widgets/absences.dart' as absence_filter;
import 'package:filcnaplo/ui/filter/widgets/homework.dart' as homework_filter;
import 'package:filcnaplo/ui/filter/widgets/exams.dart' as exam_filter;
import 'package:filcnaplo/ui/filter/widgets/notes.dart' as note_filter;
import 'package:filcnaplo/ui/filter/widgets/events.dart' as event_filter;
import 'package:filcnaplo/ui/filter/widgets/lessons.dart' as lesson_filter;
import 'package:filcnaplo/ui/filter/widgets/update.dart' as update_filter;
import 'package:filcnaplo/ui/filter/widgets/missed_exams.dart' as missed_exam_filter;
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/event_provider.dart';
import 'package:filcnaplo_kreta_api/providers/exam_provider.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/providers/homework_provider.dart';
import 'package:filcnaplo_kreta_api/providers/message_provider.dart';
import 'package:filcnaplo_kreta_api/providers/note_provider.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:provider/provider.dart';

const List<FilterType> homeFilters = [FilterType.all, FilterType.grades, FilterType.messages, FilterType.absences];

enum FilterType { all, grades, messages, absences, homework, exams, notes, events, lessons, updates, certifications, missedExams }

Future<List<DateWidget>> getFilterWidgets(FilterType activeData, {bool absencesNoExcused = false, required BuildContext context}) async {
  final gradeProvider = Provider.of<GradeProvider>(context);
  final timetableProvider = Provider.of<TimetableProvider>(context);
  final messageProvider = Provider.of<MessageProvider>(context);
  final absenceProvider = Provider.of<AbsenceProvider>(context);
  final homeworkProvider = Provider.of<HomeworkProvider>(context);
  final examProvider = Provider.of<ExamProvider>(context);
  final noteProvider = Provider.of<NoteProvider>(context);
  final eventProvider = Provider.of<EventProvider>(context);
  final updateProvider = Provider.of<UpdateProvider>(context);

  List<DateWidget> items = [];

  switch (activeData) {
    // All
    case FilterType.all:
      final all = await Future.wait<List<DateWidget>>([
        getFilterWidgets(FilterType.grades, context: context),
        getFilterWidgets(FilterType.lessons, context: context),
        getFilterWidgets(FilterType.messages, context: context),
        getFilterWidgets(FilterType.absences, context: context, absencesNoExcused: true),
        getFilterWidgets(FilterType.homework, context: context),
        getFilterWidgets(FilterType.exams, context: context),
        getFilterWidgets(FilterType.updates, context: context),
        getFilterWidgets(FilterType.certifications, context: context),
        getFilterWidgets(FilterType.missedExams, context: context),
      ]);
      items = all.expand((x) => x).toList();

      break;

    // Grades
    case FilterType.grades:
      items = grade_filter.getWidgets(gradeProvider.grades);
      break;

    // Certifications
    case FilterType.certifications:
      items = certification_filter.getWidgets(gradeProvider.grades);
      break;

    // Messages
    case FilterType.messages:
      items = message_filter.getWidgets(
        messageProvider.messages,
        noteProvider.notes,
        eventProvider.events,
      );
      break;

    // Absences
    case FilterType.absences:
      items = absence_filter.getWidgets(absenceProvider.absences, noExcused: absencesNoExcused);
      break;

    // Homework
    case FilterType.homework:
      items = homework_filter.getWidgets(homeworkProvider.homework);
      break;

    // Exams
    case FilterType.exams:
      items = exam_filter.getWidgets(examProvider.exams);
      break;

    // Notes
    case FilterType.notes:
      items = note_filter.getWidgets(noteProvider.notes);
      break;

    // Events
    case FilterType.events:
      items = event_filter.getWidgets(eventProvider.events);
      break;

    // Changed Lessons
    case FilterType.lessons:
      items = lesson_filter.getWidgets(timetableProvider.lessons);
      break;

    // Updates
    case FilterType.updates:
      if (updateProvider.releases.isNotEmpty) items = [update_filter.getWidget(updateProvider.releases.first)];
      break;

    // Missed Exams
    case FilterType.missedExams:
      items = missed_exam_filter.getWidgets(timetableProvider.lessons);
      break;
  }
  return items;
}

Widget filterItemBuilder(BuildContext context, Animation<double> animation, Widget item, int index) {
  final wrappedItem = SizeFadeTransition(
    curve: Curves.easeInOutCubic,
    animation: animation,
    child: item,
  );
  return item is Panel
      // Re-add & animate shadow
      ? AnimatedBuilder(
          animation: animation,
          child: wrappedItem,
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: [
                    if (Theme.of(context).brightness == Brightness.light)
                      BoxShadow(
                        offset: const Offset(0, 21),
                        blurRadius: 23.0,
                        color: AppColors.of(context).shadow.withOpacity(
                              CurvedAnimation(
                                parent: CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
                                curve: const Interval(2 / 3, 1.0),
                              ).value,
                            ),
                      ),
                  ],
                ),
                child: child,
              ),
            );
          })
      : wrappedItem;
}
