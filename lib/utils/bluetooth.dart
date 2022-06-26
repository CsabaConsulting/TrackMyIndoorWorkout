import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

Future<bool> bluetoothCheck(bool silent) async {
  var blueOn = await FlutterBluePlus.instance.isOn;
  if (blueOn) {
    return true;
  }

  if (!await FlutterBluePlus.instance.isAvailable) {
    if (!silent) {
      await Get.defaultDialog(
        title: "Bluetooth Error",
        middleText: "Device doesn't seem to support Bluetooth",
        confirm: TextButton(
          child: const Text("Dismiss"),
          onPressed: () => Get.close(1),
        ),
      );
    }

    return false;
  }

  if (!silent) {
    final tryEnable = await Get.defaultDialog(
      title: "Bluetooth Needed",
      middleText: "Try enable Bluetooth?",
      confirm: TextButton(
        child: const Text("Yes"),
        onPressed: () => Get.close(1),
      ),
      cancel: TextButton(
        child: const Text("No"),
        onPressed: () => Get.close(1),
      ),
    );

    if (!tryEnable) {
      return false;
    }

    await BluetoothEnable.enableBluetooth;
    if (!await FlutterBluePlus.instance.isOn) {
      await FlutterBluePlus.instance.turnOn();
    }
  }

  return await FlutterBluePlus.instance.isOn;
}
