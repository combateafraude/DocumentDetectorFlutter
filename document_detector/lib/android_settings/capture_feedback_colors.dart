class FeedbackColorsAndroid {
  /// Set the default UI feedback color, which appears when the scanner is
  /// searching for a document.
  ///
  /// This parameter expect the color `name` resource you defined in `colors.xml` file.
  String defaultFeedback;

  /// Set the success UI feedback color, which appears after the document
  /// has been successfully scanned.
  ///
  /// This parameter expect the color `name` resource you defined in `colors.xml` file.
  String successFeedback;

  /// Set the error UI feedback color, which appears after the scanner
  /// detects an inconsistency, such as sensor issues
  /// (lighting, orientation, or stability) or a mismatch with the requested document.
  ///
  /// This parameter expect the color `name` resource you defined in `colors.xml` file.
  String errorFeedback;

  FeedbackColorsAndroid({
    required this.defaultFeedback,
    required this.successFeedback,
    required this.errorFeedback,
  });

  Map asMap() {
    Map<String, dynamic> map = {};

    map["defaultColorResName"] = defaultFeedback;
    map["successColorResName"] = successFeedback;
    map["errorColorResName"] = errorFeedback;

    return map;
  }
}
