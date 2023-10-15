import 'package:cryptomap/line_chart_sample.dart';
import 'package:flutter/material.dart';

class ScoreBox extends StatelessWidget {
  final String symbol;
  final double score;

  const ScoreBox({super.key, required this.symbol, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240.0,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 0, 0, 1.0),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(symbol, style: const TextStyle(color: Colors.white, fontSize: 32.0)),
          Text('$score KRW', style: const TextStyle(color: Colors.white, fontSize: 18.0)),
          const LineChartSample2(),
        ],
      ),
    );
  }
}
