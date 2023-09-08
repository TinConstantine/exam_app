import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:exam_app/global.dart';

class Subject {
  String? sId;
  String? idDepartment;
  String? idSubject;
  String? nameSubject;
  int? iV;

  Subject(
      {this.sId, this.idDepartment, this.idSubject, this.nameSubject, this.iV});

  Subject.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    idDepartment = json['idDepartment'];
    idSubject = json['idSubject'];
    nameSubject = json['nameSubject'];
    iV = json['__v'];
  }
}

Future<List<Subject>> getSubject(http.Client client, String id) async {
  final response = await client.get(Uri.parse('$URI_SUBJECT/$id'));
  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    List<dynamic> subjects = responseBody['data'];
    final listOfSubject = subjects.map((e) => Subject.fromJson(e)).toList();
    return listOfSubject;
  }
  return [];
}

Future<List<Subject>> searchSubject(
    http.Client client, String id, String query) async {
  final response = await client.get(Uri.parse('$URI_SUBJECT/$id'));
  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    List<dynamic> subjects = responseBody['data'];
    final listOfSubject =
        subjects.map((e) => Subject.fromJson(e)).where((element) {
      final nameLower = element.nameSubject!.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();
    return listOfSubject;
  } else {
    throw Exception();
  }
}
