import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget widget;

  const TitleContainer({super.key, required this.title, required this.subtitle, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(29, 29, 41, 1.0),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4.0),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12.0)),
          const SizedBox(height: 24.0),
          widget,
        ],
      ),
    );
  }
}
