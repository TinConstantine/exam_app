import 'package:exam_app/call_api/models/user.dart';
import 'package:exam_app/controller/common.dart';
import 'package:exam_app/controller/email_auth_controller.dart';
import 'package:exam_app/screens/login/ForgotPass/ResetPass/ResetPass.dart';
import 'package:exam_app/validators/CommonValidator.dart';
import 'package:exam_app/validators/InputValidator.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:exam_app/global.dart';
import 'package:http/http.dart' as http;
import 'package:exam_app/controller/phone_auth_controller.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  bool _isEmail = false;
  String _verifyCode = "";
  bool _buttonEnable = true;
  int _remaingTime = 30;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  Timer? _timer;
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaingTime <= 0) {
        setState(() {
          _buttonEnable = true;
        });
        timer.cancel();
        print(_remaingTime);
      } else {
        setState(() {
          _remaingTime--;
        });
      }
    });
  }

  void _onButtonPress() async {
    if (_formKey.currentState!.validate()) {
      String userName = _usernameController.text;
      if (CommonValidator.isValidEmail(userName)) {
        _isEmail = true;
        sendOTP(_usernameController.text.trim());
      }
      if (CommonValidator.isValidPhoneNumber(userName)) {
        PhoneAuthController.sendOtp(_usernameController.text);
      }
      if (_buttonEnable) {
        setState(() {
          _buttonEnable = false;
          _remaingTime = 30;
        });
        _startTimer();
      }
    } else {
      Get.snackbar(
          'Invalid input', 'Please enter a valid gmail or phone number');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Image.asset(
                  background,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Form(
                  key: _formKey,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textFieldWithButton(context,
                            textField: _buildTextField(
                                hintText: 'Enter phone number / gmail',
                                controller: _usernameController,
                                validator: InputValidator.isValidEmailOrPhone),
                            childButton: TextButton(
                                onPressed: () {
                                  if (_buttonEnable) {
                                    _onButtonPress();
                                  } else {
                                    null;
                                  }
                                },
                                child: _buttonEnable
                                    ? const Text('Send OTP')
                                    : Text('$_remaingTime'))),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildTextField(
                          hintText: 'Enter the OTP verification code',
                          controller: _otpController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 200,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate() ||
                                    _otpController.text.isNotEmpty) {
                                  Map<String, String> params = {};
                                  params['username'] = _usernameController.text;
                                  String check = await checkUsername(
                                      http.Client(), params);
                                  if (check.isEmpty) {
                                    if (_isEmail) {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      bool checkOtp = await verifyOTP(
                                        _otpController.text.trim(),
                                      );
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      if (checkOtp) {
                                        Get.snackbar('Notification',
                                            'verification sucessfully');
                                        if (context.mounted) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ResetPass(),
                                              ));
                                        }
                                      } else {
                                        Get.snackbar(
                                            'Notification', 'Wrong OTP ');
                                      }
                                    } else {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      bool checkPhone =
                                          await PhoneAuthController.verifyPhone(
                                              _otpController.text.trim());
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      if (checkPhone) {
                                        Get.snackbar('Notification',
                                            'verification sucessfully');
                                        Common.setUserNameUpdate(
                                            _usernameController.text);
                                        if (context.mounted) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ResetPass(),
                                              ));
                                        }
                                      } else {
                                        Get.snackbar(
                                            'Notification', 'Wrong OTP ');
                                      }
                                    }
                                  } else {
                                    Get.snackbar('Notification',
                                        'Email/phone number does not exist');
                                  }
                                } else {
                                  Get.snackbar('Invalid input',
                                      'Please enter a valid gmail or phone number and otp code');
                                }
                              },
                              child: const Text('Send')),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Container textFieldWithButton(BuildContext context,
      {required Widget textField,
      void Function()? onPressedOTP,
      required Widget? childButton}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      height: 50,
      width: MediaQuery.of(context).size.width - 50,
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          Flexible(
            flex: 4,
            child: textField,
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: ElevatedButton(
                  style: const ButtonStyle(
                      // backgroundColor: MaterialStatePropertyAll(Colors.white)
                      ),
                  onPressed: onPressedOTP,
                  child: childButton),
            ),
          )
        ],
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
