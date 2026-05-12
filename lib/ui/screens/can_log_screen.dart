import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/can_recording_service.dart';

class CanLogScreen extends StatefulWidget {
  const CanLogScreen({super.key});

  @override
  State<CanLogScreen> createState() => _CanLogScreenState();
}

class _CanLogScreenState extends State<CanLogScreen> {
  List<File> _files = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CanRecordingService>().addListener(_onServiceChanged);
      _load();
    });
  }

  @override
  void dispose() {
    context.read<CanRecordingService>().removeListener(_onServiceChanged);
    super.dispose();
  }

  void _onServiceChanged() {
    if (!context.read<CanRecordingService>().isRecording) _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final files = await context.read<CanRecordingService>().listSessions();
    if (mounted) setState(() { _files = files; _loading = false; });
  }

  Future<bool?> _confirmDelete(BuildContext context) => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text('Delete log?',
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

  String _formatDate(File file) {
    final name = p.basenameWithoutExtension(file.path);
    try {
      final parts = name.split('_'); // ['can', '20240512', '143022']
      final dt =
          DateFormat('yyyyMMdd_HHmmss').parse('${parts[1]}_${parts[2]}');
      return DateFormat('EEE d MMM y, HH:mm').format(dt);
    } catch (_) {
      return name;
    }
  }

  String _fileSize(File file) {
    final bytes = file.lengthSync();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CanRecordingService>(
      builder: (_, rec, __) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: rec.isRecording
              ? Text(
                  'Recording • ${rec.frameCount} frames',
                  style: const TextStyle(color: Colors.red, fontSize: 15),
                )
              : const Text('CAN Log'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _files.isEmpty
                ? const Center(
                    child: Text(
                      'No CAN logs yet.\nStart recording from the Speedo screen settings.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, height: 1.6),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _files.length,
                      itemBuilder: (_, i) {
                        final file = _files[i];
                        return Dismissible(
                          key: ValueKey(file.path),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red.shade800,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 24),
                            child: const Icon(Icons.delete_outline,
                                color: Colors.white, size: 26),
                          ),
                          confirmDismiss: (_) => _confirmDelete(context),
                          onDismissed: (_) async {
                            await context
                                .read<CanRecordingService>()
                                .deleteSession(file);
                            setState(() => _files.removeAt(i));
                          },
                          child: _LogCard(
                            date: _formatDate(file),
                            size: _fileSize(file),
                            onExport: () async {
                              await SharePlus.instance.share(
                                ShareParams(
                                  files: [XFile(file.path)],
                                  text:
                                      'CAN log ${_formatDate(file)}',
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}

class _LogCard extends StatelessWidget {
  final String date;
  final String size;
  final VoidCallback onExport;

  const _LogCard(
      {required this.date,
      required this.size,
      required this.onExport});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onExport,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            const Icon(Icons.description_outlined,
                color: Colors.white38, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(size,
                      style: const TextStyle(
                          color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.share, color: Colors.white38, size: 20),
          ],
        ),
      ),
    );
  }
}
