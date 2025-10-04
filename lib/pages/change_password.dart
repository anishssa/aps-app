import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/ButtonComponent.dart';
import '../components/CustomAppBarComponent.dart';
import '../components/InputComponent.dart';
import '../components/SnackBarComponent.dart';
import '../controllers/auth_controller.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  final authController = Get.put(AuthController());

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _oldPassObscureText = true;
  bool _newPassObscureText = true;
  bool _cPassObscureText = true;

  void _toggleOldPassword() {
    setState(() {
      _oldPassObscureText = !_oldPassObscureText;
    });
  }

  void _toggleNewPassword() {
    setState(() {
      _newPassObscureText = !_newPassObscureText;
    });
  }

  void _toggleCPassword() {
    setState(() {
      _cPassObscureText = !_cPassObscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarComponent(
        title: 'Change Password',
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 150,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: const Text(
                      'Change Password ',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InputComponent(
                    label: 'Old Password',
                    controller: oldPasswordController,
                    hintText: 'Enter old password',
                    obscureText: _oldPassObscureText,
                    prefixIcon: Icons.lock,
                    suffixIcon: _oldPassObscureText
                        ? Icons.visibility
                        : Icons.visibility_off,
                    suffixIconPressed: _toggleOldPassword,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // _controller.password = value ?? '';
                    },
                  ),
                  const SizedBox(height: 16),
                  InputComponent(
                    label: 'New Password',
                    controller: newPasswordController,
                    hintText: 'Enter new password',
                    obscureText: _newPassObscureText,
                    prefixIcon: Icons.lock,
                    suffixIcon: _newPassObscureText
                        ? Icons.visibility
                        : Icons.visibility_off,
                    suffixIconPressed: _toggleNewPassword,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // _controller.password = value ?? '';
                    },
                  ),
                  const SizedBox(height: 16),
                  InputComponent(
                    label: 'Confirm Password',
                    controller: confirmPasswordController,
                    hintText: 'Enter confirm password',
                    obscureText: _cPassObscureText,
                    prefixIcon: Icons.lock,
                    suffixIcon: _cPassObscureText
                        ? Icons.visibility
                        : Icons.visibility_off,
                    suffixIconPressed: _toggleCPassword,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value != null &&
                          value != newPasswordController.text) {
                        return 'Password does not match';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      // _controller.password = value ?? '';
                    },
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => authController.loading.value
                        ? const Center(child: CircularProgressIndicator())
                        : ButtonComponent(
                            text: 'Update',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                try {
                                  await authController.changePassword(
                                      oldPasswordController.text,
                                      newPasswordController.text,
                                      confirmPasswordController.text);

                                  SnackBarComponent.showSuccess(
                                    context,
                                    authController.message.value,
                                  );

                                  if (authController.isLoggedIn.value) {
                                    Get.offNamed('/profile');
                                  }
                                } catch (e) {
                                  SnackBarComponent.showError(
                                    context,
                                    e.toString(),
                                  );
                                }
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
