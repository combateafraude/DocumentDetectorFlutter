class SecuritySettings {
  /// Allows you to enable or disable SDK features that utilize Google Services.
  ///
  /// **Note:** Disabling these services is not recommended due to potential security risks.
  bool? enableGoogleServices;

  /// Allows you to enable or disable SDK to run in rooted devices.
  ///
  /// **Note:** It is not recommended to enable this option,
  /// use it only for testing purposes.
  bool? useRoot;

  /// Allows you to enable or disable SDK to run in emulated devices.
  ///
  /// **Note:** It is not recommended to enable this option,
  /// use it only for testing purposes.
  bool? useEmulator;

  /// Allows you to enable or disable SDK to run in devices with developer mode
  /// activated.
  ///
  /// **Note:** It is not recommended to enable this option,
  /// use it only for testing purposes.
  bool? useDeveloperMode;

  /// Allows you to enable or disable SDK to run in Android Debug Bridge (ADB) debugging mode.
  ///
  /// **Note:** It is not recommended to enable this option,
  /// use it only for testing purposes.
  bool? useAdb;

  /// Allows you to enable or disable SDK to run in a debug mode application.
  ///
  /// **Note:** It is not recommended to enable this option,
  /// use it only for testing purposes.
  bool? useDebug;

  SecuritySettings(
      {this.enableGoogleServices,
      this.useRoot,
      this.useEmulator,
      this.useDeveloperMode,
      this.useAdb,
      this.useDebug});

  Map asMap() {
    Map<String, dynamic> map = {};

    map["enableGoogleServices"] = enableGoogleServices;
    map["rootDetection"] = useRoot;
    map["emulatorDetection"] = useEmulator;
    map["developerModeDetection"] = useDeveloperMode;
    map["adbDetection"] = useAdb;
    map["debugDetection"] = useDebug;

    return map;
  }
}
