import 'package:caf_document_detector/enums.dart';
import 'layout_customization.dart';
import 'sensor_settings.dart';

class IOSSettings {
  /// Configure the ambient luminosity, device orientation, and stability sensor
  /// threshold parameters to ensure the document is captured in optimal conditions.
  SensorSettingsIOS? sensorSettings;

  /// Set the quality in the compression process. By default, all captures go
  /// through compression. The method expects values between `0.8` and `1.0` as a
  /// parameter, where `1.0` is the best compression quality.
  double? captureCompressionQuality;

  /// Enable the manual capture option. With this configuration `enabled`,
  /// you can specify the time - in seconds - until manual capture is activated using the
  /// `manualCaptureActivationDelay` parameter. By default, this time is set to `45` seconds.
  bool? enableManualCapture;

  /// Set the time delay to enable manual capture option for the user.
  /// By default, this time is set to `45` seconds. To enable the manual capture
  /// feature, use `enableManualCapture: true` parameter.
  int? manualCaptureActivationDelay;

  /// This configuration enables or disables multi-language support
  /// (English, Spanish, Brazilian Portuguese). If disabled, the language will
  /// default to Brazilian Portuguese.
  bool? enableMultiLanguage;

  /// Set document capture resolution. The options are `fullHd` and `ultraHd`.
  /// By default resolution is `fullHd`.
  IOSCameraResolution? cameraResolution;

  /// Customize you iOS app layout settings.
  ///
  /// Within this options you can change the buttons color, UI feedbacks color
  /// and app font.
  CustomLayoutIOS? customLayout;

  IOSSettings(
      {this.sensorSettings,
      this.captureCompressionQuality,
      this.enableManualCapture,
      this.manualCaptureActivationDelay,
      this.enableMultiLanguage,
      this.cameraResolution,
      this.customLayout});

  Map asMap() {
    Map<String, dynamic> map = {};

    if (captureCompressionQuality != null &&
        (captureCompressionQuality! < 0.8 ||
            captureCompressionQuality! > 1.0)) {
      throw ArgumentError(
          "capture compression quality must be between 0.8 and 1.0",
          "captureCompressionQuality");
    }

    map["sensorSettings"] = sensorSettings?.asMap();
    map["compressionQuality"] = captureCompressionQuality;
    map["enableManualCapture"] = enableManualCapture;
    map["manualCaptureActivationDelay"] = manualCaptureActivationDelay;
    map["enableMultilanguage"] = enableMultiLanguage;
    map["cameraResolution"] = cameraResolution?.stringValue;
    map["layoutCustomization"] = customLayout?.asMap();

    return map;
  }
}
