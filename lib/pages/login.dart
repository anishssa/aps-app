import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/HaveAccountComponent.dart';
import '../components/InputComponent.dart';
import '../components/ButtonComponent.dart';
import '../components/SnackBarComponent.dart';
import '../components/GradientText.dart';
import './../controllers/auth_controller.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final _controller = Get.find<AuthController>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
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
                  const SizedBox(height: 75),
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 150,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: GradientText(
                      'Login',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InputComponent(
                    label: 'Email or Phone',
                    controller: emailController,
                    prefixIcon: Icons.email,
                    hintText: 'Enter your email or phone number',
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter your email or phone number';
                      }
                      return null;
                    },
                    onSaved: (value) => _controller.email = value ?? '',
                  ),
                  const SizedBox(height: 16),
                  InputComponent(
                    label: 'Password',
                    controller: passwordController,
                    hintText: 'Enter your password',
                    obscureText: _obscureText,
                    prefixIcon: Icons.lock,
                    suffixIcon: _obscureText
                        ? Icons.visibility
                        : Icons.visibility_off,
                    suffixIconPressed: _toggle,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    onSaved: (value) => _controller.password = value ?? '',
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed('/forgot-password');
                      },
                      child: GradientText(
                        "Forgot Password?",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                        () => _controller.loading.value
                        ? const Center(child:  CircularProgressIndicator())
                        : ButtonComponent(
                      text: 'Sign In',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          try {
                            await _controller.login();

                            if (_controller.isLoggedIn.value) {
                              Get.offNamed('/service');
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
                  const SizedBox(height: 16),
                  HaveAccountComponent(
                    text: 'Don\'t have an account?',
                    actionText: 'Sign Up',
                    onPressed: () {
                      Get.offNamed('/register');
                    },
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
