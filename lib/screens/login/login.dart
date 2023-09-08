import 'package:exam_app/screens/home/home.dart';
import 'package:exam_app/screens/login/ForgotPass/ForgotPass.dart';
import 'package:exam_app/screens/login/register/register.dart';
import 'package:exam_app/validators/InputValidator.dart';
import 'package:exam_app/validators/PasswordValidator.dart';
import 'package:flutter/material.dart';
import 'package:exam_app/global.dart';
import 'package:exam_app/call_api/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _hidePass = true;
  final _usernameController = TextEditingController();
  final _passwordControler = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                image:
                                    DecorationImage(image: AssetImage(logo))),
                          ),
                        ),
                        _buildTextField(
                            hintText: 'Enter your email',
                            iconData: Icons.person,
                            validator: InputValidator.isValidEmailOrPhone,
                            controller: _usernameController),
                        const SizedBox(height: 15),
                        _buildTextField(
                            controller: _passwordControler,
                            validator: PasswordValidator.validatePassword,
                            obscureText: _hidePass,
                            hintText: 'Enter your password',
                            iconData: Icons.key,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _hidePass = !_hidePass;
                                  });
                                },
                                icon: _hidePass
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility))),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ForgotPass(),
                                  ));
                            },
                            child: const Text('Forgot Password ?'),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 100,
                          child: ElevatedButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _formKey.currentState!.save();
                                  Map<String, String> params = {};
                                  params['username'] = _usernameController.text;
                                  params['password'] = _passwordControler.text;
                                  String res =
                                      await login(http.Client(), params);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  if (res.isEmpty) {
                                    await prefs.setBool('isLogin', true);
                                    await prefs.setString(
                                        'username', _usernameController.text);
                                    await prefs.setString(
                                        'password', _passwordControler.text);
                                    if (context.mounted) {
                                      // showCustomDialog(context,
                                      //     'Login Successfully', DialogType.info);
                                      print(prefs.getString('username'));
                                      Get.snackbar(
                                          "Notification", "Login Successfully");
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen(),
                                          ));
                                    }
                                  } else {
                                    if (context.mounted) {
                                      // showCustomDialog(
                                      //     context, res, DialogType.error);
                                      Get.snackbar("Error", res);
                                    }
                                  }
                                } else {
                                  if (context.mounted) {
                                    // showCustomDialog(
                                    //     context,
                                    //     'Incorrect email or password',
                                    //     DialogType.error);
                                    Get.snackbar("Invalid input",
                                        "Please enter a valid gmail, phone number or password.");
                                  }
                                }
                              },
                              child: const Text('Login')),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an Account ?'),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterScreen(),
                                      ));
                                },
                                child: const Text("Sign Up"))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget _buildTextField(
      {required String hintText,
      required IconData iconData,
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
          Icon(iconData),
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
