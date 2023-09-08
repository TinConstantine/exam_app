import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:exam_app/call_api/models/department.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WebViewController controller = WebViewController()
    ..loadRequest(Uri.parse(
        'https://bachkhoahanoi.edu.vn/truongcaodangcongnghebachkhoahanoi/'));

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: WebViewWidget(
      controller: controller,
    ));
  }
}
