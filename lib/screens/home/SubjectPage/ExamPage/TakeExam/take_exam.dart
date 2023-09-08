import 'package:exam_app/controller/exam_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../../controller/common.dart';
import '../../../../../global.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../../../../call_api/models/result.dart';

class TakeExam extends StatefulWidget {
  const TakeExam({super.key});

  @override
  State<TakeExam> createState() => _TakeExamState();
}

class _TakeExamState extends State<TakeExam> {
  final examController = Get.put(ExamController());
  DateTime now = DateTime.now();
  bool _buttonEnable = true;
  List<String>? resultValues;
  Timer? _timer;
  bool _isLoading = false;
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (examController.remaingMin!.value <= 0 &&
          examController.remaingSec.value <= 0) {
        setState(() {
          _buttonEnable = false;
        });

        timer.cancel();
        submit();
      } else if (examController.remaingSec.value <= 0) {
        examController.decreaseMin();
        examController.remaingSec.value = 59;
      } else {
        examController.decreaseSec();
      }
    });
  }

  void submit() async {
    Map<String, String> params = {};
    params['idExam'] = examController.idExam!;
    params['idUser'] = Common.idUser;
    params['point'] = examController.compareResult(resultValues!);
    params['userRes'] = resultValues!.join("").toLowerCase();
    params['completeTime'] = now.toString();
    setState(() {
      _isLoading = true;
    });
    String check = await postResult(http.Client(), params);
    setState(() {
      _isLoading = false;
    });
    if (check.isEmpty) {
      Get.snackbar('Notification', 'Successful submission');
      if (context.mounted) {
        Navigator.pop(context);
      }
    } else {
      Get.snackbar('Error', check);
    }
  }

  @override
  void initState() {
    super.initState();
    resultValues = List.filled(examController.quantity!.value, "");
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    examController.remaingSec.value = 59;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Colors.transparent,
          title: Obx(() => examController.remaingSec.value < 0
              ? Text(
                  '${examController.remaingMin}:0${examController.remaingSec}')
              : Text(
                  '${examController.remaingMin}:${examController.remaingSec}')),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: submit,
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ))
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: WebViewWidget(
                          controller: WebViewController()
                            ..loadRequest(Uri.parse(
                                '$URI_VIEW_DOC/${examController.myExam.file}'))),
                    )),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_buttonEnable) {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return modalButtonSheet();
                },
              );
            } else {
              Null;
            }
          },
          backgroundColor: Colors.grey,
          child: const Icon(Icons.draw),
        ),
      ),
    );
  }

  Widget modalButtonSheet() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GridView.builder(
        itemCount: resultValues!.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemBuilder: (context, index) {
          return Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Text('${index + 1}:'),
                Expanded(
                  child: TextField(
                    controller:
                        TextEditingController(text: resultValues![index]),
                    // style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.deny(RegExp(r'\s'))
                    ],
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                      resultValues![index] = value.toLowerCase();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
