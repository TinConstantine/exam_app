import 'package:exam_app/call_api/models/exam.dart';
import 'package:exam_app/call_api/models/subject.dart';
import 'package:exam_app/controller/theme.dart';
import 'package:exam_app/screens/home/Drawer/LeftDrawer.dart';
import 'package:flutter/material.dart';
import '../../controller/common.dart';
import 'HomePage/HomePage.dart';
import 'ResultPage/ResultPage.dart';
import 'SubjectPage/ExamPage/ExamPage.dart';
import 'SubjectPage/SubjectPage.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<BottomNavigationBarItem> _listItem = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Homepage'),
    const BottomNavigationBarItem(icon: Icon(Icons.subject), label: 'Subject'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.bar_chart_outlined), label: 'Result')
  ];
  final List<Widget> _listScreen = [
    const HomePage(),
    SubjectPage(),
    const ResultPage(),
  ];
  final themeController = Get.put(ThemeController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          drawer: const LeftDrawer(),
          body: Column(
            children: [
              const Padding(padding: EdgeInsets.all(10)),
              Row(children: [
                IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    icon: const Icon(Icons.menu)),
                Expanded(
                  //     child: TextField(
                  //   decoration: InputDecoration(
                  //       hintText: 'Search exam...',
                  //       prefixIcon: const Icon(Icons.search),
                  //       border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(10)),
                  //       contentPadding: const EdgeInsets.symmetric(vertical: 10)),
                  // )
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(
                            hintText: 'Search subject...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10))),
                    suggestionsCallback: (pattern) async {
                      return await searchSubject(
                          http.Client(), Common.idDeparByUser, pattern);
                    },
                    itemBuilder: (context, itemData) {
                      return Card(
                        child: ListTile(title: Text('${itemData.nameSubject}')),
                      );
                    },
                    onSuggestionSelected: (subject) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExamPage(
                              idSub: subject.idSubject,
                            ),
                          ));
                    },
                  ),
                ),
                IconButton(
                    onPressed: () {
                      themeController.toggleTheme();
                    },
                    icon: Obx(() => themeController.isDarkmode.value
                        ? const Icon(Icons.dark_mode)
                        : const Icon(Icons.light_mode)))
              ]),
              _listScreen[_currentIndex]
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: _listItem,
            backgroundColor: Colors.grey.shade300,
            selectedItemColor: Colors.blueAccent.shade200,
            unselectedItemColor: Colors.grey.shade600,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          )),
    );
  }
}
