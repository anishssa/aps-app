import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/ButtonComponent.dart';
import '../components/CustomAppBarComponent.dart';
import '../components/InputComponent.dart';
import '../components/SnackBarComponent.dart';
import '../controllers/auth_controller.dart';

class ProfileAction extends StatefulWidget {
  const ProfileAction({Key? key}) : super(key: key);

  @override
  _ProfileActionState createState() => _ProfileActionState();
}

class _ProfileActionState extends State<ProfileAction> {
  final _formKey = GlobalKey<FormState>();

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    var user = authController.user.value;
    return Scaffold(
      appBar: const CustomAppBarComponent(
        title: 'Profile',
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
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: const Text(
                      'Profile Update ',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InputComponent(
                    label: 'Name',
                    prefixIcon: Icons.person,
                    hintText: 'Enter your name',
                    initialValue: user['name'],
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      authController.name = value ?? '';
                    },
                  ),
                  const SizedBox(height: 16),
                  InputComponent(
                    label: 'Email',
                    initialValue: user['email'],
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
                    onSaved: (value) => authController.email = value ?? '',
                  ),
                  const SizedBox(height: 16),
                  InputComponent(
                    label: 'Phone',
                    initialValue: user['mobile_number'],
                    prefixIcon: Icons.phone,
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
                      authController.mobileNo = value ?? '';
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
                                  await authController.updateMe();
                                  await authController.getMe();
                                  Get.offNamed('/profile');
                                  SnackBarComponent.showSuccess(
                                    context,
                                    authController.message.value,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
