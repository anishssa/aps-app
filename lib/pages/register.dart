import 'package:aps_app/components/GradientText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/HaveAccountComponent.dart';
import '../components/InputComponent.dart';
import '../components/ButtonComponent.dart';
import '../components/SnackBarComponent.dart';
import '../controllers/auth_controller.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final _controller = Get.find<AuthController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool _passObscureText = true;
  bool _cPassObscureText = true;

  void _togglePassword() {
    setState(() {
      _passObscureText = !_passObscureText;
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
                  child: const GradientText(
                    'Register ',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InputComponent(
                  label: 'Name',
                  controller: nameController,
                  prefixIcon: Icons.account_box,
                  hintText: 'Enter your name',
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // _controller.username = value ?? '';
                  },
                ),
                const SizedBox(height: 16),
                InputComponent(
                  label: 'Email',
                  controller: emailController,
                  prefixIcon: Icons.email,
                  hintText: 'Enter your email',
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter a email';
                    }
                    if (value != null &&
                        (!value.contains('@') || !value.contains('.'))) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // _controller.username = value ?? '';
                  },
                ),
                const SizedBox(height: 16),
                InputComponent(
                  label: 'Phone',
                  controller: phoneController,
                  prefixIcon: Icons.phone_android,
                  hintText: 'Enter your phone',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter a phone';
                    }
                    if (value != null && value.length != 10) {
                      return 'Phone number must be 10 digits';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // _controller.username = value ?? '';
                  },
                ),
                const SizedBox(height: 16),
                InputComponent(
                  label: 'Password',
                  controller: passwordController,
                  hintText: 'Enter your password',
                  obscureText: _passObscureText,
                  prefixIcon: Icons.lock,
                  suffixIcon: _passObscureText
                      ? Icons.visibility
                      : Icons.visibility_off,
                  suffixIconPressed: _togglePassword,
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
                  hintText: 'Enter your password',
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
                    if (value != null && value != passwordController.text) {
                      return 'Password does not match';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    // _controller.password = value ?? '';
                  },
                ),
                const SizedBox(height: 25),
                Obx(
                  () => _controller.loading.value
                      ? const Center(child:  CircularProgressIndicator())
                      : ButtonComponent(
                          text: 'Sign Up',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                await _controller.register(
                                    nameController.text,
                                    emailController.text,
                                    passwordController.text,
                                    phoneController.text);
                                Get.offNamed('/login');
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
                const SizedBox(height: 16),
                HaveAccountComponent(
                  text: 'Already have an account?',
                  actionText: 'Sign In',
                  onPressed: () {
                    Get.offNamed('/login');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
