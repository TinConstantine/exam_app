import 'package:exam_app/call_api/models/exam.dart';
import 'package:get/get.dart';

class ExamController extends GetxController {
  late Exam myExam;
  RxInt? quantity;
  RxInt? remaingMin;
  RxInt remaingSec = 59.obs;
  List<String> listOfResult = [];
  String? idExam;
  void setExam(Exam exam) {
    myExam = exam;
    quantity = int.parse(myExam.quantity!).obs;
    remaingMin = (int.parse(myExam.time!) - 1).obs;
    listOfResult = exam.result!.toLowerCase().split('');
    idExam = myExam.sId;
  }

  void decreaseMin() {
    remaingMin!.value--;
  }

  void decreaseSec() {
    remaingSec.value--;
  }

  String compareResult(List<String> res) {
    int different = 0;
    int minLength =
        listOfResult.length < res.length ? listOfResult.length : res.length;
    for (int i = 0; i < minLength; i++) {
      if (res[i] != listOfResult[i]) {
        different++;
      }
    }
    return (10 / minLength * (minLength - different)).toStringAsFixed(2);
  }
}
