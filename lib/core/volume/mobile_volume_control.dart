import 'dart:async';

import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'volume_control_platform.dart';

class MobileVolumeControl implements VolumeControlPlatform {
  @override
  Future<double> getVolume() async {
    return (await FlutterVolumeController.getVolume()) ?? 0.5; // Default to 0.5 if null
  }

  @override
  Future<void> setVolume(double volume) async {
    await FlutterVolumeController.setVolume(volume);
  }

  @override
  Stream<double> onVolumeChanged() {
    // Manually create a stream using `addListener` if `stream` is unavailable
    final StreamController<double> volumeController = StreamController<double>();
    FlutterVolumeController.addListener((volume) {
      volumeController.add(volume);
    });

    // Return the stream
    return volumeController.stream;
  }
}
