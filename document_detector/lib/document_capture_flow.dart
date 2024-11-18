import 'android_settings/instructional_popup_settings.dart';
import 'ios_settings/instructional_popup_settings.dart';

import 'enums.dart';

class DocumentCaptureFlow {
  /// Identifies which document will be requested for capture in the respective step.
  DocumentType documentType;

  /// Customize the instructional popup document illustration and label.
  InstructionalPopupSettingsAndroid? androidCustomization;

  /// Customize the instructional popup document illustration and label.
  InstructionalPopupSettingsIOS? iOSCustomization;

  DocumentCaptureFlow(
      {required this.documentType,
      this.androidCustomization,
      this.iOSCustomization});

  Map asMap() {
    Map<String, dynamic> map = {};

    map['documentType'] = documentType.stringValue;
    map['androidCustomization'] = androidCustomization?.asMap();
    map['iOSCustomization'] = iOSCustomization?.asMap();

    return map;
  }
}
