import 'sensor_stability_settings.dart';

class SensorSettingsAndroid {
  /// Defines threshold between acceptable/unacceptable ambient brightness.
  /// The lower the value set, the less sensitive the orientation sensor will be.
  ///
  /// Set `disableLuminositySensor: true` if you don't want to use this sensor.
  ///
  /// The default settings are 5 (lx)
  int? luminositySensorSettings;

  /// Disable luminosity sensor
  bool? disableLuminositySensor;

  /// Defines threshold between correct/incorrect device orientation.
  /// The higher the value set, the less sensitive the orientation sensor will be.
  ///
  /// Set `disableOrientationSensor: true` if you don't want to use this sensor.
  ///
  /// The default setting is 3.0 (m/s²)
  double? orientationSensorSettings;

  /// Disable orientation sensor
  bool? disableOrientationSensor;

  /// Defines stability sensor settings.
  ///
  /// The default setting is `deviceStillMilliseconds: 2000` (ms) and `stabilityThreshold: 0.5` (m/s²)
  ///
  /// Set `disableStabilitySensor: true` if you don't want to use this sensor.
  StabilitySensorSettings? stabilitySensorSettings;

  /// Disable stability sensor
  bool? disableStabilitySensor;

  SensorSettingsAndroid({
    this.luminositySensorSettings,
    this.orientationSensorSettings,
    this.stabilitySensorSettings,
    this.disableLuminositySensor,
    this.disableOrientationSensor,
    this.disableStabilitySensor,
  });

  Map asMap() {
    Map<String, dynamic> map = {};

    map["luminositySensorThreshold"] = luminositySensorSettings;
    map["orientationSensorThreshold"] = orientationSensorSettings;
    map["stabilitySensorSettings"] = stabilitySensorSettings?.asMap();
    map["disableLuminositySensor"] = disableLuminositySensor;
    map["disableOrientationSensor"] = disableOrientationSensor;
    map["disableStabilitySensor"] = disableStabilitySensor;

    return map;
  }
}
