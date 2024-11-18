import 'capture_feedback_colors.dart';

class CustomLayoutIOS {
  /// Change the button components primary color.
  String? primaryColor;

  /// Customize the UI feedback colors to be displayed.
  FeedbackColorsIOS? feedbackColors;

  /// Change the font applyed to the SDK.
  ///
  /// To customize this, place the font file inside your iOS app and
  /// provide its name in this parameter.
  String? fontStyle;

  CustomLayoutIOS({this.primaryColor, this.feedbackColors, this.fontStyle});

  Map asMap() {
    Map<String, dynamic> map = {};

    map["primaryColor"] = primaryColor;
    map["feedbackColors"] = feedbackColors?.asMap();
    map["fontStyle"] = fontStyle;

    return map;
  }
}
