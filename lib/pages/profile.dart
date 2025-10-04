import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import '../components/ButtonComponent.dart';
import '../components/ProfileComponent.dart';
import '../components/SnackBarComponent.dart';
import '../controllers/address_action_controller.dart';
import '../controllers/essential_controller.dart';
import '../controllers/auth_controller.dart';
import './index.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();

  final controller = Get.put(EssentialController());
  final authController = Get.put(AuthController());
  final addressController = Get.put(AddressActionController());

  File? _imageData;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _imageData = File(result.files.first.path!);
      });
      _saveImage();
    }
  }

  // saveImage
  Future<void> _saveImage() async {
    if (_imageData != null) {
      try {
        await authController.updateProfile(_imageData);
        await authController.getMe();
        SnackBarComponent.showSuccess(context, authController.message.value);
        _imageData = null;
      } catch (e) {
        SnackBarComponent.showError(context, e.toString());
      }
    }
  }

  void _deleteAddress(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          Obx(
            () => addressController.deleteLoading.value
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : TextButton(
                    onPressed: () async {
                      try {
                        await addressController.deleteAddress(id);
                        await addressController.init();
                      } catch (e) {
                        SnackBarComponent.showError(context, e.toString());
                      } finally {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _deletePhoto(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Image'),
        content: const Text('Are you sure you want to delete?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          Obx(
            () => authController.loading.value
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : TextButton(
                    onPressed: () async {
                      try {
                        await authController.deletePhoto();
                        await authController.getMe();
                      } catch (e) {
                        SnackBarComponent.showError(context, e.toString());
                      } finally {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = authController.user.value;

    return IndexPage(
      index: 3,
      title: 'Profile',
      page: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {
              var user = authController.user.value;
              return Form(
                key: _formKey,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    InkWell(
                      onTap: _pickImage,
                      child: Ink(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 0.5),
                        ),
                        width: 128,
                        height: 128,
                        child: ClipOval(
                          child: _imageData != null
                              ? FutureBuilder<bool>(
                                  future: _imageData!.exists(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState !=
                                        ConnectionState.done) {
                                      return Center(
                                        child: SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    if (snapshot.hasError ||
                                        !(snapshot.data ?? false)) {
                                      return Image.asset(
                                        'assets/images/user.png',
                                        fit: BoxFit.cover,
                                        width: 128,
                                        height: 128,
                                      );
                                    }
                                    return Image.file(
                                      _imageData!,
                                      fit: BoxFit.cover,
                                      width: 128,
                                      height: 128,
                                    );
                                  },
                                )
                              : Image.network(
                                  user['profile_photo'] ?? '',
                                  fit: BoxFit.cover,
                                  width: 128,
                                  height: 128,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: SizedBox(
                                            width: 32,
                                            height: 32,
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/user.png',
                                      fit: BoxFit.cover,
                                      width: 128,
                                      height: 128,
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: ClipOval(
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (user['profile_photo'] != null)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _deletePhoto(context),
                          child: ClipOval(
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.account_circle,
                          color: Colors.blueGrey,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Profile Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/profile-edit');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF0F1B2A),
                                  Color(0xFFD50009),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24, thickness: 1),
                    ProfileDetail(
                      label: 'Name',
                      value: user['name'],
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 4),
                    ProfileDetail(
                      label: 'Email',
                      value: user['email'],
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 4),
                    ProfileDetail(
                      label: 'Phone',
                      value: user['mobile_number'],
                      icon: Icons.phone,
                    ),
                  ],
                ),
              ),
            ),
            Obx(() {
              var address = addressController.address.value;
              if (addressController.loading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (address == null) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      ButtonComponent(
                        text: 'Add Address',
                        onPressed: () {
                          Get.toNamed('/address-action');
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 4,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.home,
                              color: Colors.blueGrey,
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Address',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed('/address-action');
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF0F1B2A),
                                      Color(0xFFD50009),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              tooltip: 'Delete',
                              splashRadius: 22,
                              onPressed: () =>
                                  _deleteAddress(context, address.id!),
                              icon: const Icon(
                                Icons.delete_rounded,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24, thickness: 1),
                        Text(
                          "${address.addressLine1},",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${address.addressLine2},",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${address.pincode?.cityName} - ${address.pincode?.cityPincode},",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          "${address.district?.name}, ",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${address.state?.name},  ${address.country?.name} ",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 18),
                            const SizedBox(width: 6),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => {},
                                child: Text(
                                  "${address.phone}",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
            const SizedBox(height: 5),
            ButtonComponent(
              text: 'Change Password',
              onPressed: () {
                Get.toNamed('/change-password');
              },
            ),
          ],
        ),
      ),
    );
  }
}
