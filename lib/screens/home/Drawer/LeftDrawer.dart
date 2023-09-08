import 'package:exam_app/controller/common.dart';
import 'package:exam_app/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:exam_app/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({super.key});

  @override
  State<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  int _seletedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.grey,
          ),
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage(userImg), fit: BoxFit.fill)),
              ),
              const SizedBox(height: 15),
              Text(
                'Hi: ${Common.nameUser}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
        ),
        _buiderDrawerItems(
          icon: Icons.account_box,
          title: 'Profile',
          index: 1,
        ),
        _buiderDrawerItems(icon: Icons.settings, title: 'Setting', index: 2),
        const Divider(
          height: 1,
          color: Colors.grey,
        ),
        _buiderDrawerItems(
            icon: Icons.logout,
            title: 'Log out',
            index: 4,
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLogin', false);
              await prefs.setString('email', "");
              await prefs.setString('password', "");
              if (context.mounted) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
              }
            }),
      ]),
    );
  }

  Widget _buiderDrawerItems(
      {IconData? icon, String? title, int? index, void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: index == _seletedIndex ? Colors.green[100] : null,
        child: ListTile(
          leading: Icon(icon),
          title: Text(
            title!,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
