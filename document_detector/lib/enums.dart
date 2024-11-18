enum CafStage {
  prod,
  beta,
}

extension StageToString on CafStage {
  String get stringValue => name.toUpperCase();
}

enum CaptureMode {
  manual,
  automatic,
}

extension CaptureModeToString on CaptureMode {
  String get stringValue => name.toUpperCase();
}

enum FileFormatAndroid {
  png,
  jpg,
  jpeg,
  pdf,
  heif,
}

extension AndroidFileFormatToString on FileFormatAndroid {
  String get stringValue => name.toUpperCase();
}

enum FileFormatIOS {
  png,
  jpeg,
  pdf,
}

extension IOSFileFormatToString on FileFormatIOS {
  String get stringValue => name;
}

enum AndroidCameraResolution {
  fullHd,
  quadHd,
  ultraHd,
}

extension AndroidResolutionToString on AndroidCameraResolution {
  String get stringValue => _enumCaseToString(name);
}

enum IOSCameraResolution {
  fullHd,
  ultraHd,
}

extension IOSResolutionToString on IOSCameraResolution {
  String get stringValue => _enumCaseToString(name);
}

enum DocumentType {
  rgFront,
  rgBack,
  rgFull,
  cnhFront,
  cnhBack,
  cnhFull,
  crlv,
  rneFront,
  rneBack,
  passport,
  ctpsFront,
  ctpsBack,
  any,
}

extension DocumentTypeToString on DocumentType {
  String get stringValue => _enumCaseToString(name);
}

/// separate camelCase text with underscore: camelCase => camel_Case
/// and convert the whole text to uppercase before returning it.
String _enumCaseToString(String text) {
  final exp = RegExp(r'(?<=[a-z])[A-Z]');
  return text
      .replaceAllMapped(exp, (Match m) => ('_${m.group(0)!}'))
      .toUpperCase();
}
