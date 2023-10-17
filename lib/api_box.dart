import 'package:flutter/material.dart';

class APIBox extends StatelessWidget {
  const APIBox({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('End Point', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.0)),
        Text('https://seoul.synctreengine.com/plan/entrance', style: TextStyle(color: Colors.white)),
        SizedBox(height: 16.0),
        Text('Request Method', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.0)),
        Text('POST', style: TextStyle(color: Colors.white)),
        SizedBox(height: 16.0),
        Text('Request Parameters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.0)),
        Text('Header', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        Text('X-Synctree-Plan-ID', style: TextStyle(color: Colors.white)),
        Text('X-Synctree-Plan-Environment', style: TextStyle(color: Colors.white)),
        Text('X-Synctree-Bizunit-Version', style: TextStyle(color: Colors.white)),
        Text('Content-Type', style: TextStyle(color: Colors.white)),
        SizedBox(height: 8.0),
        Text('Body', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        SizedBox(height: 16.0),
        Text('Response Parameters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.0)),
        Text('Header', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        Text('Body', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
