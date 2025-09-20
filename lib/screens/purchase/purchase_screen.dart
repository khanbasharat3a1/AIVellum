import 'package:flutter/material.dart';

class PurchaseScreen extends StatelessWidget {
  final String purchaseType;
  final String? promptId;

  const PurchaseScreen({super.key, required this.purchaseType, this.promptId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Screen'),
      ),
      body: Center(
        child: Text('Purchase Type: $purchaseType\nPrompt ID: $promptId'),
      ),
    );
  }
}