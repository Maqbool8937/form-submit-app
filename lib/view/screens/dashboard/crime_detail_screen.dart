import 'package:flutter/material.dart';
import 'package:form_submit_app/controllers/utils/colors.dart';

class CrimeDetailScreen extends StatefulWidget {
  const CrimeDetailScreen({super.key});

  @override
  State<CrimeDetailScreen> createState() => _CrimeDetailScreenState();
}

class _CrimeDetailScreenState extends State<CrimeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crime Detail'),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
      ),
    );
  }
}
