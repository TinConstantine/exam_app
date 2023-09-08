import 'package:exam_app/call_api/models/exam.dart';
import 'package:exam_app/call_api/models/result.dart';
import 'package:flutter/material.dart';
import '../../../controller/common.dart';
import 'package:http/http.dart' as http;

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: getResult(http.Client(), Common.idUser),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.hasError);
          }
          return snapshot.hasData
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final res = snapshot.data![index];
                    return Card(
                      child: ListTile(
                          subtitle: Text('${res.completeTime}'),
                          title: FutureBuilder(
                            future: getExamById(http.Client(), res.idExam!),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                print(snapshot.error);
                              }
                              return snapshot.hasData
                                  ? Text('${snapshot.data!.idExam}')
                                  : Text('${res.idExam}');
                            },
                          ),
                          trailing: Text('${res.point}')),
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
