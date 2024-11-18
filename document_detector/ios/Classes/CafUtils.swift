import DocumentDetector

extension DocumentDetectorPlugin {
    
    struct Constants {
        static let start = "start"
        static let defaultErrorMessage = "Error initializing DocumentDetector SDK"
        static let argumentsErrorMessage = "Critical error: unable to get argument mapping"
        static let mobileTokenErrorMessage = "Critical error: unable to get mobileToken"
        static let eventCanceled = "canceled"
        static let eventError = "failure"
        static let eventSuccess = "success"
    }
    
    func getCafStage(stage: String) -> DDCAFStage {
        switch stage {
        case "PROD":
            return DDCAFStage.PROD
        case "BETA":
            return DDCAFStage.BETA
        default:
            return DDCAFStage.PROD
        }
    }
    
    func getCaptureResolution(resolution: String) -> CafResolution {
        switch resolution {
        case "FULL_HD":
            return CafResolution.FULL_HD
        case "ULTRA_HD":
            return CafResolution.ULTRA_HD
        default:
            return CafResolution.FULL_HD
        }
    }
    
    func convertToDocument (documentType: String) -> CafDocument {
        switch documentType {
        case "CNH_FRONT":
            return CafDocument.CNH_FRONT
        case "CNH_BACK":
            return CafDocument.CNH_BACK
        case "CNH_FULL":
            return CafDocument.CNH_FULL
        case "RG_FRONT":
            return CafDocument.RG_FRONT
        case "RG_BACK":
            return CafDocument.RG_BACK
        case "RG_FULL":
            return CafDocument.RG_FULL
        case "CRLV":
            return CafDocument.CRLV
        case "RNE_FRONT":
            return CafDocument.RNE_FRONT
        case "RNE_BACK":
            return CafDocument.RNE_BACK
        case "PASSPORT":
            return CafDocument.PASSPORT
        case "CTPS_FRONT":
            return CafDocument.CTPS_FRONT
        case "CTPS_BACK":
            return CafDocument.CTPS_BACK
        case "ANY":
            return CafDocument.ANY
        default:
            return CafDocument.ANY
        }
    }
    
    internal func setMessageSettings(messageSettings: [String: Any], mDocumentDetectorBuilder: inout DocumentDetectorSdk.CafBuilder) {
        let waitMessage = messageSettings["waitMessage"] as? String ?? nil
        let fitTheDocumentMessage = messageSettings["fitTheDocumentMessage"] as? String ?? nil
        let verifyingQualityMessage = messageSettings["verifyingQualityMessage"] as? String ?? nil
        let lowQualityDocumentMessage = messageSettings["lowQualityDocumentMessage"] as? String ?? nil
        let uploadingImageMessage = messageSettings["uploadingImageMessage"] as? String ?? nil
        let sensorOrientationMessage = messageSettings["sensorOrientationMessage"] as? String ?? nil
        let sensorLuminosityMessage = messageSettings["sensorLuminosityMessage"] as? String ?? nil
        let sensorStabilityMessage = messageSettings["sensorStabilityMessage"] as? String ?? nil
        let popupDocumentSubtitleMessage = messageSettings["popupDocumentSubtitleMessage"] as? String ?? nil
        let scanDocumentMessage = messageSettings["scanDocumentMessage"] as? String ?? nil
        let getCloserMessage = messageSettings["getCloserMessage"] as? String ?? nil
        let centralizeDocumentMessage = messageSettings["centralizeDocumentMessage"] as? String ?? nil
        let moveAwayMessage = messageSettings["moveAwayMessage"] as? String ?? nil
        let alignDocumentMessage = messageSettings["alignDocumentMessage"] as? String ?? nil
        let turnDocumentMessage = messageSettings["turnDocumentMessage"] as? String ?? nil
        let documentCapturedMessage = messageSettings["documentCapturedMessage"] as? String ?? nil
        
        _ = mDocumentDetectorBuilder.setMessageSettings(
            waitMessage: waitMessage,
            fitTheDocumentMessage: fitTheDocumentMessage,
            verifyingQualityMessage: verifyingQualityMessage,
            lowQualityDocumentMessage: lowQualityDocumentMessage,
            uploadingImageMessage: uploadingImageMessage,
            popupDocumentSubtitleMessage: popupDocumentSubtitleMessage,
            unsupportedDocumentMessage: nil,
            wrongDocumentMessage: nil,
            sensorLuminosityMessage: sensorLuminosityMessage,
            sensorOrientationMessage: sensorOrientationMessage,
            sensorStabilityMessage: sensorStabilityMessage,
            predictorScanDocumentMessage: scanDocumentMessage,
            predictorGetCloserMessage: getCloserMessage,
            predictorCentralizeMessage: centralizeDocumentMessage,
            predictorMoveAwayMessage: moveAwayMessage,
            predictorAlignDocumentMessage: alignDocumentMessage,
            predictorTurnDocumentMessage: turnDocumentMessage,
            predictorCapturedMessage: documentCapturedMessage
        )
    }
}
