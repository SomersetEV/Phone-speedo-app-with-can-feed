import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/database.dart';
import '../../data/recording_repository.dart';
import '../../services/gps_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Future<bool?> _confirmDelete(BuildContext context) => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text('Delete trip?',
              style: TextStyle(color: Colors.white)),
          content: const Text(
            'This will remove the trip and subtract its distance from the total odometer.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child:
                  const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final repo = context.read<RecordingRepository>();
    final gps = context.read<GpsService>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<SpeedSession>>(
        stream: repo.watchSessions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final sessions = snapshot.data!;
          if (sessions.isEmpty) {
            return const Center(
              child: Text(
                'No recordings yet.\nStart recording on the Speedo screen.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, height: 1.6),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: sessions.length,
            itemBuilder: (_, i) {
              final session = sessions[i];
              return Dismissible(
                key: ValueKey(session.id),
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
                  await repo.deleteSession(
                      session.id, session.totalDistanceMiles);
                  await gps.refreshOdometer();
                },
                child: _SessionCard(session),
              );
            },
          );
        },
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final SpeedSession session;

  const _SessionCard(this.session);

  @override
  Widget build(BuildContext context) {
    final duration = session.endTime?.difference(session.startTime);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEE d MMM y, HH:mm').format(session.startTime),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _Stat(Icons.straighten,
                  '${session.totalDistanceMiles.toStringAsFixed(2)} mi',
                  'Distance'),
              const SizedBox(width: 24),
              _Stat(Icons.speed,
                  '${session.maxSpeedMph.toStringAsFixed(0)} mph',
                  'Max speed'),
              if (duration != null) ...[
                const SizedBox(width: 24),
                _Stat(Icons.timer, _formatDuration(duration), 'Duration'),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    if (d.inMinutes > 0) {
      return '${d.inMinutes}m ${d.inSeconds.remainder(60)}s';
    }
    return '${d.inSeconds}s';
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _Stat(this.icon, this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white38),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}
