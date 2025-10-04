import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/ButtonComponent.dart';
import '../components/DropDownComponent.dart';
import '../components/SnackBarComponent.dart';
import '../controllers/essential_controller.dart';
import '../components/InputComponent.dart';
import '../controllers/service_action_controller.dart';
import '../controllers/service_controller.dart';
import 'index.dart';

class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  Widget build(BuildContext context) {
    return IndexPage(
      title: 'Products',
      index: 2,
      page: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SizedBox(
            width: 400,
            height: 350,
            child: Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [Color(0xFF0F1B2A), Color(0xFFD50009)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds);
                    },
                    child: const Icon(Icons.shopping_bag, color: Colors.white, size: 64),
                  ),
                  const SizedBox(height: 24),
                  Text(
                      'Products',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 12),
                  Text(
                      'Manage your products here.\nFeature coming soon!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
