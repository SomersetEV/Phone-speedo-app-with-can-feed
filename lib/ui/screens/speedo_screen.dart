import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/recording_repository.dart';
import '../../services/ble_service.dart';
import '../../services/can_recording_service.dart';
import '../../services/can_service.dart';
import '../../services/gps_service.dart';
import '../../services/speed_limit_service.dart';

class SpeedoScreen extends StatelessWidget {
  const SpeedoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _BleBar(),
            Expanded(child: _SpeedoBody()),
            _RecordButton(),
            _GpsBar(),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _BleBar extends StatelessWidget {
  const _BleBar();

  @override
  Widget build(BuildContext context) {
    return Consumer<BleService>(
      builder: (ctx, ble, __) {
        final connected = ble.connectionState == BleConnectionState.connected;
        final scanning = ble.connectionState == BleConnectionState.scanning ||
            ble.connectionState == BleConnectionState.connecting;

        Color dotColor;
        String label;
        if (connected) {
          dotColor = Colors.green;
          label = ble.connectedDeviceName ?? 'Connected';
        } else if (scanning) {
          dotColor = Colors.amber;
          label = 'Connecting...';
        } else {
          dotColor = Colors.grey;
          label = 'Tap to connect LilyGo';
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // BLE status chip
              GestureDetector(
                onTap: () {
                  if (connected) {
                    ble.disconnect();
                  } else if (!scanning) {
                    ble.startScan();
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: dotColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Settings menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.settings,
                    color: Colors.white38, size: 20),
                color: const Color(0xFF1A1A1A),
                onSelected: (value) async {
                  if (value == 'set_odometer') {
                    await _showOdometerEditor(ctx, ctx.read<GpsService>());
                  } else if (value == 'can_record') {
                    final rec = ctx.read<CanRecordingService>();
                    if (rec.isRecording) {
                      await rec.stopRecording();
                    } else {
                      await rec.startRecording();
                    }
                  }
                },
                itemBuilder: (menuCtx) {
                  final rec = menuCtx.read<CanRecordingService>();
                  return [
                    const PopupMenuItem(
                      value: 'set_odometer',
                      child: Row(
                        children: [
                          Icon(Icons.edit_road,
                              size: 18, color: Colors.white70),
                          SizedBox(width: 10),
                          Text('Set Odometer',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'can_record',
                      child: Row(
                        children: [
                          Icon(
                            rec.isRecording
                                ? Icons.stop_circle_outlined
                                : Icons.fiber_manual_record,
                            size: 18,
                            color: rec.isRecording
                                ? Colors.red
                                : Colors.white70,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            rec.isRecording
                                ? 'Stop CAN Log'
                                : 'Start CAN Log',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<void> _showOdometerEditor(
    BuildContext context, GpsService gps) async {
  // Capture repo before any async gap — context.read is unsafe after await.
  final repo = context.read<RecordingRepository>();
  final ctrl =
      TextEditingController(text: gps.totalOdometer.toStringAsFixed(1));
  final result = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      title: const Text('Set total odometer',
          style: TextStyle(color: Colors.white)),
      content: TextField(
        controller: ctrl,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          suffixText: 'mi',
          suffixStyle: TextStyle(color: Colors.white54),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.amber),
          ),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, ctrl.text),
          child: const Text('Save'),
        ),
      ],
    ),
  );
  if (result == null) return;
  final miles = double.tryParse(result);
  if (miles == null || miles < 0) return;
  await repo.setOdometer(miles);
  await gps.refreshOdometer();
}

class _SpeedoBody extends StatelessWidget {
  const _SpeedoBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<GpsService>(
      builder: (_, gps, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const _CanDataPanel(),
            const SizedBox(height: 12),
            // Speed readout with limit sign to the left
            SizedBox(
              height: 260,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    width: 64,
                    child: Center(child: _SpeedLimitSign()),
                  ),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        gps.gpsStatus == GpsStatus.active
                            ? gps.speedMph.toStringAsFixed(0)
                            : '--',
                        style: const TextStyle(
                          fontSize: 300,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              'mph',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white54,
                letterSpacing: 6,
              ),
            ),
            const SizedBox(height: 32),
            // Odometer row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _OdometerCell('TRIP', gps.tripOdometer),
                Container(width: 1, height: 40, color: Colors.white12),
                _OdometerCell('TOTAL', gps.totalOdometer),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OdometerCell extends StatelessWidget {
  final String label;
  final double miles;

  const _OdometerCell(this.label, this.miles);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 11,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          miles.toStringAsFixed(1),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Text(
          'mi',
          style: TextStyle(color: Colors.white38, fontSize: 12),
        ),
      ],
    );
  }
}

class _RecordButton extends StatelessWidget {
  const _RecordButton();

  @override
  Widget build(BuildContext context) {
    return Consumer<GpsService>(
      builder: (_, gps, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: gps.isRecording
                  ? const Color(0xFFD32F2F)
                  : const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (gps.isRecording) {
                gps.stopRecording();
              } else {
                gps.startRecording();
              }
            },
            child: Text(
              gps.isRecording ? 'STOP RECORDING' : 'START RECORDING',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GpsBar extends StatelessWidget {
  const _GpsBar();

  @override
  Widget build(BuildContext context) {
    return Consumer<GpsService>(
      builder: (_, gps, __) {
        switch (gps.gpsStatus) {
          case GpsStatus.noPermission:
            return const Text(
              'GPS permission denied',
              style: TextStyle(color: Colors.red, fontSize: 12),
            );
          case GpsStatus.searching:
            return const Text(
              'GPS: Searching...',
              style: TextStyle(color: Colors.amber, fontSize: 12),
            );
          case GpsStatus.lost:
            return const Text(
              'GPS: Signal lost',
              style: TextStyle(color: Colors.red, fontSize: 12),
            );
          case GpsStatus.active:
            final accuracy = gps.lastAccuracyM ?? 999;
            final dots = accuracy < 5
                ? 5
                : accuracy < 10
                    ? 4
                    : accuracy < 20
                        ? 3
                        : accuracy < 50
                            ? 2
                            : 1;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'GPS',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
                const SizedBox(width: 8),
                ...List.generate(
                  5,
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(
                      Icons.circle,
                      size: 7,
                      color: i < dots ? Colors.green : Colors.white12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '±${accuracy.toStringAsFixed(0)} m',
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 12),
                ),
              ],
            );
        }
      },
    );
  }
}

// ── CAN data panel ────────────────────────────────────────────────────────────

class _CanItem {
  final String label;
  final String unit;
  const _CanItem(this.label, this.unit);
}

class _CanDataPanel extends StatefulWidget {
  const _CanDataPanel();

  @override
  State<_CanDataPanel> createState() => _CanDataPanelState();
}

class _CanDataPanelState extends State<_CanDataPanel> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _p1 = [_CanItem('MOTOR TEMP', '°C'), _CanItem('INV TEMP', '°C')];
  static const _p2 = [_CanItem('AMP DRAW', 'A')];
  static const _p3 = [_CanItem('DC-DC', 'A'), _CanItem('LV VOLTAGE', 'V')];

  static const int _pageCount = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CanService>(
      builder: (_, can, __) {
        final motorVal   = can.motorTempC?.toStringAsFixed(0)     ?? '--';
        final invVal     = can.invTempC?.toStringAsFixed(0)       ?? '--';
        final ampVal     = can.ampDraw?.toStringAsFixed(0)        ?? '--';
        final lvAmpsVal  = can.lvAmps?.toStringAsFixed(1)         ?? '--';
        final lvVoltsVal = can.lvVolts?.toStringAsFixed(1)        ?? '--';

        final showHeater = (can.heaterPowerKw ?? 0) > 0 &&
            (can.chargerPowerKw ?? 0) <= 0;
        final p2Item = showHeater
            ? const _CanItem('HEATER POWER', 'kW')
            : const _CanItem('CHARGER POWER', 'kW');
        final p2Val = showHeater
            ? (can.heaterPowerKw?.toStringAsFixed(1) ?? '--')
            : (can.chargerPowerKw?.toStringAsFixed(1) ?? '--');

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 140,
              child: PageView(
                controller: _pageController,
                onPageChanged: (p) => setState(() => _currentPage = p),
                children: [
                  _CanPage(items: _p1, values: [motorVal, invVal]),
                  _CanPage(items: _p2, values: [ampVal]),
                  _CanPage(items: [p2Item], values: [p2Val]),
                  _CanPage(items: _p3, values: [lvAmpsVal, lvVoltsVal]),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pageCount,
                (i) => Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _currentPage
                        ? Colors.white54
                        : Colors.white12,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CanPage extends StatelessWidget {
  final List<_CanItem> items;
  final List<String> values;

  const _CanPage({required this.items, required this.values});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(
            child: _CanCard(
              items[i],
              value: i < values.length ? values[i] : '--',
            ),
          ),
        ],
      ],
    );
  }
}

class _CanCard extends StatelessWidget {
  final _CanItem item;
  final String value;

  const _CanCard(this.item, {this.value = '--'});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 13,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 42,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            item.unit,
            style: const TextStyle(color: Colors.white38, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

// ── Speed limit sign ─────────────────────────────────────────────────────────

class _SpeedLimitSign extends StatelessWidget {
  const _SpeedLimitSign();

  @override
  Widget build(BuildContext context) {
    return Consumer<SpeedLimitService>(
      builder: (_, svc, __) {
        final text = svc.speedLimitMph != null
            ? svc.speedLimitMph!.round().toString()
            : '--';
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.red, width: 4),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                height: 1.0,
              ),
            ),
          ),
        );
      },
    );
  }
}
