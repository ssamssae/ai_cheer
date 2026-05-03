import 'package:http/http.dart' as http;
import 'dart:convert';

class AiService {
  static const String _endpoint = 'https://your-worker.workers.dev/cheer'; // placeholder

  static Future<String> fetchAiReply(String diary) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'diary': diary}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['reply'] as String;
    }
    return '오늘도 수고했어요! 내일도 화이팅!';
  }
}
