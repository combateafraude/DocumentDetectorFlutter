class StabilitySensorSettings {
  /// Defines the threshold between stable/unstable,
  /// in m/s² variation between the last two sensor collections.
  ///
  /// The higher the value set, the less sensitive the stability sensor will be.
  ///
  /// The default is `0.5` m/s²
  double stabilityThreshold;

  /// Specifies the duration, in milliseconds, that the device must remain still to be considered stable.
  ///
  /// The default value is `2000` milliseconds.
  int stabilityDurationMillis;

  StabilitySensorSettings(
      {required this.stabilityThreshold,
      required this.stabilityDurationMillis});

  Map asMap() {
    Map<String, dynamic> map = {};

    map["stabilityThreshold"] = stabilityThreshold;
    map["deviceStillMilliseconds"] = stabilityDurationMillis;

    return map;
  }
}
