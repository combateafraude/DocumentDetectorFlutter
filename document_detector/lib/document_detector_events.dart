import 'document_captures_model.dart';

/// `DocumentDetectorEvent` is an abstract class representing different types of events.
///
///It is used to create an instance of one of the event subclasses based
///on a map input, which comes from the SDK's result.
///
///Depending on the event type, it creates an instance of either
///`DocumentDetectorEventClosed`, `DocumentDetectorEventSuccess`, or
///`DocumentDetectorEventFailure`. If the event is not recognized,
///it throws an internal exception.
///
///This setup allows for a structured and type-safe way to handle different
///outcomes of the document capture process in the SDK.
abstract class DocumentDetectorEvent {
  static const canceledEvent = "canceled";
  static const successEvent = "success";
  static const failureEvent = "failure";
  static const resultMappingError =
      "Unexpected error mapping the document_detector execution return";

  factory DocumentDetectorEvent.fromMap(Map map) {
    switch (map['event']) {
      case canceledEvent:
        return const DocumentDetectorEventClosed();
      case successEvent:
        return DocumentDetectorEventSuccess(
            captures: (map['captures'] as List?)
                ?.map((e) => Capture.fromMap(e))
                .toList(),
            documentType: map['documentType'],
            trackingId: map['trackingId']);
      case failureEvent:
        return DocumentDetectorEventFailure(
            errorType: map['errorType'],
            errorMessage: map['errorMessage'],
            securityErrorCode: map['securityErrorCode']);
    }
    throw Exception(resultMappingError);
  }
}

/// This class represents an event where the document capture
/// was closed by the user, either by pressing the close button
/// at the top right, or sending the app to the background.
class DocumentDetectorEventClosed implements DocumentDetectorEvent {
  const DocumentDetectorEventClosed();
}

/// This class represents a successful document capture event.
/// The user document has been successfully captured,
/// and the URLs for download the captures have been returned.
class DocumentDetectorEventSuccess implements DocumentDetectorEvent {
  /// The captures of the document
  final List<Capture>? captures;

  /// The type of the document
  final String? documentType;

  /// The tracking id of the execution
  final String? trackingId;

  const DocumentDetectorEventSuccess(
      {this.captures, this.documentType, this.trackingId});
}

/// This class represents a failure in the document capture process.
/// The user document hasn't been successfully captured,
/// the `errorMessage` parameter contains the failure reason.
class DocumentDetectorEventFailure implements DocumentDetectorEvent {
  /// The error type
  final String? errorType;

  /// The error message
  final String? errorMessage;

  /// Exclusively for Android - Security validation error code returns:
  ///
  /// 100 - blocking emulated devices;
  ///
  /// 200 - blocking rooted devices;
  ///
  /// 300 - blocking devices with developer options enabled;
  ///
  /// 400 - blocking devices with ADB enabled;
  ///
  /// 500 - blocking devices with debugging enabled;
  final int? securityErrorCode;

  const DocumentDetectorEventFailure(
      {this.errorType, this.errorMessage, this.securityErrorCode});
}
