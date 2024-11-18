import '../enums.dart';
import 'capture_stage.dart';
import 'security_settings.dart';
import 'sensor_settings.dart';
import 'capture_feedback_colors.dart';

class AndroidSettings {
  /// Configure the ambient luminosity, device orientation, and stability sensor
  /// parameters to ensure the document is captured in optimal conditions.
  SensorSettingsAndroid? sensorSettings;

  /// CaptureStage is a feature that determines the level of document
  /// capture requirements. As soon as the document capture flow starts,
  /// a timer is activated. During the defined time, the configurations
  /// specified in each of the configured stages are applied. It is possible
  /// to define a list of CaptureStages to gradually ease the document capture
  /// requirements over time. This feature exists due to the diversity of
  /// camera hardware in Android devices, preventing the user from getting
  /// stuck in the document capture flow during their onboarding.
  ///
  /// The default configuration consists of the following order of `CaptureStages`:
  /// - **CaptureStage #1** - `captureMode: CaptureMode.automatic`, `wantSensorCheck: true`, `durationMillis: 30000`;
  /// - **CaptureStage #2** - `captureMode: CaptureMode.automatic`, `wantSensorCheck: false`, `durationMillis: 15000`;
  /// - **CaptureStage #3** - `captureMode: CaptureMode.manual`, `wantSensorCheck: false`, `durationMillis: null`;
  List<CaptureStage>? captureStages;

  /// Set the quality in the compression process. By default, all captures go
  /// through compression.
  ///
  /// The value must be between `80` and `100`,
  /// where 100 is the highest compression quality.
  ///
  /// The default compress quality is `90`.
  int? compressQuality;

  /// Set document capture resolution. The options are `fullHd`, `quadHd` and `ultraHd`.
  /// By default resolution is `fullHd`.
  AndroidCameraResolution? cameraResolution;

  /// The SDK has some blocks that may prevent its execution in certain contexts.
  /// To configure them, you can use this configuration set.
  SecuritySettings? securitySettings;

  /// Define your custom app style to change the primary color of the SDK.
  ///
  /// To customize, create a `style.xml` resource file in your app and add this
  /// style fragment to it, replacing the values inside the placeholders:
  ///
  /// ```xml
  /// <resources>
  ///   <style name={style_name} parent={parent_name}>
  ///     <item name="colorPrimary">{custom_color_hex}</item>
  ///   </style>
  /// </resources>
  /// ```
  String? customStyle;

  /// Customize the UI feedback colors to be displayed.
  ///
  /// To customize the UI feedback colors in your app, follow these steps:
  /// - Create a `colors.xml` resource file in your app's `res/values` directory.
  /// - Define the colors for the different types of feedback: `default`, `success`, and `error`.
  ///
  /// Here is an improved version of the `colors.xml` file with placeholders for the color hex values:
  /// ```xml
  /// <resources>
  ///  <color name="feedback_default">{default_color}</color>
  ///  <color name="feedback_success">{success_color}</color>
  ///  <color name="feedback_error">{error_color}</color>
  /// </resources>
  /// ```
  FeedbackColorsAndroid? feedbackColors;

  AndroidSettings({
    this.sensorSettings,
    this.captureStages,
    this.compressQuality,
    this.cameraResolution,
    this.securitySettings,
    this.customStyle,
    this.feedbackColors,
  });

  Map asMap() {
    Map<String, dynamic> map = {};

    if (compressQuality != null &&
        (compressQuality! < 80 || compressQuality! > 100)) {
      throw ArgumentError(
          "compressQuality must be between 80 and 100", "compressQuality");
    }

    map["sensorSettings"] = sensorSettings?.asMap();
    map["captureStages"] = captureStages?.map((e) => e.asMap()).toList();
    map["compressQuality"] = compressQuality;
    map["cameraResolution"] = cameraResolution?.stringValue;
    map["securitySettings"] = securitySettings?.asMap();
    map["customStyleResName"] = customStyle;
    map["feedbackColors"] = feedbackColors?.asMap();

    return map;
  }
}
