import 'dart:convert';
import 'package:cryptomap/balance.dart';
import 'package:cryptomap/ticker.dart';
import 'package:http/http.dart' as http;

Future<String> requestAdvise(String message) async {
  const endpoint = 'https://seoul.synctreengine.com/plan/entrance';
  const headers = {
    'X-Synctree-Plan-ID': 'cd3d4b601791452d0adc459b8f1f74be4ec1487cd89275fb4a1a068dc3e91bbb',
    'X-Synctree-Plan-Environment': 'production',
    'X-Synctree-Bizunit-Version': '1.0',
    'X-Synctree-Revision-ID': '3b2b27b9e2251b9cde7f5fd869a3fa2763bb71b2a26eacd3cfdff1875055218c',
    'Content-Type': 'application/json',
  };
  final body = jsonEncode({'message': message});

  final response = await _sendRequest(endpoint, headers, body);
  final result = jsonDecode(response);
  final content = result['result'][0]['message']['content'];

  return content;
}

Future<Balance> requestKB() async {
  const endpoint = 'https://seoul.synctreengine.com/plan/entrance';
  const headers = {
    'X-Synctree-Plan-ID': '25f87cd5f9c6bb4562ead8defc035b2767abb6acaf64ac4d35e6a5561ea98c87',
    'X-Synctree-Plan-Environment': 'production',
    'X-Synctree-Bizunit-Version': '1.0',
    'X-Synctree-Revision-ID': '759c3b30a5f8586950f94d0e49f2cdf878640203f69aa6592d3a76cc33f4db2b',
    'Content-Type': 'application/json',
  };

  final response = await _sendRequest(endpoint, headers, null);
  final Map<String, dynamic> result = jsonDecode(response);
  final balance = Balance.fromJson(result);

  return balance;
}

Future<Map<String, dynamic>> requestBalancePie(String symbol) async {
  const endpoint = 'https://seoul.synctreengine.com/plan/entrance';
  const headers = {
    'X-Synctree-Plan-ID': '36eb8c28e01bd1980ed862e4bee3cc56bad113293b405933befbb01ff307c909',
    'X-Synctree-Plan-Environment': 'production',
    'X-Synctree-Bizunit-Version': '1.0',
    'X-Synctree-Revision-ID': 'ac626c73f9c0bd005278e658a158319b955021e312c4aa738c61e913657bd4f3',
    'Content-Type': 'application/json',
  };
  final response = await _sendRequest(endpoint, headers, null);
  final Map<String, dynamic> result = jsonDecode(response);

  return result;
}

Future<Map<String, dynamic>> requestSymbolScore(String symbol) async {
  const endpoint = 'https://seoul.synctreengine.com/plan/entrance';
  const headers = {
    'X-Synctree-Plan-ID': '1410fcf141e9522caf1a3ed7815ac743e4e824c7a74bf6357f940d472fb99f47',
    'X-Synctree-Plan-Environment': 'production',
    'X-Synctree-Bizunit-Version': '1.0',
    'X-Synctree-Revision-ID': '61d600f057633d6a7f0b55e056ffeba6c5502aace3ef0d03237d86b77fbb0baa',
    'Content-Type': 'application/json',
  };
  final body = jsonEncode({'symbol': symbol});
  final response = await _sendRequest(endpoint, headers, body);
  final Map<String, dynamic> result = jsonDecode(response);

  return result;
}

Future<List<Ticker>> requestTickerAll() async {
  const endpoint = 'https://seoul.synctreengine.com/plan/entrance';
  const headers = {
    'X-Synctree-Plan-ID': '7a20ecff069d4ed388d585672907d0192b1485076ce4a688a466317303c05cba',
    'X-Synctree-Plan-Environment': 'production',
    'X-Synctree-Bizunit-Version': '1.0',
    'X-Synctree-Revision-ID': '5f628b0f171b75146c57a97b786dbf031ecaea3cffb2e33cc684d0aacd2e33cd',
    'Content-Type': 'application/json',
  };

  final response = await _sendRequest(endpoint, headers, null);
  final jsonResponse = jsonDecode(response);

  if (jsonResponse is Map<String, dynamic>) {
    jsonResponse.remove('date');
    return jsonResponse.entries.map((e) => Ticker.fromJson(e.key, e.value)).toList();
  } else {
    return [];
  }
}

Future<String> _sendRequest(String url, Map<String, String> headers, String? body) async {
  final response = await http.post(Uri.parse(url), headers: headers, body: body);
  return utf8.decode(response.bodyBytes);
}
