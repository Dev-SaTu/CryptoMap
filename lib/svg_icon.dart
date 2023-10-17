import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class SvgTile extends StatelessWidget {
  final String url;

  const SvgTile({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<http.Response>(
      future: http.get(Uri.parse(url)),
      builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError || snapshot.data?.statusCode != 200) {
          return Container();
        } else {
          String svgString = utf8.decode(snapshot.data!.bodyBytes);
          String convertedSvgString = svgString.replaceAllMapped(RegExp(r'(\d+\.\d+)e(-?\d+)'), (Match m) => (double.parse(m.group(0)!)).toStringAsFixed(6));
          return SvgPicture.string(convertedSvgString);
        }
      },
    );
  }
}
