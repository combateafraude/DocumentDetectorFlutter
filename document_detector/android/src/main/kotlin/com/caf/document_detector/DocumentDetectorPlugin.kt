package com.caf.document_detector

import android.app.Activity
import android.content.Context
import android.content.Intent
import com.combateafraude.documentdetector.DocumentDetectorActivity
import com.combateafraude.documentdetector.input.CafStage
import com.combateafraude.documentdetector.input.CaptureMode
import com.combateafraude.documentdetector.input.CaptureStage
import com.combateafraude.documentdetector.input.CountryCodesList
import com.combateafraude.documentdetector.input.Document
import com.combateafraude.documentdetector.input.DocumentDetector
import com.combateafraude.documentdetector.input.DocumentDetectorStep
import com.combateafraude.documentdetector.input.FeedbackColors
import com.combateafraude.documentdetector.input.FileFormat
import com.combateafraude.documentdetector.input.MessageSettings
import com.combateafraude.documentdetector.input.PreviewSettings
import com.combateafraude.documentdetector.input.Resolution
import com.combateafraude.documentdetector.input.SensorLuminositySettings
import com.combateafraude.documentdetector.input.SensorOrientationSettings
import com.combateafraude.documentdetector.input.SensorStabilitySettings
import com.combateafraude.documentdetector.input.UploadSettings
import com.combateafraude.documentdetector.output.DocumentDetectorResult
import com.combateafraude.documentdetector.output.failure.SDKFailure
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry


class DocumentDetectorPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    companion object {
        private const val SDK_REQUEST_CODE = 1001
        private const val STYLE_RES = "style"
        private const val COLOR_RES = "color"
        private const val START_METHOD_CALL = "start"
        private const val METHOD_CHANNEL_NAME = "document_detector"
        private const val SUCCESS_EVENT = "success"
        private const val FAILURE_EVENT = "failure"
        private const val CANCELED_EVENT = "canceled"
    }

    private lateinit var channel: MethodChannel
    private lateinit var result: Result
    private lateinit var activityBinding: ActivityPluginBinding
    private lateinit var activity: Activity
    private lateinit var context: Context

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == START_METHOD_CALL) {
            this.result = result
            startDocumentDetector(call)
        } else {
            result.notImplemented()
        }
    }

    private fun startDocumentDetector(call: MethodCall) {
        val argumentsMap = call.arguments as HashMap<*, *>

        // Get the mobile token
        val mobileToken = argumentsMap["mobileToken"] as String

        val mDocumentDetectorBuilder = DocumentDetector.Builder(mobileToken)

        // Get personID
        val personId = argumentsMap["personId"] as String?
        personId?.let { mDocumentDetectorBuilder.setPersonId(it) }

        // Get Url expiration time settings
        val urlExpirationTime = argumentsMap["urlExpirationTime"] as String?
        urlExpirationTime?.let { mDocumentDetectorBuilder.setGetImageUrlExpireTime(it) }

        // Get request timeout settings
        val requestTimeout = argumentsMap["requestTimeout"] as Int?
        requestTimeout?.let { mDocumentDetectorBuilder.setNetworkSettings(it) }

        // Get instructional popup settings
        val displayPopup = argumentsMap["displayPopup"] as Boolean?
        displayPopup?.let { mDocumentDetectorBuilder.setPopupSettings(it) }

        // Get current step done delay settings
        val enableDelay = argumentsMap["enableDelay"] as Boolean?
        enableDelay?.let { enable ->
            val milliseconds = argumentsMap["millisecondsDelay"] as Int?
            milliseconds?.let { time ->
                mDocumentDetectorBuilder.setCurrentStepDoneDelay(enable, time)
            }
        }

        // Get the Stage environment
        val stage = argumentsMap["stage"] as String?
        stage?.let { mDocumentDetectorBuilder.setStage(CafStage.valueOf(it)) }

        // Get document capture flow
        val captureFlow = argumentsMap["captureFlow"] as ArrayList<*>
        captureFlow.let {
            val detectionSteps = arrayOfNulls<DocumentDetectorStep>(it.size)
            for (i in it.indices) {
                val step = it[i] as HashMap<*, *>
                val document = Document.valueOf(step["documentType"] as String)

                val stepCustomization = step["androidCustomization"] as HashMap<*, *>?
                if (stepCustomization != null) {
                    val detectionStep = DocumentDetectorStep(document)
                    val customStepLabel = stepCustomization["documentLabel"] as String?
                    customStepLabel?.let { resName ->
                        detectionStep.setStringStepLabel(resName)
                    }
                    val customIllustration = stepCustomization["documentIllustration"] as String?
                    customIllustration?.let { resName ->
                        detectionStep.stringIllustration = resName
                    }
                    detectionSteps[i] = detectionStep
                } else {
                    detectionSteps[i] = DocumentDetectorStep(document)
                }
            }
            mDocumentDetectorBuilder.setDocumentCaptureFlow(detectionSteps)
        }

        // Get document upload flow settings
        val uploadSettings = argumentsMap["uploadSettings"] as HashMap<*, *>?
        uploadSettings?.let {
            val settings = UploadSettings()

            val compress = uploadSettings["compress"] as Boolean?
            compress?.let { settings.setCompress(it) }
            val maxFileSize = uploadSettings["maxFileSize"] as Int?
            maxFileSize?.let { settings.setMaxFileSize(it) }
            val fileFormats = uploadSettings["fileFormatsAndroid"] as ArrayList<*>?
            fileFormats?.let {
                val formats = arrayOfNulls<FileFormat>(it.size)
                for (i in it.indices) {
                    formats[i] = FileFormat.valueOf(it[i] as String)
                }
                settings.setFileFormats(formats)
            }

            mDocumentDetectorBuilder.setUploadSettings(settings)
        }

        // Get capture preview settings
        val previewSettings = argumentsMap["previewSettings"] as HashMap<*, *>?
        previewSettings?.let {
            val show = previewSettings["show"] as Boolean
            val title = previewSettings["title"] as String?
            val subtitle = previewSettings["subtitle"] as String?
            val confirmButtonLabel = previewSettings["confirmLabel"] as String?
            val retryButtonLabel = previewSettings["retryLabel"] as String?

            mDocumentDetectorBuilder.setPreviewSettings(
                PreviewSettings(show, title, subtitle, confirmButtonLabel, retryButtonLabel)
            )
        }

        // Get custom messages settings
        val messageSettings = argumentsMap["messageSettings"] as HashMap<*, *>?
        messageSettings?.let {
            val waitMessage = messageSettings["waitMessage"] as String?
            val fitTheDocumentMessage = messageSettings["fitTheDocumentMessage"] as String?
            val holdItMessage = messageSettings["holdItMessage"] as String?
            val verifyingQualityMessage = messageSettings["verifyingQualityMessage"] as String?
            val lowQualityDocumentMessage = messageSettings["lowQualityDocumentMessage"] as String?
            val uploadingImageMessage = messageSettings["uploadingImageMessage"] as String?
            val sensorOrientationMessage = messageSettings["sensorOrientationMessage"] as String?
            val sensorLuminosityMessage = messageSettings["sensorLuminosityMessage"] as String?
            val sensorStabilityMessage = messageSettings["sensorStabilityMessage"] as String?
            val popupDocumentSubtitleMessage =
                messageSettings["popupDocumentSubtitleMessage"] as String?
            val aiScanDocumentMessage = messageSettings["aiScanDocumentMessage"] as String?
            val aiGetCloserMessage = messageSettings["aiGetCloserMessage"] as String?
            val aiCentralizeMessage = messageSettings["aiCentralizeMessage"] as String?
            val aiMoveAwayMessage = messageSettings["aiMoveAwayMessage"] as String?
            val aiAlignMessage = messageSettings["aiAlignMessage"] as String?
            val aiTurnDocumentMessage = messageSettings["aiTurnDocumentMessage"] as String?
            val aiCapturedMessage = messageSettings["aiCapturedMessage"] as String?

            // This messages customization only exists in the Android version
            val popupConfirmButtonMessage = messageSettings["popupConfirmButtonMessage"] as String?
            val wrongDocumentTypeMessage = messageSettings["wrongDocumentTypeMessage"] as String?
            val unsupportedDocumentMessage =
                messageSettings["unsupportedDocumentMessage"] as String?
            val documentNotFoundMessage = messageSettings["documentNotFoundMessage"] as String?

            val settings = MessageSettings(
                waitMessage,
                fitTheDocumentMessage,
                holdItMessage,
                verifyingQualityMessage,
                lowQualityDocumentMessage,
                uploadingImageMessage,
                null,
                unsupportedDocumentMessage,
                documentNotFoundMessage,
                sensorLuminosityMessage,
                sensorOrientationMessage,
                sensorStabilityMessage,
                popupDocumentSubtitleMessage,
                popupConfirmButtonMessage,
                aiScanDocumentMessage,
                aiGetCloserMessage,
                aiCentralizeMessage,
                aiMoveAwayMessage,
                aiAlignMessage,
                aiTurnDocumentMessage,
                aiCapturedMessage,
                wrongDocumentTypeMessage
            )

            mDocumentDetectorBuilder.setMessageSettings(settings)
        }

        // Get Android exclusive settings
        val androidSettings = argumentsMap["androidSettings"] as HashMap<*, *>?
        androidSettings?.let {

            // Get sensor settings
            val sensorSettings = androidSettings["sensorSettings"] as HashMap<*, *>?
            sensorSettings?.let { settings ->

                // Get sensor orientation settings
                val sensorOrientation = settings["orientationSensorThreshold"] as Double?
                sensorOrientation?.let {
                    mDocumentDetectorBuilder.setOrientationSensorSettings(
                        SensorOrientationSettings(
                            it
                        )
                    )
                }

                // Get sensor luminosity settings
                val sensorLuminosity = settings["luminositySensorThreshold"] as Int?
                sensorLuminosity?.let {
                    mDocumentDetectorBuilder.setLuminositySensorSettings(SensorLuminositySettings(it))
                }

                // Get sensor stability settings
                val sensorStability = settings["stabilitySensorSettings"] as HashMap<*, *>?
                sensorStability?.let { stability ->
                    val threshold = stability["stabilityThreshold"] as Double
                    val time = stability["deviceStillMilliseconds"] as Int
                    mDocumentDetectorBuilder.setStabilitySensorSettings(
                        SensorStabilitySettings(
                            time.toLong(),
                            threshold
                        )
                    )
                }

                // If any of the sensors are disabled, set their constructor to null
                val disableOrientationSensor = settings["disableOrientationSensor"] as Boolean?
                disableOrientationSensor?.let { disable ->
                    if (disable) {
                        mDocumentDetectorBuilder.setOrientationSensorSettings(null)
                    }
                }
                val disableLuminositySensor = settings["disableLuminositySensor"] as Boolean?
                disableLuminositySensor?.let { disable ->
                    if (disable) {
                        mDocumentDetectorBuilder.setLuminositySensorSettings(null)
                    }
                }
                val disableStabilitySensor = settings["disableStabilitySensor"] as Boolean?
                disableStabilitySensor?.let { disable ->
                    if (disable) {
                        mDocumentDetectorBuilder.setStabilitySensorSettings(null)
                    }
                }
            }

            // Get capture stages settings
            val captureStagesConfig = androidSettings["captureStages"] as ArrayList<*>?
            captureStagesConfig?.let {
                val stages = arrayOfNulls<CaptureStage>(it.size)
                for (i in it.indices) {
                    val captureStage = it[i] as HashMap<*, *>

                    val durationMs = captureStage["durationMillis"] as Int?
                    val sensorCheck = captureStage["wantSensorCheck"] as Boolean
                    val captureMode = CaptureMode.valueOf(captureStage["captureMode"] as String)

                    stages[i] = CaptureStage(captureMode, durationMs?.toLong(), sensorCheck)
                }
                mDocumentDetectorBuilder.setCaptureStages(stages)
            }

            // Get image compression settings
            val compressQuality = androidSettings["compressQuality"] as Int?
            compressQuality?.let { mDocumentDetectorBuilder.setCompressSettings(it) }

            // Get camera resolution settings
            val cameraResolution = androidSettings["cameraResolution"] as String?
            cameraResolution?.let {
                mDocumentDetectorBuilder.setResolutionSettings(Resolution.valueOf(it))
            }

            // Get security settings
            val securitySettings = androidSettings["securitySettings"] as HashMap<*, *>?
            securitySettings?.let {
                val enableGoogleServices = securitySettings["enableGoogleServices"] as Boolean?
                enableGoogleServices?.let { mDocumentDetectorBuilder.enableGoogleServices(it) }

                val developerModeDetection = securitySettings["developerModeDetection"] as Boolean?
                developerModeDetection?.let { mDocumentDetectorBuilder.setUseDeveloperMode(it) }

                val debugDetection = securitySettings["debugDetection"] as Boolean?
                debugDetection?.let { mDocumentDetectorBuilder.setUseDebug(it) }

                val adbDetection = securitySettings["adbDetection"] as Boolean?
                adbDetection?.let { mDocumentDetectorBuilder.setUseAdb(it) }
            }

            // Get custom style settings
            val customStyle = androidSettings["customStyleResName"] as String?
            customStyle?.let { resName ->
                mDocumentDetectorBuilder.setStyle(getResourceId(resName, STYLE_RES))
            }

            val feedbackColors = androidSettings["feedbackColors"] as HashMap<*, *>?
            feedbackColors?.let {
                val defaultColorResId =
                    getResourceId(feedbackColors["defaultColorResName"] as String, COLOR_RES)
                val successColorResId =
                    getResourceId(feedbackColors["successColorResName"] as String, COLOR_RES)
                val errorColorResId =
                    getResourceId(feedbackColors["errorColorResName"] as String, COLOR_RES)

                mDocumentDetectorBuilder.setFeedbackColors(
                    FeedbackColors(defaultColorResId, successColorResId, errorColorResId)
                )
            }
        }

        val countryCodeList = argumentsMap["countryCodeList"] as ArrayList<*>?
        countryCodeList?.let {
            val countries = arrayOfNulls<CountryCodesList>(it.size)
            for (i in it.indices) {
                countries[i] = CountryCodesList.valueOf(it[i] as String)
            }
            mDocumentDetectorBuilder.setAllowedPassportCountriesList(countries)
        }

        val intent = Intent(context, DocumentDetectorActivity::class.java)
        intent.putExtra(DocumentDetector.PARAMETER_NAME, mDocumentDetectorBuilder.build())
        activity.startActivityForResult(intent, SDK_REQUEST_CODE)
    }

    private val activityResultListener = PluginRegistry.ActivityResultListener { requestCode, resultCode, data ->
        if (requestCode != SDK_REQUEST_CODE) return@ActivityResultListener false

        if (resultCode == Activity.RESULT_OK && data != null) {
            val documentDetectorResult =
                data.getSerializableExtra(DocumentDetectorResult.PARAMETER_NAME) as? DocumentDetectorResult
            if (documentDetectorResult == null) {
                result.success(getActivityResultErrorResponseMap())
            } else {
                val responseMap = if (documentDetectorResult.wasSuccessful()) {
                    getSuccessResponseMap(documentDetectorResult)
                } else {
                    getErrorResponseMap(documentDetectorResult.sdkFailure)
                }
                result.success(responseMap)
            }
        } else {
            result.success(getCanceledResponseMap())
        }
        true
    }

    private fun getSuccessResponseMap(documentDetectorResult: DocumentDetectorResult): HashMap<String, Any> {
        val responseMap = HashMap<String, Any>()
        responseMap["event"] = SUCCESS_EVENT
        val captures = ArrayList<HashMap<String, Any?>>()
        documentDetectorResult.captures.forEach { capture ->
            capture ?: return@forEach
            val captureMap = HashMap<String, Any?>()
            captureMap["imagePath"] = capture.imagePath
            captureMap["imageUrl"] = capture.imageUrl
            captureMap["label"] = capture.label
            captureMap["quality"] = capture.quality
            captures.add(captureMap)
        }

        responseMap["captures"] = captures
        responseMap["documentType"] = documentDetectorResult.type
        documentDetectorResult.trackingId?.let { trackingId ->
            responseMap["trackingId"] = trackingId
        }
        return responseMap
    }

    private fun getErrorResponseMap(sdkFailure: SDKFailure?): HashMap<String, Any> {
        val responseMap = HashMap<String, Any>()
        responseMap["event"] = FAILURE_EVENT
        sdkFailure?.let { responseMap["errorType"] = sdkFailure.javaClass.simpleName }
        sdkFailure?.message?.let { message -> responseMap["errorMessage"] = message }
        sdkFailure?.securityErrorCode?.let { securityCode ->
            responseMap["securityErrorCode"] = securityCode
        }
        return responseMap
    }

    private fun getCanceledResponseMap(): HashMap<String, Any> {
        val responseMap = HashMap<String, Any>()
        responseMap["event"] = CANCELED_EVENT
        return responseMap
    }

    private fun getActivityResultErrorResponseMap(): HashMap<String, Any> {
        val responseMap = HashMap<String, Any>()
        responseMap["event"] = FAILURE_EVENT
        responseMap["errorMessage"] = "Couldn't get DocumentDetector result."
        return responseMap
    }

    private fun getResourceId(resourceName: String, resourceType: String): Int {
        val resId =
            activity.resources.getIdentifier(resourceName, resourceType, activity.packageName)
        return if (resId != 0) resId
        else throw IllegalArgumentException("Invalid resource name: $resourceName of type $resourceType")
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL_NAME)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        activityBinding = binding
        activityBinding.addActivityResultListener(activityResultListener)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityBinding.removeActivityResultListener(activityResultListener)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        activityBinding = binding
        activityBinding.addActivityResultListener(activityResultListener)
    }

    override fun onDetachedFromActivity() {
        activityBinding.removeActivityResultListener(activityResultListener)
    }
}
