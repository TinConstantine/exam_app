import 'package:exam_app/call_api/models/subject.dart';
import 'package:exam_app/global.dart';
import 'package:exam_app/screens/home/SubjectPage/ExamPage/ExamPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../controller/common.dart';

class SubjectPage extends StatelessWidget {
  SubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
            future: getSubject(http.Client(), Common.idDeparByUser),
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
                        final subject = snapshot.data![index];
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExamPage(
                                      idSub: subject.idSubject,
                                    ),
                                  ));
                            },
                            title: Text(subject.idSubject.toString()),
                            subtitle: Text(subject.nameSubject.toString()),
                            leading: Image.asset(subImg,
                                color: Colors.grey.shade800),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            }),
      ),
    );
  }
}
