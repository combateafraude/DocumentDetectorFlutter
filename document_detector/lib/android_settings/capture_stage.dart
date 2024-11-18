import '../enums.dart';

class CaptureStage {
  /// Configures the duration of the stage in milliseconds.
  ///
  /// To specify no timeout, set this parameter to `null` or omit it entirely.
  int? durationMillis;

  /// Enables or disables the use of sensors during the document capture process.
  ///
  /// The sensors involved include:
  /// - `Ambient light`: Checks the lighting conditions.
  /// - `Device stability`: Verifies if the device is steady.
  /// - `Orientation`: Ensures the device is oriented correctly.
  bool wantSensorCheck;

  /// Configure the document capture mode: `automatic` or `manual`.
  CaptureMode captureMode;

  CaptureStage(
      {this.durationMillis,
      required this.wantSensorCheck,
      required this.captureMode});

  Map asMap() {
    Map<String, dynamic> map = {};

    map["durationMillis"] = durationMillis;
    map["wantSensorCheck"] = wantSensorCheck;
    map["captureMode"] = captureMode.stringValue;

    return map;
  }
}
