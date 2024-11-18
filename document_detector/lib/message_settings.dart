class MessageSettings {
  /// Message displayed in the opening process.
  String? waitMessage;

  /// Message advising to fit the document to the markup.
  String? fitTheDocumentMessage;

  /// Message displayed when it is verifying the capture quality.
  String? verifyingQualityMessage;

  /// Message displayed when the capture quality is low.
  String? lowQualityDocumentMessage;

  /// Message displayed when the capture is being uploaded on the servers.
  String? uploadingImageMessage;

  /// Message displayed when the device orientation is wrong.
  String? sensorOrientationMessage;

  /// Message displayed when the ambient brightness is lower than expected.
  String? sensorLuminosityMessage;

  /// Message displayed when the device stability parameter
  /// indicates excessive swaying.
  String? sensorStabilityMessage;

  /// Message displayed in the instructional popup, providing guidelines
  /// on how to achieve the best document capture.
  String? popupDocumentSubtitleMessage;

  /// Message displayed to request a document to be present on the camera.
  String? scanDocumentMessage;

  /// Message displayed to prompt the user to bring the camera closer to
  /// the document.
  String? getCloserMessage;

  /// Message displayed to prompt the user to center the document within
  /// the camera frame.
  String? centralizeDocumentMessage;

  /// Message displayed to prompt the user to move the camera farther
  /// away from the document.
  String? moveAwayMessage;

  /// Message displayed to prompt the user to align the document within
  /// the camera frame.
  String? alignDocumentMessage;

  /// Message displayed to prompt the user to rotate the document 90 degrees.
  String? turnDocumentMessage;

  /// Message displayed to notify that the document has been
  /// successfully captured.
  String? documentCapturedMessage;

  /// `Only for Android`
  ///
  /// Message displayed at the moment the capture is being performed.
  String? holdItMessage;

  /// `Only for Android`
  ///
  /// Customize the confirmation button text in the instructional popup.
  String? popupConfirmButtonMessage;

  /// `Only for Android`
  ///
  /// Message displayed when the document shown by the user is not the
  /// expected one for capture.
  String? wrongDocumentTypeMessage;

  /// `Only for Android`
  ///
  /// Message displayed to inform the user that the document being shown
  /// is not supported.
  String? unsupportedDocumentMessage;

  /// `Only for Android`
  ///
  /// Message displayed to notify that no document was detected.
  String? documentNotFoundMessage;

  MessageSettings(
      {this.waitMessage,
      this.fitTheDocumentMessage,
      this.holdItMessage,
      this.verifyingQualityMessage,
      this.lowQualityDocumentMessage,
      this.uploadingImageMessage,
      this.sensorOrientationMessage,
      this.sensorLuminosityMessage,
      this.sensorStabilityMessage,
      this.popupDocumentSubtitleMessage,
      this.scanDocumentMessage,
      this.getCloserMessage,
      this.centralizeDocumentMessage,
      this.moveAwayMessage,
      this.alignDocumentMessage,
      this.turnDocumentMessage,
      this.documentCapturedMessage,
      this.popupConfirmButtonMessage,
      this.wrongDocumentTypeMessage,
      this.unsupportedDocumentMessage,
      this.documentNotFoundMessage});

  Map asMap() {
    Map<String, dynamic> map = {};
    map["waitMessage"] = waitMessage;
    map["fitTheDocumentMessage"] = fitTheDocumentMessage;
    map["holdItMessage"] = holdItMessage;
    map["verifyingQualityMessage"] = verifyingQualityMessage;
    map["lowQualityDocumentMessage"] = lowQualityDocumentMessage;
    map["uploadingImageMessage"] = uploadingImageMessage;
    map["sensorOrientationMessage"] = sensorOrientationMessage;
    map["sensorLuminosityMessage"] = sensorLuminosityMessage;
    map["sensorStabilityMessage"] = sensorStabilityMessage;
    map["popupDocumentSubtitleMessage"] = popupDocumentSubtitleMessage;
    map["scanDocumentMessage"] = scanDocumentMessage;
    map["getCloserMessage"] = getCloserMessage;
    map["centralizeDocumentMessage"] = centralizeDocumentMessage;
    map["moveAwayMessage"] = moveAwayMessage;
    map["alignDocumentMessage"] = alignDocumentMessage;
    map["turnDocumentMessage"] = turnDocumentMessage;
    map["documentCapturedMessage"] = documentCapturedMessage;
    map["popupConfirmButtonMessage"] = popupConfirmButtonMessage;
    map["wrongDocumentTypeMessage"] = wrongDocumentTypeMessage;
    map["unsupportedDocumentMessage"] = unsupportedDocumentMessage;
    map["documentNotFoundMessage"] = documentNotFoundMessage;
    return map;
  }
}
