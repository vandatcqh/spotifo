import 'volume_control_platform.dart';

class WebVolumeControl implements VolumeControlPlatform {
  @override
  Future<double> getVolume() async {
    return 0.5; // Default volume value
  }

  @override
  Future<void> setVolume(double volume) async {
    // No-op for unsupported platforms
  }

  @override
  Stream<double> onVolumeChanged() {
    return const Stream.empty(); // No-op
  }
}
