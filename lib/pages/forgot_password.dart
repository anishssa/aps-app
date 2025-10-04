import 'package:aps_app/components/GradientText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../components/CustomAppBarComponent.dart';
import '../components/OtpInputComponent.dart';
import '../components/InputComponent.dart';
import '../components/ButtonComponent.dart';
import '../components/SnackBarComponent.dart';
import './../controllers/forgot_password_controller.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  final _controller = Get.put(ForgotPasswordController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
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

  Future<void> _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _controller.checkOtp();
        _controller.form.value = 'password';
        SnackBarComponent.showSuccess(
          context,
          _controller.message.value,
        );
      } catch (e) {
        SnackBarComponent.showError(
          context,
          e.toString(),
        );
      }
    }
  }

  Widget _buildEmailField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 100),
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
            'Email Verification',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        InputComponent(
          label: 'Email',
          controller: emailController,
          prefixIcon: Icons.email,
          hintText: 'Enter your email',
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Please enter an email';
            }
            if (value != null &&
                (!value.contains('@') || !value.contains('.'))) {
              return 'Please enter a valid email';
            }
            return null;
          },
          onSaved: (value) => _controller.email = value ?? '',
        ),
        const SizedBox(height: 26),
        Obx(
          () => _controller.loading.value
              ? const Center(child: CircularProgressIndicator())
              : ButtonComponent(
                  text: 'Send',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      try {
                        await _controller.getOtp();
                        _controller.form.value = 'otp';
                        SnackBarComponent.showSuccess(
                          context,
                          _controller.message.value,
                        );
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
      ],
    );
  }

  Widget _buildOtpField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 100),
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
            'Forgot Password ',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        OTPInput(onCompleted: (value) {
          _controller.otp = value;

          if (_controller.otp.length == 4) {
            _verifyOtp();
          }
        }),
        const SizedBox(height: 26),
        Obx(
          () => _controller.loading.value
              ? const Center(child: CircularProgressIndicator())
              : ButtonComponent(
                  text: 'Verify OTP',
                  onPressed: () async {
                    if(_controller.otp.length == 4 ) {
                      _verifyOtp();
                      return;
                    }
                  },
                ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 100),
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
            'Reset Password ',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        InputComponent(
          label: 'New Password',
          controller: newPasswordController,
          hintText: 'Enter new password',
          obscureText: _newPassObscureText,
          prefixIcon: Icons.lock,
          suffixIcon:
              _newPassObscureText ? Icons.visibility : Icons.visibility_off,
          suffixIconPressed: _toggleNewPassword,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Please enter a password';
            }
            return null;
          },
          onSaved: (value) {
            _controller.password = value ?? '';
          },
        ),
        const SizedBox(height: 16),
        InputComponent(
          label: 'Confirm Password',
          controller: confirmPasswordController,
          hintText: 'Enter confirm password',
          obscureText: _cPassObscureText,
          prefixIcon: Icons.lock,
          suffixIcon:
              _cPassObscureText ? Icons.visibility : Icons.visibility_off,
          suffixIconPressed: _toggleCPassword,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Please enter a password';
            }
            if (value != null && value != newPasswordController.text) {
              return 'Password does not match';
            }

            return null;
          },
          onSaved: (value) {
            _controller.confirmPassword = value ?? '';
          },
        ),
        const SizedBox(height: 26),
        Obx(
          () => _controller.loading.value
              ? const Center(child: CircularProgressIndicator())
              : ButtonComponent(
                  text: 'Submit',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      try {
                        await _controller.resetPassword();
                        SnackBarComponent.showSuccess(
                          context,
                          _controller.message.value,
                        );
                        Get.offNamed('/');
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarComponent(
        title: 'Forgot Password',
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Obx(
                () => _controller.form.value == 'email'
                    ? _buildEmailField()
                    : _controller.form.value == 'otp'
                        ? _buildOtpField()
                        : _buildPasswordField(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
