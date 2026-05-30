import 'package:flutter/material.dart';

class DataBox extends StatelessWidget {
  final String label;
  final String? value;

  const DataBox({super.key, required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(value ?? "", style: TextStyle(fontSize: 14)),
      ],
    );
  }
}