import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/diary_entry.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<DiaryEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('diary_')).toList()
      ..sort((a, b) => b.compareTo(a));
    final entries = keys.map((key) {
      final parts = (prefs.getString(key) ?? '').split('\n---\n');
      final date = DateTime.tryParse(key.replaceFirst('diary_', '')) ?? DateTime.now();
      return DiaryEntry(
        id: key,
        date: date,
        content: parts.isNotEmpty ? parts[0] : '',
        aiReply: parts.length > 1 ? parts[1] : '',
      );
    }).toList();
    setState(() => _entries = entries);
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('yyyy.MM.dd');
    return Scaffold(
      appBar: AppBar(title: const Text('지난 일기')),
      body: _entries.isEmpty
          ? const Center(child: Text('저장된 일기가 없어요'))
          : ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final e = _entries[index];
                return ListTile(
                  title: Text(fmt.format(e.date)),
                  subtitle: Text(
                    e.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
    );
  }
}
