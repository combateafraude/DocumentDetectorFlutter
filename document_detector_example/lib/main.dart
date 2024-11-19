import 'package:caf_document_detector/android_settings/android_settings.dart';
import 'package:caf_document_detector/android_settings/security_settings.dart';
import 'package:caf_document_detector/document_capture_flow.dart';
import 'package:caf_document_detector/document_detector.dart';
import 'package:caf_document_detector/document_detector_events.dart';
import 'package:caf_document_detector/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DocumentDetectorDemo(),
    );
  }
}

class DocumentDetectorDemo extends StatefulWidget {
  const DocumentDetectorDemo({Key? key}) : super(key: key);

  @override
  DocumentDetectorDemoState createState() => DocumentDetectorDemoState();
}

class DocumentDetectorDemoState extends State<DocumentDetectorDemo> {
  late final DocumentDetector documentDetector;

  @override
  void initState() {
    super.initState();
    documentDetector = buildDocumentDetector();
  }

  DocumentDetector buildDocumentDetector() {
    const String mobileToken = "mobile_token";
    const String personId = "person_id";

    DocumentDetector documentDetector = DocumentDetector(
      mobileToken: mobileToken,
      captureFlow: [
        DocumentCaptureFlow(documentType: DocumentType.cnhFront),
        DocumentCaptureFlow(documentType: DocumentType.cnhBack),
      ],
    );

    AndroidSettings androidSettings = AndroidSettings(
      securitySettings: SecuritySettings(
        useAdb: true,
        useDebug: true,
        useDeveloperMode: true,
        useEmulator: true,
        useRoot: true,
      ),
    );

    documentDetector.setAndroidSettings(androidSettings);
    documentDetector.setPersonId(personId);
    documentDetector.setStage(CafStage.prod);

    return documentDetector;
  }

  void _startDocumentDetector() async {
    try {
      DocumentDetectorEvent event = await documentDetector.start();

      if (event is DocumentDetectorEventSuccess) {
        print("SUCCESS");
        print("Document Type: ${event.documentType}");
        for (var capture in event.captures!) {
          print("""
              Document Label: ${capture.label ?? "empty"}
              Image Quality: ${capture.quality ?? "empty"}
              File Path: ${capture.imagePath ?? "empty"}
              File URL: ${capture.imageUrl?.split("?")[0] ?? "empty"}
            """
          );
        }
      } else if (event is DocumentDetectorEventFailure) {
        print("FAILURE");
        print("""
          Failure Type: ${event.errorType ?? "empty"}
          Failure Description: ${event.errorMessage ?? "empty"}
          Security Code: ${event.securityErrorCode ?? "none"}
         """
        );
      } else if (event is DocumentDetectorEventClosed) {
        print("CLOSED: User closed document capture flow.");
      }
    } on PlatformException catch (e) {
      print("ERROR: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DocumentDetector Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _startDocumentDetector,  // Trigger detection on button press
          child: const Text("Start Document Detection"),
        ),
      ),
    );
  }
}
