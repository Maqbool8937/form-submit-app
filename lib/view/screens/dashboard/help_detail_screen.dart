import 'package:flutter/material.dart';

class HelpDetailScreen extends StatefulWidget {
  const HelpDetailScreen({super.key});

  @override
  State<HelpDetailScreen> createState() => _HelpDetailScreenState();
}

class _HelpDetailScreenState extends State<HelpDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text('Helps Detail'),
      ),
    );
  }
}
