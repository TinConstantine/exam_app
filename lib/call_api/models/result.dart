import 'dart:convert';

import 'package:exam_app/global.dart';
import 'package:http/http.dart' as http;

class Result {
  String? sId;
  String? idExam;
  String? idUser;
  String? point;
  String? userRes;
  String? completeTime;
  int? iV;

  Result(
      {this.sId,
      this.idExam,
      this.idUser,
      this.point,
      this.userRes,
      this.completeTime,
      this.iV});

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    idExam = json['idExam'];
    idUser = json['idUser'];
    point = json['point'];
    userRes = json['userRes'];
    completeTime = json['completeTime'];
    iV = json['__v'];
  }
}

Future<String> postResult(
    http.Client client, Map<String, String> params) async {
  final responese = await client.post(Uri.parse(URI_POST_RES),
      body: jsonEncode(params), headers: {"Content-Type": "application/json"});
  if (responese.statusCode == 201) {
    return '';
  }
  if (responese.statusCode == 500) {
    return 'Something was wrong';
  }
  return 'Connection errors';
}

Future<List<Result>> getResult(http.Client client, String id) async {
  final response = await client.get(Uri.parse('$URI_GET_RES/$id'));
  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    List<dynamic> results = responseBody['data'];
    final listOfResult = results.map((e) => Result.fromJson(e)).toList();
    return listOfResult;
  }
  return [];
}
