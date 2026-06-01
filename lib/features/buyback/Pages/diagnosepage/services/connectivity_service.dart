import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();

  factory ConnectivityService() {
    return _instance;
  }

  ConnectivityService._internal();

  // Check Network Connectivity
  Future<bool> checkNetworkConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      print('Network check error: $e');
      return false;
    }
  }

  // Check WiFi
  Future<bool> checkWiFi() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result == ConnectivityResult.wifi;
    } catch (e) {
      print('WiFi check error: $e');
      return false;
    }
  }
  // Check GPS
  Future<bool> checkGPS() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      print('GPS check error: $e');
      return false;
    }
  }

  // Check Bluetooth
  Future<bool> checkBluetooth() async {
    try {
      // 1. Request permissions
      var scan = await Permission.bluetoothScan.request();
      var connect = await Permission.bluetoothConnect.request();
      var location = await Permission.location.request();

      if (!scan.isGranted || !connect.isGranted || !location.isGranted) {
        print("Bluetooth permission denied");
        return false;
      }

      // 2. Check location service (required for BLE)
      bool isLocationOn = await Geolocator.isLocationServiceEnabled();
      if (!isLocationOn) {
        print("Location service OFF");
        return false;
      }

      // 3. Check Bluetooth state
      var state = await FlutterBluePlus.adapterState.first;
      if (state != BluetoothAdapterState.on) {
        print("Bluetooth OFF");
        return false;
      }

      // 4. Scan and wait properly
      bool foundDevice = false;

      var subscription = FlutterBluePlus.scanResults.listen((results) {
        if (results.isNotEmpty) {
          foundDevice = true;
        }
      });

      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

      await Future.delayed(const Duration(seconds: 4));

      await FlutterBluePlus.stopScan();
      await subscription.cancel(); // IMPORTANT

      return foundDevice;
    } catch (e) {
      print('Bluetooth scan error: $e');
      return false;
    }
  }
  // Future<bool> checkBluetooth() async {
  //   try {
  //     await Permission.bluetoothScan.request();
  //     await Permission.bluetoothConnect.request();
  //     await Permission.location.request();
  //
  //     var state = await FlutterBluePlus.adapterState.first;
  //
  //     if (state != BluetoothAdapterState.on) return false;
  //
  //     // Start scan
  //     await FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
  //
  //     bool foundDevice = false;
  //
  //     FlutterBluePlus.scanResults.listen((results) {
  //       if (results.isNotEmpty) {
  //         foundDevice = true;
  //       }
  //     });
  //
  //     await Future.delayed(Duration(seconds: 4));
  //     await FlutterBluePlus.stopScan();
  //
  //     return foundDevice; // TRUE = working
  //   } catch (e) {
  //     print('Bluetooth scan error: $e');
  //     return false;
  //   }
  // }
  // Check all services
  Future<Map<String, bool>> checkAllServices() async {
    return {
      'network': await checkNetworkConnectivity(),
      'wifi': await checkWiFi(),
      'gps': await checkGPS(),
      'bluetooth': await checkBluetooth(),
    };
  }
}