class Capture {
  /// Full path of the image file on the user's device.
  String? imagePath;

  /// URL of the document file on the Caf's server.
  /// This URL has an expiry time, which can be set with the `setUrlExpirationTime` method.
  String? imageUrl;

  /// Label of the captured document, for example: `cnh_front`, `rg_back`, `passport`...
  String? label;

  /// Quality inferred by the document quality algorithm, varying between 0 and 5.
  double? quality;

  Capture(this.imagePath, this.imageUrl, this.label, this.quality);

  factory Capture.fromMap(Map map) {
    return Capture(
      map['imagePath'],
      map['imageUrl'],
      map['label'],
      map['quality'],
    );
  }
}
