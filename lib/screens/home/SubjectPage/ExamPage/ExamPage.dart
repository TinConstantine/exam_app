import 'package:exam_app/call_api/models/exam.dart';
import 'package:exam_app/controller/exam_controller.dart';
import 'package:exam_app/screens/home/SubjectPage/ExamPage/TakeExam/take_exam.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../global.dart';

class ExamPage extends StatelessWidget {
  String? idSub;
  ExamPage({super.key, this.idSub});
  final examController = Get.put(ExamController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'List of exams',
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.1,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: FutureBuilder(
              future: getExam(http.Client(), idSub!),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                }
                return snapshot.hasData
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final exam = snapshot.data![index];
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              onTap: () {
                                examController.setExam(exam);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const TakeExam(),
                                    ));
                              },
                              leading: Image.asset(learnImg),
                              title: Text('${exam.idExam}'),
                              subtitle: Text('${exam.nameExam}'),
                              trailing: SizedBox(
                                width: 60,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.timer,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text('${exam.time}')
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              },
            ),
          )),
    );
  }
}
