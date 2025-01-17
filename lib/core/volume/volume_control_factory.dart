import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'volume_control_platform.dart';
import 'mobile_volume_control.dart';
import 'web_volume_control.dart';

class VolumeControlFactory {
  static VolumeControlPlatform create() {
    if (kIsWeb) {
      return WebVolumeControl(); // Web implementation
    } else if (Platform.isAndroid || Platform.isIOS) {
      return MobileVolumeControl(); // Mobile implementation
    } else {
      return WebVolumeControl(); // Fallback
    }
  }
}
