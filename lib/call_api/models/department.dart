import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:exam_app/global.dart';

class Department {
  String? sId;
  String? idDepartment;
  String? nameDepartment;
  int? iV;

  Department({this.sId, this.idDepartment, this.nameDepartment, this.iV});

  Department.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    idDepartment = json['idDepartment'];
    nameDepartment = json['nameDepartment'];
    iV = json['__v'];
  }
}

Future<List<Department>> getAllDepartment(http.Client client) async {
  final response = await client.get(Uri.parse(URI_GET_ALL_DEPARTMENT));
  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    List<dynamic> departments = responseBody['data'];
    final listOfDepartment =
        departments.map((e) => Department.fromJson(e)).toList();
    return listOfDepartment;
  }
  throw Exception("Cannot get department from sever");
}
