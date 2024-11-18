class FeedbackColorsIOS {
  /// Set the default UI feedback color, which appears when the scanner is
  /// searching for a document.
  String defaultFeedback;

  /// Set the success UI feedback color, which appears after the document
  /// has been successfully scanned.
  String successFeedback;

  /// Set the error UI feedback color, which appears after the scanner
  /// detects an inconsistency, such as sensor issues
  /// (lighting, orientation, or stability) or a mismatch with the requested document.
  String errorFeedback;

  FeedbackColorsIOS({
    required this.defaultFeedback,
    required this.successFeedback,
    required this.errorFeedback,
  });

  Map asMap() {
    Map<String, dynamic> map = {};

    map["defaultColor"] = defaultFeedback;
    map["successColor"] = successFeedback;
    map["errorColor"] = errorFeedback;

    return map;
  }
}
