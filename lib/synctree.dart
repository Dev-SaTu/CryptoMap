import 'dart:convert';
import 'package:cryptomap/ticker.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  // final result1 = await requestSymbolScore('BTC');
  // print(result1);

  final result2 = await requestTickerAll();
  print(result2);
}

Future<String> requestSymbolScore(String symbol) async {
  const endpoint = 'https://seoul.synctreengine.com/plan/entrance';
  const headers = {
    'X-Synctree-Plan-ID': '1410fcf141e9522caf1a3ed7815ac743e4e824c7a74bf6357f940d472fb99f47',
    'X-Synctree-Plan-Environment': 'production',
    'X-Synctree-Bizunit-Version': '1.0',
    'X-Synctree-Revision-ID': '61d600f057633d6a7f0b55e056ffeba6c5502aace3ef0d03237d86b77fbb0baa',
    'Content-Type': 'application/json',
  };
  final body = jsonEncode({'symbol': symbol});

  return await _sendRequest(endpoint, headers, body);
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
  return response.body;
}
