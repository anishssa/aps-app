import 'package:aps_app/components/GradientText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/SnackBarComponent.dart';
import '../controllers/auth_controller.dart';

class IndexPage extends StatelessWidget {
  final String title;
  final int index;
  final Widget page;

  IndexPage({
    super.key,
    required this.title,
    required this.index,
    required this.page,
  });

  final authController = Get.find<AuthController>();

  void _onItemTapped(BuildContext context, int i) {
    switch (i) {
      case 0:
        Get.toNamed('/service');
        break;
      case 1:
        Get.toNamed('/service-add');
        break;
      case 2:
        Get.toNamed('/product');
        break;
      case 3:
        Get.toNamed('/profile');
        break;
      case 4:
        _showLogoutDialog(context);
        break;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            Obx(
              () => authController.loading.value
                  ? const CircularProgressIndicator()
                  : TextButton(
                      onPressed: () async {
                        try {
                          await authController.logout();
                          Get.offAllNamed('/');
                        } catch (e) {}
                      },
                      child: const Text(
                        'LOG OUT',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.add, 'label': 'Service'},
      {'icon': Icons.shopping_bag, 'label': 'Product'},
      {'icon': Icons.person, 'label': 'Profile'},
      {'icon': Icons.logout, 'label': 'Logout'},
    ];

    Widget buildNavIcon(IconData icon) => Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF0F1B2A), Color(0xFFD50009)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );

    return Scaffold(
      appBar: AppBar(
        title: GradientText(title),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [Color(0xFF0F1B2A), Color(0xFFD50009)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds);
                  },
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                onPressed: () {
                  // TODO: Add notification logic here
                },
              ),
              // Positioned(
              //   right: 8,
              //   top: 8,
              //   child: Container(
              //     padding: const EdgeInsets.all(2),
              //     decoration: BoxDecoration(
              //       color: Colors.red,
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     constraints: const BoxConstraints(
              //       minWidth: 18,
              //       minHeight: 18,
              //     ),
              //     child: const Text(
              //       '3', // TODO: Replace with dynamic count
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 12,
              //         fontWeight: FontWeight.bold,
              //       ),
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900),
        onTap: (i) => _onItemTapped(context, i),
        items: navItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: buildNavIcon(item['icon'] as IconData),
                label: item['label'] as String,
              ),
            )
            .toList(),
      ),
    );
  }
}
