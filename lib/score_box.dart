import 'package:flutter/material.dart';

class ScoreBox extends StatelessWidget {
  const ScoreBox({super.key, required this.symbol, required this.score});

  final String symbol;
  final double score;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240.0,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(39, 39, 51, 1.0),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(symbol, style: const TextStyle(color: Colors.white, fontSize: 32.0)),
          Text('$score', style: const TextStyle(color: Colors.white, fontSize: 18.0)),
        ],
      ),
    );
  }
}
