import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:exam_app/global.dart';

import '../../controller/common.dart';

class User {
  String? sId;
  String? name;
  String? username;
  String? phoneNumber;
  String? password;
  String? idDepartment;
  String? gender;
  String? address;

  User(
      {this.sId,
      this.name,
      this.username,
      this.password,
      this.idDepartment,
      this.gender,
      this.address});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    username = json['username'];
    password = json['password'];
    idDepartment = json['idDepartment'];
    gender = json['gender'];
    address = json['address'];
  }
}

Future<String> login(http.Client client, Map<String, String> params) async {
  final response = await client.post(Uri.parse(URI_LOGIN),
      body: jsonEncode(params), headers: {"Content-Type": "application/json"});
  Map<String, dynamic> responseBody = jsonDecode(response.body);
  if (response.statusCode == 200) {
    Map<String, dynamic> getId = responseBody['data'];
    Common.setId(getId['idDepartment']);
    Common.setIdUser(getId['_id']);
    Common.setName(getId['name']);
    return "";
  }
  if (response.statusCode == 500) {
    return responseBody['message'];
  }
  return 'Connection errors';
}

Future<String> register(http.Client client, Map<String, String> params) async {
  final response = await client.post(Uri.parse(URI_REGISTER),
      body: jsonEncode(params), headers: {"Content-Type": "application/json"});
  if (response.statusCode == 201) {
    return '';
  }
  if (response.statusCode == 500) {
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    return responseBody['message'];
  }
  return 'Connection errors';
}

Future<String> checkUsername(
    http.Client client, Map<String, String> params) async {
  final response = await client.post(Uri.parse(URI_CHECK),
      body: jsonEncode(params), headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    return "";
  }
  if (response.statusCode == 500) {
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    return responseBody['message'];
  }
  return 'Connection errors';
}

Future<String> updateUser(
    http.Client client, Map<String, String> params) async {
  final response = await client.post(Uri.parse(URI_UPDATE_USER),
      body: jsonEncode(params), headers: {"Content-Type": "application/json"});
  if (response.statusCode == 201) {
    return '';
  }
  return 'Connection error';
}
