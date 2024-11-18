import 'enums.dart';

class UploadSettings {
  /// Enables/disables file compression before uploading.
  ///
  /// If enabled, it follows the Android and iOS definitions for compression quality:
  /// - `AndroidSettings(int? compressQuality)`
  /// - `IOSSettings(double? captureCompressionQuality)`
  bool? compress;

  /// Defines the file format that will be accepted for upload.
  /// The options are: `FileFormatAndroid.pdf`, `FileFormatAndroid.jpg`, `FileFormatAndroid.jpeg`, `FileFormatAndroid.png`, `FileFormatAndroid.heif`.
  List<FileFormatAndroid>? fileFormatsAndroid;

  /// Defines the file format that will be accepted for upload.
  /// The options are: `FileFormatIOS.pdf`, `FileFormatIOS.jpeg`, `FileFormatIOS.png`.
  List<FileFormatIOS>? fileFormatsIOS;

  /// Specifies the maximum file size for upload, in kilobytes (kB).
  ///
  /// Example: 1000kB = 1MB
  ///
  /// The default value is 10MB.
  int? maxFileSize;

  UploadSettings(
      {this.compress,
      this.maxFileSize,
      this.fileFormatsAndroid,
      this.fileFormatsIOS});

  Map asMap() {
    Map<String, dynamic> map = {};

    map["compress"] = compress;
    map["fileFormatsAndroid"] =
        fileFormatsAndroid?.map((e) => e.stringValue).toList();
    map["fileFormatsIOS"] = fileFormatsIOS?.map((e) => e.stringValue).toList();
    map["maxFileSize"] = maxFileSize;

    return map;
  }
}
