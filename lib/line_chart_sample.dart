import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key, required this.data});

  final List<List<dynamic>> data;

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<double> prices = List.generate(10, (index) => 0.0);
  List<Color> gradientColors = [Colors.cyan, Colors.blue];

  List<double> normalizePrices(List<double> prices) {
    double maxValue = prices.reduce((curr, next) => curr > next ? curr : next);
    double minValue = prices.reduce((curr, next) => curr < next ? curr : next);

    return prices.map((price) => ((price - minValue) / (maxValue - minValue)) * 9.0).toList();
  }

  @override
  void initState() {
    for (int i = 0; i < 10; i++) {
      double value;

      if (widget.data[i][2] is String) {
        value = double.parse(widget.data[i][2]);
      } else if (widget.data[i][2] is double) {
        value = widget.data[i][2];
      } else {
        throw FormatException("Unsupported data type for value at index $i");
      }

      prices[i] = value;
    }
    prices = normalizePrices(prices);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[AspectRatio(aspectRatio: 1.70, child: LineChart(mainData()))]);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 1.0,
        verticalInterval: 1.0,
        getDrawingHorizontalLine: (value) => const FlLine(color: Colors.black, strokeWidth: 1),
        getDrawingVerticalLine: (value) => const FlLine(color: Colors.black, strokeWidth: 1),
      ),
      titlesData: const FlTitlesData(
        show: false,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 1)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1, reservedSize: 42)),
      ),
      borderData: FlBorderData(show: false, border: Border.all(color: const Color(0xff37434d))),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(10, (index) => FlSpot(index.toDouble(), prices[index])),
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: gradientColors.map((color) => color.withOpacity(0.3)).toList())),
        ),
      ],
    );
  }
}
