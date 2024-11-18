import 'package:flutter/services.dart';

import 'android_settings/android_settings.dart';
import 'ios_settings/ios_settings.dart';
import 'capture_preview_settings.dart';
import 'document_capture_flow.dart';
import 'document_detector_events.dart';
import 'enums.dart';
import 'country_code_list.dart';
import 'message_settings.dart';
import 'upload_settings.dart';

const _documentDetectorMethodChannel = MethodChannel('document_detector');

class DocumentDetector {
  /// Usage token associated with your CAF account
  String mobileToken;

  /// Defines the document capture flow. Create a `List` of type
  /// `DocumentCaptureFlow` to configure each capture step.
  List<DocumentCaptureFlow> captureFlow;

  String? personId;
  String? urlExpirationTime;
  bool? useAnalytics;
  bool? displayPopup;
  bool? enableDelay;
  int? millisecondsDelay;
  int? secondsDelay;
  int? requestTimeout;
  CafStage? stage;
  List<CountryCodesList>? countryCodeList;
  MessageSettings? messageSettings;
  UploadSettings? uploadSettings;
  PreviewSettings? previewSettings;
  AndroidSettings? androidSettings;
  IOSSettings? iosSettings;

  DocumentDetector({required this.mobileToken, required this.captureFlow});

  /// Delay the activity after the completion of each capture step.
  ///
  /// This value is represented in milliseconds.
  ///
  /// By default there is no delay.
  void setCurrentStepDoneDelayAndroid(
      bool enableDelay, int? millisecondsDelay) {
    this.enableDelay = enableDelay;
    this.millisecondsDelay = millisecondsDelay;
  }

  /// Delay the view after the completion of each capture step.
  ///
  /// This value is represented in seconds.
  ///
  /// By default there is no delay.
  void setCurrentStepDoneDelayIOS(int secondsDelay) {
    this.secondsDelay = secondsDelay;
  }

  /// Set users identifier for fraud profile identification purposes and to
  /// assist in the identification of Analytics logs in cases of bugs and errors.
  void setPersonId(String personId) {
    this.personId = personId;
  }

  /// Defines requests timeout.
  ///
  /// This value is represented in seconds.
  ///
  /// By default the timeout is `60`s.
  void setNetworkSettings(int requestTimeoutInSeconds) {
    requestTimeout = requestTimeoutInSeconds;
  }

  /// Sets the time the image URL will last on the server until it is expired.
  ///  Expect to receive a time interval between "30m" to "30d".
  ///
  /// Example:
  /// - "30m": To set minutes only
  /// - "24h": To set only hour(s)
  /// - "1h 10m": To set hour(s) and minute(s)
  /// - "10d": To set day(s)
  ///
  /// By default it is set to `3`h.
  void setUrlExpirationTime(String urlExpirationTime) {
    this.urlExpirationTime = urlExpirationTime;
  }

  /// Enables/disables data gathering for analytics purposes -
  /// logs in cases of bugs and errors or fraud profile identification.
  void setUseAnalytics(bool useAnalytics) {
    this.useAnalytics = useAnalytics;
  }

  /// Enable/Disable the inflated popup with instructions before
  /// each document capture step.
  void setDisplayPopup(bool displayPopup) {
    this.displayPopup = displayPopup;
  }

  /// Set the runnin environment.
  void setStage(CafStage stage) {
    this.stage = stage;
  }

  /// Restrict the acceptance of passport documents to only those issued by
  /// a specific country or a predefined list of countries.
  void setCountryCodeList(List<CountryCodesList> countryCodeList) {
    this.countryCodeList = countryCodeList;
  }

  /// Configure customized messages that are displayed
  /// during the capture and analysis process.
  void setMessageSettings(MessageSettings messageSettings) {
    this.messageSettings = messageSettings;
  }

  /// Sets the configuration for document upload flow.
  /// By enabling this option, the user will be prompted to upload
  /// the document file instead of capturing them with the device's camera.
  /// This option also includes quality checks.
  ///
  /// Create a `UploadSettings` element with the desired settings.
  ///
  /// By default this feature is deactivated.
  void setUploadSettings(UploadSettings uploadSettings) {
    this.uploadSettings = uploadSettings;
  }

  /// Enables/disables the document picture preview for the user,
  /// so they can check if it's all ok before send it.
  /// Create a `PreviewSettings` element with the desired settings.
  ///
  /// By default the preview is disabled.
  void setPreviewSettings(PreviewSettings previewSettings) {
    this.previewSettings = previewSettings;
  }

  /// Set Android platform exclusive settings.
  void setAndroidSettings(AndroidSettings androidSettings) {
    this.androidSettings = androidSettings;
  }

  /// Set iOS platform exclusive settings.
  void setIOSSettings(IOSSettings iosSettings) {
    this.iosSettings = iosSettings;
  }

  Future<DocumentDetectorEvent> start() async {
    Map<String, dynamic> params = {};

    params['mobileToken'] = mobileToken;
    params['captureFlow'] = captureFlow.map((e) => e.asMap()).toList();
    params['personId'] = personId;
    params['urlExpirationTime'] = urlExpirationTime;
    params['useAnalytics'] = useAnalytics;
    params['displayPopup'] = displayPopup;
    params['enableDelay'] = enableDelay;
    params['millisecondsDelay'] = millisecondsDelay;
    params['secondsDelay'] = secondsDelay;
    params['requestTimeout'] = requestTimeout;
    params['stage'] = stage?.stringValue;
    params['countryCodeList'] =
        countryCodeList?.map((e) => e.stringValue).toList();
    params['uploadSettings'] = uploadSettings?.asMap();
    params['previewSettings'] = previewSettings?.asMap();
    params['messageSettings'] = messageSettings?.asMap();
    params['androidSettings'] = androidSettings?.asMap();
    params["iosSettings"] = iosSettings?.asMap();

    final result =
        await _documentDetectorMethodChannel.invokeMethod('start', params);

    return DocumentDetectorEvent.fromMap(result);
  }
}
