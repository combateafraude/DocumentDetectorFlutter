class InstructionalPopupSettingsIOS {
  /// Change the document label displayed in the popup.
  ///
  /// To customize this, you just need to provide a `String` element.
  String? documentLabel;

  /// Change the document illustration displayed in the popup.
  ///
  /// To customize this, you must provide the name of the `Image Set` with the
  /// custom illustration you created in the `Asset Catalog` of you iOS app.
  String? documentIllustration;

  InstructionalPopupSettingsIOS(
      {this.documentLabel, this.documentIllustration});

  Map asMap() {
    Map<String, dynamic> map = {};

    map['documentLabel'] = documentLabel;
    map['documentIllustration'] = documentIllustration;

    return map;
  }
}
