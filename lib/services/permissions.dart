import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BlePermissions {
  static Future<bool> request(BuildContext context) async {
    if (Platform.isAndroid) {
      final status = await FlutterBluePlus.adapterState.first;
      if (status == BluetoothAdapterState.unauthorized) {
        if (context.mounted) {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Bluetooth permission needed'),
              content: const Text(
                'Car Speedo needs Bluetooth access to connect to the LilyGo board.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        return false;
      }

      if (status == BluetoothAdapterState.off) {
        if (context.mounted) {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Bluetooth is off'),
              content: const Text(
                'Please enable Bluetooth to connect to the LilyGo board.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        return false;
      }
    }
    return true;
  }
}
