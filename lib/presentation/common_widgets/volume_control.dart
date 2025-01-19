import 'package:flutter/material.dart';
import 'package:spotifo/core/app_export.dart';

import '../../core/volume/volume_control_factory.dart';
import '../../core/volume/volume_control_platform.dart';


class VolumeControl extends StatefulWidget {
  const VolumeControl({super.key});

  @override
  State<VolumeControl> createState() => _VolumeControlState();
}

class _VolumeControlState extends State<VolumeControl> {
  late final VolumeControlPlatform _volumeControl;
  double _currentVolume = 0.5;

  @override
  void initState() {
    super.initState();
    _volumeControl = VolumeControlFactory.create();
    _initVolume();
    _volumeControl.onVolumeChanged().listen((newVolume) {
      setState(() {
        _currentVolume = newVolume;
      });
    });
  }

  Future<void> _initVolume() async {
    final volume = await _volumeControl.getVolume();
    setState(() {
      _currentVolume = volume;
    });
  }

  @override
  void dispose() {
    // Cleanup listeners (if any)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Tooltip(
            message: 'Decrease volume',
            child: Icon(Icons.volume_down, color: Colors.white, size: 24.0),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4.0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.white38,
                thumbColor: Colors.white,
                overlayColor: Colors.white.withAlphaD(0.2),
              ),
              child: Slider(
                value: _currentVolume,
                onChanged: (value) async {
                  setState(() {
                    _currentVolume = value;
                  });
                  await _volumeControl.setVolume(value);
                },
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Tooltip(
            message: 'Increase volume',
            child: Icon(Icons.volume_up, color: Colors.white, size: 24.0),
          ),
        ],
      ),
    );
  }
}
