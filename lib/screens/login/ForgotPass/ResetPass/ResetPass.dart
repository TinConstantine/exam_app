import 'package:exam_app/call_api/models/user.dart';
import 'package:exam_app/controller/common.dart';
import 'package:exam_app/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:exam_app/validators/PasswordValidator.dart';
import 'package:get/get.dart';
import 'package:exam_app/global.dart';
import 'package:http/http.dart' as http;

class ResetPass extends StatelessWidget {
  const ResetPass({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            background,
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          const ResetPassBody(),
        ],
      ),
    );
  }
}

class ResetPassBody extends StatefulWidget {
  const ResetPassBody({super.key});

  @override
  State<ResetPassBody> createState() => _ResetPassBodyState();
}

class _ResetPassBodyState extends State<ResetPassBody> {
  final _newPasswordController = TextEditingController();
  final _repeatNewPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _hidePass = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Form(
        key: _formKey,
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextField(
                  hintText: 'New password',
                  controller: _newPasswordController,
                  validator: PasswordValidator.validatePassword,
                  obscureText: _hidePass,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _hidePass = !_hidePass;
                        });
                      },
                      icon: _hidePass
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility))),
              const SizedBox(
                height: 10,
              ),
              _buildTextField(
                  hintText: 'Repeat new password',
                  controller: _repeatNewPasswordController,
                  validator: PasswordValidator.validatePassword,
                  obscureText: true),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width - 200,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_newPasswordController.text ==
                            _repeatNewPasswordController.text) {
                          Map<String, String> params = {};
                          params['username'] = Common.userNameUpdate;
                          params['password'] = _newPasswordController.text;

                          String check =
                              await updateUser(http.Client(), params);
                          if (check.isEmpty) {
                            Get.snackbar(
                                'Notifycation', 'Update password successful');
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ));
                            }
                          } else {
                            Get.snackbar('Error', check);
                          }
                        } else {
                          Get.snackbar('Error', 'Repeat password incorrect');
                        }
                      } else {
                        Get.snackbar('Invalid input',
                            'Please enter a valid new password');
                      }
                    },
                    child: const Text('Reset password')),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String hintText,
      Function(String)? onChanged,
      Widget? suffixIcon,
      bool obscureText = false,
      TextEditingController? controller,
      String? Function(String?)? validator}) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          Expanded(
              child: TextFormField(
            controller: controller,
            decoration: InputDecoration(hintText: hintText),
            onChanged: onChanged,
            obscureText: obscureText,
            validator: validator,
          )),
          if (suffixIcon != null) suffixIcon
        ],
      ),
    );
  }
}
