import 'package:flutter/material.dart';

class AccidentDetailScreen extends StatefulWidget {
  const AccidentDetailScreen({super.key});

  @override
  State<AccidentDetailScreen> createState() => _AccidentDetailScreenState();
}

class _AccidentDetailScreenState extends State<AccidentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accident Detail'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
    );
  }
}
