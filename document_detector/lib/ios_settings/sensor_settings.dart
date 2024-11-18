class SensorSettingsIOS {
  /// Defines threshold between acceptable/unacceptable ambient brightness.
  ///
  /// The lower the value set, the less sensitive the orientation sensor will be.
  ///
  /// The default settings is `-3`.
  double? luminositySensorSettings;

  /// Defines the threshold between correct/incorrect device orientation
  /// based on the variation of the last two accelerometer sensor readings
  /// collected from the device.
  ///
  /// The higher the value set, the less sensitive the orientation sensor will be.
  ///
  /// The default setting is `0.3`.
  double? orientationSensorSettings;

  /// Defines the threshold between stable/unstable device based on the variation
  /// of the last two gyro sensor readings collected from the device.
  ///
  /// The higher the value set, the less sensitive the stability sensor will be.
  ///
  /// The default setting is `0.3`.
  double? stabilitySensorSettings;

  SensorSettingsIOS(
      {this.luminositySensorSettings,
      this.orientationSensorSettings,
      this.stabilitySensorSettings});

  Map asMap() {
    Map<String, dynamic> map = {};

    map["luminositySettings"] = luminositySensorSettings;
    map["orientationSettings"] = orientationSensorSettings;
    map["stabilitySettings"] = stabilitySensorSettings;

    return map;
  }
}
