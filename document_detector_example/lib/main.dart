import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_caf_document_detector/android_settings/android_settings.dart';
import 'package:flutter_caf_document_detector/android_settings/security_settings.dart';
import 'package:flutter_caf_document_detector/capture_preview_settings.dart';
import 'package:flutter_caf_document_detector/document_capture_flow.dart';
import 'package:flutter_caf_document_detector/document_captures_model.dart';
import 'package:flutter_caf_document_detector/document_detector.dart';
import 'package:flutter_caf_document_detector/document_detector_events.dart';
import 'package:flutter_caf_document_detector/enums.dart';
import 'package:flutter_caf_document_detector/upload_settings.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _resultEvent = "";
  String _resultDescription = "";

  String mobileToken = "";
  String personId = "";

  var personIdController = TextEditingController();
  var mobileTokenController = TextEditingController();
  bool isBeta = true;

  @override
  void initState() {
    super.initState();
  }

  void startDocumentDetector(List<DocumentCaptureFlow> captureFlow) async {
    personId =
        personIdController.text.isNotEmpty ? personIdController.text : personId;
    mobileToken = mobileTokenController.text.isNotEmpty
        ? mobileTokenController.text
        : mobileToken;

    String resultEvent = "";
    String resultDescription = "";

    DocumentDetector documentDetector =
        DocumentDetector(mobileToken: mobileToken, captureFlow: captureFlow);

    AndroidSettings androidSettings = AndroidSettings(
        securitySettings: SecuritySettings(
            useAdb: true,
            useDebug: true,
            useDeveloperMode: true,
            useEmulator: true,
            useRoot: true));

    documentDetector.setEnableMultiLanguage(true);
    documentDetector.setAndroidSettings(androidSettings);
    documentDetector.setNetworkSettings(20);
    documentDetector.setStage(isBeta ? CafStage.beta : CafStage.prod);
    documentDetector.setPersonId(personId);
    documentDetector.setPreviewSettings(PreviewSettings(show: true));

    try {
      DocumentDetectorEvent event = await documentDetector.start();

      if (event is DocumentDetectorEventSuccess) {
        resultEvent = "SUCCESS";
        resultDescription = "Document Type: ${event.documentType}\n\n";
        for (Capture capture in event.captures!) {
          resultDescription += "#NEW CAPTURE\n";
          resultDescription += capture.label != null
              ? "Document Label: ${capture.label!}\n"
              : "empty\n";
          resultDescription += capture.quality != null
              ? "Image Quality: ${capture.quality}\n"
              : "empty\n";
          resultDescription += capture.imagePath != null
              ? "File path on device: ${capture.imagePath!}\n"
              : "empty\n";
          resultDescription += capture.imageUrl != null
              ? "File URL: ${capture.imageUrl!.split("?")[0]}\n"
              : "empty\n";
        }
      } else if (event is DocumentDetectorEventFailure) {
        resultEvent = "FAILURE";
        resultDescription = event.errorType != null
            ? "Failure Type: ${event.errorType}\n"
            : "empty\n";
        resultDescription += event.errorMessage != null
            ? "Failure Description: ${event.errorMessage}\n"
            : "empty\n";
        resultDescription += event.securityErrorCode != null
            ? "Security code: ${event.securityErrorCode}\n"
            : "none\n";
      } else if (event is DocumentDetectorEventClosed) {
        resultEvent = "CLOSED";
        resultDescription = "User closed document capture flow";
      }
    } on PlatformException catch (e) {
      resultEvent = "Error";
      resultDescription = "Error starting DocumentDetector: ${e.message}";
    }

    if (!mounted) return;

    setState(() {
      _resultEvent = resultEvent;
      _resultDescription = resultDescription;
    });
  }

  void startDocumentDetectorUploadFlow(
      List<DocumentCaptureFlow> captureFlow) async {
    personId =
        personIdController.text.isNotEmpty ? personIdController.text : personId;
    mobileToken = mobileTokenController.text.isNotEmpty
        ? mobileTokenController.text
        : mobileToken;

    String resultEvent = "";
    String resultDescription = "";

    DocumentDetector documentDetector =
        DocumentDetector(mobileToken: mobileToken, captureFlow: captureFlow);

    UploadSettings uploadSettings = UploadSettings();

    AndroidSettings androidSettings = AndroidSettings(
        securitySettings: SecuritySettings(
            useAdb: true,
            useDebug: true,
            useDeveloperMode: true,
            useEmulator: true,
            useRoot: true));

    documentDetector.setEnableMultiLanguage(true);
    documentDetector.setUploadSettings(uploadSettings);
    documentDetector.setAndroidSettings(androidSettings);
    documentDetector.setPersonId(personId);
    documentDetector.setStage(isBeta ? CafStage.beta : CafStage.prod);

    try {
      DocumentDetectorEvent event = await documentDetector.start();

      if (event is DocumentDetectorEventSuccess) {
        resultEvent = "SUCCESS";
        resultDescription = "Document Type: ${event.documentType}\n\n";
        for (Capture capture in event.captures!) {
          resultDescription += "#NEW CAPTURE\n";
          resultDescription += capture.label != null
              ? "Document Label: ${capture.label!}\n"
              : "empty\n";
          resultDescription += capture.quality != null
              ? "Image Quality: ${capture.quality}\n"
              : "empty\n";
          resultDescription += capture.imagePath != null
              ? "File path on device: ${capture.imagePath!}\n"
              : "empty\n";
          resultDescription += capture.imageUrl != null
              ? "File URL: ${capture.imageUrl!.split("?")[0]}\n"
              : "empty\n";
        }
      } else if (event is DocumentDetectorEventFailure) {
        resultEvent = "FAILURE";
        resultDescription = event.securityErrorCode != null
            ? "Security code: ${event.securityErrorCode}\n"
            : "none\n";
        resultDescription += event.errorMessage != null
            ? "Failure Description: ${event.errorMessage}\n"
            : "empty\n";
      } else if (event is DocumentDetectorEventClosed) {
        resultEvent = "CLOSED";
        resultDescription = "User closed document capture flow";
      }
    } on PlatformException catch (e) {
      resultEvent = "Error";
      resultDescription = "Error starting DocumentDetector: ${e.message}";
    }

    if (!mounted) return;

    setState(() {
      _resultEvent = resultEvent;
      _resultDescription = resultDescription;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('es'), // Spanish
      ],
      home: Scaffold(
          appBar: AppBar(
            title: const Text('DocumentDetector 7 Flutter Playground',
                softWrap: true, maxLines: 2, textAlign: TextAlign.center),
          ),
          body: Container(
              margin: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: mobileTokenController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Insert mobileToken here',
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: personIdController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Insert your ID/CPF here',
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SwitchListTile(
                            title: const Text('Beta'),
                            value: isBeta,
                            onChanged: (bool value) {
                              setState(() {
                                isBeta = value;
                              });
                            }),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        child: const Text('CNH front-back flow'),
                        onPressed: () async {
                          startDocumentDetector([
                            DocumentCaptureFlow(
                                documentType: DocumentType.cnhFront),
                            DocumentCaptureFlow(
                                documentType: DocumentType.cnhBack)
                          ]);
                        },
                      )
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        child: const Text('RG front-back flow'),
                        onPressed: () async {
                          startDocumentDetector([
                            DocumentCaptureFlow(
                                documentType: DocumentType.rgFront),
                            DocumentCaptureFlow(
                                documentType: DocumentType.rgBack)
                          ]);
                        },
                      )
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        child: const Text('CNH full Upload flow'),
                        onPressed: () async {
                          startDocumentDetectorUploadFlow([
                            DocumentCaptureFlow(
                                documentType: DocumentType.cnhFull),
                          ]);
                        },
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Text("Result Event: $_resultEvent"))
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Content: \n$_resultDescription",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }
}
