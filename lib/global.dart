import 'package:flutter/material.dart';

const String background = 'assets/images/bgm.jpeg';
const String logo = 'assets/images/logo.png';
const String userImg = 'assets/images/user.jpg';
const String learnImg = 'assets/images/learn.png';
const String subImg = 'assets/images/subject.png';
const SERVER_NAME = 'http://192.168.167.147:8008';
// const SERVER_NAME = 'https://exam-backend-qarq.onrender.com';
const URI_LOGIN = '$SERVER_NAME/user/login';
const URI_GET_ALL_DEPARTMENT = '$SERVER_NAME/department/json';
const URI_REGISTER = '$SERVER_NAME/user/register';
const URI_SUBJECT = '$SERVER_NAME/subject/json';
const URI_EXAM = '$SERVER_NAME/exam/json';
const URI_VIEW_DOC = '$SERVER_NAME/view-doc';
const URI_CHECK = '$SERVER_NAME/user/check';
const URI_POST_RES = '$SERVER_NAME/result';
const URI_GET_RES = '$SERVER_NAME/result/user';
const URI_GET_EXAM_BY_ID = '$SERVER_NAME/exam';
const URI_UPDATE_USER = '$SERVER_NAME/user/update';

enum DialogType { error, info, warning }

void showCustomDialog(BuildContext context, String message, DialogType type) {
  IconData icon;
  Color iconColor;
  Color? backgroundColor;

  switch (type) {
    case DialogType.error:
      icon = Icons.error;
      iconColor = Colors.red;
      backgroundColor = Colors.red[100]!;
      break;
    case DialogType.info:
      icon = Icons.info;
      iconColor = Colors.blue;
      backgroundColor = Colors.blue[100];
      break;
    case DialogType.warning:
      icon = Icons.warning;
      iconColor = Colors.orange;
      backgroundColor = Colors.orange[100];
      break;
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: backgroundColor,
        title: Icon(
          icon,
          color: iconColor,
          size: 40,
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
