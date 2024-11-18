class InstructionalPopupSettingsAndroid {
  /// Change the document label displayed in the popup.
  ///
  /// To customize this, you just have to provide a String.
  String? documentLabel;

  /// Change the document illustration displayed in the popup.
  ///
  /// To customize this, you must provide the name of the file with the
  /// custom illustration you created in the `res/drawable` folder of your
  /// Android app.
  String? documentIllustration;

  InstructionalPopupSettingsAndroid({
    this.documentLabel,
    this.documentIllustration,
  });

  Map asMap() {
    Map<String, dynamic> map = {};

    map['documentLabel'] = documentLabel;
    map['documentIllustration'] = documentIllustration;

    return map;
  }
}
