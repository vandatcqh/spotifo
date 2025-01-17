abstract class VolumeControlPlatform {
  Future<double> getVolume();
  Future<void> setVolume(double volume);
  Stream<double> onVolumeChanged();
}
