import 'dart:async';

import 'package:exam_app/call_api/models/department.dart';
import 'package:exam_app/call_api/models/user.dart';
import 'package:exam_app/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:exam_app/validators/InputValidator.dart';
import 'package:exam_app/validators/PasswordValidator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:exam_app/global.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;
  String? _selectedGender;
  String? selectDepartment;
  bool _hidePass = true;
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent, // Đặt màu nền trong suốt
          elevation: 0, // Đặt độ đổ bóng của AppBar thành 0 để loại bỏ đổ bóng
        ),
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
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            _buildTextField(
                              hintText: "Full name",
                              controller: _fullNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Full name is required';
                                }
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: [
                                  const Text('Gender'),
                                  const SizedBox(width: 20),
                                  _radioGender(
                                      value: 'Male',
                                      groupValue: _selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedGender = value;
                                        });
                                      }),
                                  const SizedBox(width: 10),
                                  const Text('Male'),
                                  const SizedBox(width: 20),
                                  _radioGender(
                                      value: 'Female',
                                      groupValue: _selectedGender,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedGender = value;
                                        });
                                      }),
                                  const SizedBox(width: 10),
                                  const Text('Female'),
                                ],
                              ),
                            ),
                            FutureBuilder(
                              future: getAllDepartment(http.Client()),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  print(snapshot.hasError);
                                }
                                List<Department> listDepartment =
                                    snapshot.data ?? [];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Row(
                                    children: [
                                      const Text('Department'),
                                      const SizedBox(width: 20),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child:
                                              dropDownButton(listDepartment)),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _buildTextField(
                                hintText: 'Email or phone number',
                                validator: InputValidator.isValidEmailOrPhone,
                                controller: _usernameController),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _buildTextField(
                                hintText: "Password",
                                validator: PasswordValidator.validatePassword,
                                controller: _passwordController,
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
                                hintText: "Repeat password",
                                validator: PasswordValidator.validatePassword,
                                controller: _repeatPasswordController),
                            const SizedBox(
                              height: 10,
                            ),
                            _buildTextField(
                              hintText: "Address",
                              controller: _addressController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Address is reqired';
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 200,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (_passwordController.text !=
                                        _repeatPasswordController.text) {
                                      Get.snackbar(
                                          'Error', 'Repeat password incorrect');
                                    }
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      Map<String, String> params = {};
                                      params['name'] = _fullNameController.text;
                                      params['username'] =
                                          _usernameController.text;
                                      params['password'] =
                                          _passwordController.text;
                                      params['gender'] =
                                          _selectedGender ?? 'Female';
                                      params['address'] =
                                          _addressController.text;
                                      params['idDepartment'] =
                                          selectDepartment ?? 'None';
                                      String res =
                                          await register(http.Client(), params);
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      if (res.isEmpty) {
                                        Get.snackbar(
                                            'Notification', 'Sign Up Success');
                                        if (context.mounted) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen(),
                                              ));
                                        }
                                      } else {
                                        Get.snackbar('Sign up failed', res);
                                      }
                                    } else {
                                      Get.snackbar('Invalid input',
                                          'Please enter a valid gmail or phone number');
                                    }
                                  },
                                  child: const Text('Sign up')),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ));
  }

  DropdownButton<String> dropDownButton(List<Department> listDepartment) {
    return DropdownButton(
      items: listDepartment
          .map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(
              value: e.idDepartment, child: Text('    ${e.idDepartment!}    ')))
          .toList(),
      onChanged: (String? value) {
        setState(() {
          selectDepartment = value;
        });
      },
      value: selectDepartment,
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

  Widget _radioGender(
      {required String value,
      String? groupValue,
      Function(String?)? onChanged}) {
    return Radio(value: value, groupValue: groupValue, onChanged: onChanged);
  }
}
