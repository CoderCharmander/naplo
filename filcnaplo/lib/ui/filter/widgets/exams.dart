import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo_kreta_api/models/exam.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/exam/exam_viewable.dart' as mobile;

List<DateWidget> getWidgets(List<Exam> providerExams) {
  List<DateWidget> items = [];
  for (var exam in providerExams) {
    items.add(DateWidget(
      key: exam.id,
      date: exam.writeDate.year != 0 ? exam.writeDate : exam.date,
      widget: mobile.ExamViewable(exam),
    ));
  }
  return items;
}
