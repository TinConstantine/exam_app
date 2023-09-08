import 'dart:convert';

import 'package:exam_app/global.dart';
import 'package:http/http.dart' as http;

class Exam {
  String? sId;
  String? idSubject;
  String? idExam;
  String? nameExam;
  String? file;
  String? result;
  String? time;
  String? quantity;
  int? iV;

  Exam(
      {this.sId,
      this.idSubject,
      this.idExam,
      this.nameExam,
      this.file,
      this.result,
      this.time,
      this.quantity,
      this.iV});

  Exam.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    idSubject = json['idSubject'];
    idExam = json['idExam'];
    nameExam = json['nameExam'];
    file = json['file'];
    result = json['result'];
    time = json['time'];
    quantity = json['quantity'];
    iV = json['__v'];
  }
}

Future<List<Exam>> getExam(http.Client client, String id) async {
  final response = await client.get(Uri.parse('$URI_EXAM/$id'));

  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody = jsonDecode(response.body);

    List<dynamic> exams = responseBody['data'];
    final listOfExam = exams.map((e) => Exam.fromJson(e)).toList();

    return listOfExam;
  }
  return [];
}


Future<Exam> getExamById(http.Client client, String id) async {
  final response = await client.get(Uri.parse('$URI_GET_EXAM_BY_ID/$id'));
  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    dynamic myExam = responseBody['data'];
    final exam = Exam.fromJson(myExam);
    return exam;
  }
  return Exam();
}
