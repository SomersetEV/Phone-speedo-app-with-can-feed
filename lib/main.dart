import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/database.dart';
import 'data/recording_repository.dart';
import 'services/ble_service.dart';
import 'services/can_recording_service.dart';
import 'services/can_service.dart';
import 'services/gps_service.dart';
import 'ui/screens/can_log_screen.dart';
import 'ui/screens/history_screen.dart';
import 'ui/screens/speedo_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CarSpeedoApp());
}

class CarSpeedoApp extends StatelessWidget {
  const CarSpeedoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final db = AppDatabase();
    final repository = RecordingRepository(db);

    return MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: db),
        Provider<RecordingRepository>.value(value: repository),
        ChangeNotifierProvider(create: (_) => BleService()),
        ChangeNotifierProvider(create: (_) => GpsService(repository)),
        ChangeNotifierProvider(
          create: (ctx) => CanService(ctx.read<BleService>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CanRecordingService(ctx.read<BleService>()),
        ),
      ],
      child: MaterialApp(
        title: 'Car Speedo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF8F00),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const AppShell(),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const _screens = [
    SpeedoScreen(),
    HistoryScreen(),
    CanLogScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.speed),
            label: 'Speedo',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long),
            label: 'CAN Log',
          ),
        ],
      ),
    );
  }
}
