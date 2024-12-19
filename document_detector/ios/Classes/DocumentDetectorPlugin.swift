import Flutter
import UIKit
import DocumentDetector

public class DocumentDetectorPlugin: NSObject, FlutterPlugin, DocumentDetectorControllerDelegate {
    
    var flutterResult: FlutterResult?
    var sdkResult : [String: Any?] = [:]
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "document_detector", binaryMessenger: registrar.messenger())
        let instance = DocumentDetectorPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == Constants.start {
            flutterResult = result
            do {
                start(call: call)
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func start(call: FlutterMethodCall) {
        guard let arguments = call.arguments as? [String: Any?] else {
            fatalError("Critical error: Unable to get argument mapping")
        }
        
        // Set the mobile token
        guard let mobileToken = arguments["mobileToken"] as? String else {
            fatalError("Critical error: Unable to get mobileToken")
        }
        
        var mDocumentDetectorBuilder = DocumentDetectorSdk.CafBuilder(mobileToken: mobileToken)
        
        // Set document capture flow
        if let captureFlow = arguments["captureFlow"] as? [[String: Any]] ?? nil {
            var documentDetectorSteps : [DocumentDetectorStep] = []
            for (_, step) in captureFlow.enumerated() {
                if let type = step["documentType"] as? String {
                    let documentType = convertToDocument(documentType: type)
                    if let messageSettings = arguments["messageSettings"] as? [String: Any] ?? nil {
                        documentType.wrongDocumentText = messageSettings["wrongDocumentTypeMessage"] as? String ?? nil
                    }
                    var documentIllustration: UIImage?
                    var documentLabel : String?
                    
                    // Set instructional popup customization
                    if let stepCustomization = step["iOSCustomization"] as? [String: Any] ?? nil {
                        documentLabel = stepCustomization["documentLabel"] as? String ?? nil
                        
                        if let customIllustration = stepCustomization["documentIllustration"] as? String ?? nil {
                            documentIllustration = UIImage(named: customIllustration)
                        }
                    }
                    documentDetectorSteps.append(
                        DocumentDetectorStep(
                            document: documentType,
                            stepLabel: documentLabel,
                            illustration: documentIllustration
                        )
                    )
                }
            }
            _ = mDocumentDetectorBuilder.setDocumentCaptureFlow(flow: documentDetectorSteps)
        }
        
        // Set personID
        if let personId = arguments["personId"] as? String ?? nil {
            _ = mDocumentDetectorBuilder.setPersonId(personId: personId)
        }
        
        // Set enable instructional popup
        if let displayPopup = arguments["displayPopup"] as? Bool ?? nil {
            _ = mDocumentDetectorBuilder.setPopupSettings(show: displayPopup)
        }
        
        // Set the SDK environment - PROD, BETA
        if let stage = arguments["stage"] as? String ?? nil {
            _ = mDocumentDetectorBuilder.setStage(stage: getCafStage(stage: stage))
        }
        
        // Set request timeout settings
        if let timeout = arguments["requestTimeout"] as? Int ?? nil {
            _ = mDocumentDetectorBuilder.setNetworkSettings(requestTimeout: TimeInterval(timeout))
        }
        
        // Set captured document image Url expiration time settings
        if let urlExpirationTime = arguments["urlExpirationTime"] as? String ?? nil {
            _ = mDocumentDetectorBuilder.setGetImageUrlExpireTime(urlExpirationTime)
        }
        
        // Set current step done delay settings
        if let millisecondsDelay = arguments["secondsDelay"] as? Int ?? nil {
            _ = mDocumentDetectorBuilder.setCurrentStepDoneDelay(
                currentStepDoneDelay: TimeInterval(millisecondsDelay)
            )
        }
        
        // Set document picture preview settings
        if let previewSettings = arguments["previewSettings"] as? [String: Any] ?? nil {
            let show = previewSettings["show"] as? Bool ?? false
            let title = previewSettings["title"] as? String ?? nil
            let subtitle = previewSettings["subtitle"] as? String ?? nil
            let confirmLabel = previewSettings["confirmLabel"] as? String ?? nil
            let retryLabel = previewSettings["retryLabel"] as? String ?? nil
            _ = mDocumentDetectorBuilder.showPreview(
                show,
                title: title,
                subtitle: subtitle,
                confirmLabel: confirmLabel,
                retryLabel: retryLabel
            )
        }
        
        // Set passport restriction list settings
        if let countryCodeList = arguments["countryCodeList"] as? [String] ?? nil {
            var countryCodes : [CafCountryCodes] = []
            for countryCode in countryCodeList {
                if let countryCodeEnum = CafCountryCodes(rawValue: countryCode) {
                    countryCodes.append(countryCodeEnum)
                }
            }
            _ = mDocumentDetectorBuilder.setAllowedPassportList(passportList: countryCodes)
        }
        
        // Set document upload flow settings
        if let uploadSettings = arguments["uploadSettings"] as? [String: Any] ?? nil {
            let settings = CafUploadSettings()
            
            // Set enable file compression
            if let compress = uploadSettings["compress"] as? Bool ?? nil {
                settings.compress = compress
            }
            
            // Set max file size to upload
            if let maxFileSize = uploadSettings["maxFileSize"] as? Int ?? nil {
                settings.maximumFileSize = maxFileSize * 1000
            }
            
            var fileFormat : [CafFileFormat] = []
            // Set accepted file format list
            if let fileFormatList = uploadSettings["fileFormatsIOS"] as? [String] ?? nil {
                for format in fileFormatList {
                    if let fileFormatEnum = CafFileFormat(rawValue: format) {
                        fileFormat.append(fileFormatEnum)
                    }
                }
                settings.fileFormats = fileFormat
            }
            _ = mDocumentDetectorBuilder.setUploadSettings(uploadSettings: settings)
        }
        
        // Set message Settings
        if let messageSettings = arguments["messageSettings"] as? [String: Any] ?? nil {
            setMessageSettings(messageSettings: messageSettings, mDocumentDetectorBuilder: &mDocumentDetectorBuilder)
        }
        
        // Set iOS exclusive customization settings
        if let iosSettings = arguments["iosSettings"] as? [String: Any] ?? nil {
            // Set SDK sensors settings
            if let sensorSettings = iosSettings["sensorSettings"] as? [String: Any] ?? nil {
                // Set luminosity sensor
                if let luminositySettings = sensorSettings["luminositySettings"] as? Float ?? nil {
                    _ = mDocumentDetectorBuilder.setLuminositySensorSettings(luminosityThreshold: luminositySettings)
                }
                // Set orientation sensor
                if let orientationSettings = sensorSettings["orientationSettings"] as? Double ?? nil {
                    _ = mDocumentDetectorBuilder.setOrientationSensorSettings(orientationThreshold: orientationSettings)
                }
                // Set stability sensor
                if let stabilitySettings = sensorSettings["stabilitySettings"] as? Double ?? nil {
                    _ = mDocumentDetectorBuilder.setStabilitySensorSettings(stabilityThreshold: stabilitySettings)
                }
            }
            // Set the capture file compression settings
            if let captureCompression = iosSettings["compressionQuality"] as? Double ?? nil {
                _ = mDocumentDetectorBuilder.setCompressSettings(compressionQuality: captureCompression)
            }
            // Set manual capture feature
            if let enableManualCapture = iosSettings["enableManualCapture"] as? Bool ?? nil {
                if let timeDelay = iosSettings["manualCaptureActivationDelay"] as? Int ?? nil {
                    _ = mDocumentDetectorBuilder.setManualCaptureSettings(
                        enable: enableManualCapture,
                        time: TimeInterval(timeDelay)
                    )
                } else {
                    _ = mDocumentDetectorBuilder.setManualCaptureSettings(
                        enable: enableManualCapture,
                        time: 45)
                }
            }
            // Set multi-language support
            if let enableMultilanguage = iosSettings["enableMultilanguage"] as? Bool ?? nil {
                _ = mDocumentDetectorBuilder.enableMultiLanguage(enableMultilanguage)
            }
            // Set capture resolution
            if let resolution = iosSettings["cameraResolution"] as? String ?? nil {
                _ = mDocumentDetectorBuilder.setResolutionSettings(
                    resolution: getCaptureResolution(resolution: resolution)
                )
            }
            // Set layout customizations settings
            if let customLayout = iosSettings["layoutCustomization"] as? [String: Any] ?? nil {
                let layoutSettings = DocumentDetectorLayout()
                
                // Set the SDK main UI color
                if let primaryColor = customLayout["primaryColor"] as? String ?? nil {
                    layoutSettings.setPrimaryColor(color: UIColor(hexString: primaryColor))
                }
                
                // Set the UI feedback color displayed in the capture process
                if let feedbackColors = customLayout["feedbackColors"] as? [String: Any] ?? nil {
                    if let defaultColor = feedbackColors["defaultColor"] as? String,
                       let successColor = feedbackColors["successColor"] as? String,
                       let errorColor = feedbackColors["errorColor"] as? String {
                        layoutSettings.setFeedbackColors(
                            colors: DocumentFeedbackColors(
                                defaultColor: UIColor(hexString: defaultColor),
                                errorColor: UIColor(hexString: errorColor),
                                successColor: UIColor(hexString: successColor)
                            )
                        )
                    }
                }
                
                // Set the SDK text font
                if let fontStyle = customLayout["fontStyle"] as? String ?? nil {
                    layoutSettings.setFont(name: fontStyle)
                }
                
                _ = mDocumentDetectorBuilder.setLayout(layout: layoutSettings)
            }
        }
        
        let documentDetectorVC = DocumentDetectorController(documentDetector: mDocumentDetectorBuilder.build())
        documentDetectorVC.documentDetectorDelegate = self
        
        // Set the app last window as the current key window to the view controller
        if let viewController = UIApplication.shared.currentKeyWindow?.rootViewController {
            viewController.present(documentDetectorVC, animated: true, completion: nil)
        } else {
            sdkResult["event"] = Constants.eventError
            sdkResult["errorMessage"] = Constants.defaultErrorMessage
            
            if let flutterResult {
                flutterResult(sdkResult)
            }
        }
    }
    
    public func documentDetectionController(
        _ scanner: DocumentDetector.DocumentDetectorController,
        didFinishWithResults results: DocumentDetector.DocumentDetectorResult)
    {
        sdkResult["event"] = Constants.eventSuccess
        
        if let docType = results.type ?? nil {
            sdkResult["documentType"] = docType
        }
        if let trackingId = results.trackingId ?? nil {
            sdkResult["trackingId"] = trackingId
        }
        
        var captureMap: [Dictionary<String, Any>] = []
        for (_, capture) in results.captures.enumerated() {
            var captureDict: [String: Any] = [:]
            
            captureDict["imageUrl"] = capture.imageUrl
            captureDict["label"] = capture.label
            captureDict["quality"] = capture.quality
            
            captureMap.append(captureDict)
        }
        sdkResult["captures"] = captureMap
        
        if let flutterResult {
            flutterResult(sdkResult)
        }
    }
    
    public func documentDetectionControllerDidCancel(
        _ scanner: DocumentDetector.DocumentDetectorController)
    {
        sdkResult["event"] = Constants.eventCanceled
        
        if let flutterResult {
            flutterResult(sdkResult)
        }
    }
    
    public func documentDetectionController(
        _ scanner: DocumentDetector.DocumentDetectorController,
        didFailWithError error: DocumentDetector.CafDocumentDetectorFailure)
    {
        sdkResult["event"] = Constants.eventError
        sdkResult["errorType"] = String(describing: type(of: error))
        if let errorMessage = error.message ?? nil {
            sdkResult["errorMessage"] = errorMessage
        }
        
        if let flutterResult {
            flutterResult(sdkResult)
        }
    }
}
