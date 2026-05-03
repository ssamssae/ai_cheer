import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/ai_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  String _aiReply = '';
  bool _loading = false;

  Future<void> _fetchReply() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _loading = true;
      _aiReply = '';
    });
    final reply = await AiService.fetchAiReply(text);
    setState(() {
      _loading = false;
      _aiReply = reply;
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('yyyy년 MM월 dd일').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(title: const Text('AI 응원 일기')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(today, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '오늘 하루를 한 줄로 남겨보세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : _fetchReply,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('AI 응원 받기'),
            ),
            if (_aiReply.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(_aiReply, style: Theme.of(context).textTheme.bodyLarge),
            ],
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/history'),
              child: const Text('지난 일기 보기'),
            ),
          ],
        ),
      ),
    );
  }
}
