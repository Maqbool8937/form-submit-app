import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String titleText;
  final String valueText;

  const InfoCard({super.key, required this.titleText, required this.valueText});

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: mediaquery.height * 0.02),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              titleText,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Card(
          child: Container(
            width: mediaquery.width,
            height: mediaquery.height * 0.07,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                valueText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
