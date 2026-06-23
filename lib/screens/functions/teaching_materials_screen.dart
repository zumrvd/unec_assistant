import 'package:flutter/material.dart';

class TeachingMaterialsScreen extends StatelessWidget {
  const TeachingMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: const Text('Teaching Materials'),
      ),
      body: const Center(
        child: Text('Teaching Materials Screen'),
      ),
    );
  }
}
