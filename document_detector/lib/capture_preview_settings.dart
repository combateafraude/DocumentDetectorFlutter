class PreviewSettings {
  /// Enable/Disable the document capture preview feature.
  bool show;

  /// Customimze the view title
  String? title;

  /// Customize the view subtitle
  String? subtitle;

  /// Customize the confirmation button text. This button allows the
  /// user to confirm and send the document capture.
  String? confirmButtonLabel;

  /// Customize the retry button text. This button allows the user to
  /// take another capture.
  String? retryButtonLabel;

  PreviewSettings(
      {required this.show,
      this.title,
      this.subtitle,
      this.confirmButtonLabel,
      this.retryButtonLabel});

  Map asMap() {
    Map<String, dynamic> map = {};

    map["show"] = show;
    map["title"] = title;
    map["subtitle"] = subtitle;
    map["confirmLabel"] = confirmButtonLabel;
    map["retryLabel"] = retryButtonLabel;
    return map;
  }
}
