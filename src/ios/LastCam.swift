// MARK: Cordova Exposures.

import AVFoundation
import CoreImage
import MediaPlayer
import UIKit
import CameraManager

let cameraManager = CameraManager()
var parentView: UIView? = nil;
var view = UIView(frame: parentView!.bounds);

var cameraStarted: Bool = false;

// MARK: BIG PICTURE FUNCTIONS
@objc(LastCam) class LastCam: CDVPlugin {
    @objc(startCamera:)
    func startCamera(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR);

        // stop the device from being able to sleep
        UIApplication.shared.isIdleTimerDisabled = true

        // Command Arguments
        let x:Int = command.arguments![0] as! Int;
        let y:Int = command.arguments![1] as! Int;
        let width:Int = command.arguments![2] as! Int;
        let height:Int = command.arguments![3] as! Int;

        // get rid of the old view (causes issues if the app is resumed)
        parentView = nil;

        //make the view
        let viewRect = CGRect.init(x: x, y: y, width: width, height: height)

        parentView = UIView(frame: viewRect)
        webView?.superview?.addSubview(parentView!)
        parentView!.addSubview(view)
        parentView!.isUserInteractionEnabled = true

        // This is needed so that we can show the camera buttons above the camera-view.
        webView?.isOpaque = false
        webView?.backgroundColor = UIColor.clear

        cameraManager.cameraOutputMode = CameraOutputMode.stillImage;
        cameraManager.writeFilesToPhoneLibrary = false

        cameraManager.addPreviewLayerToView(parentView!)

        // Add this in there, incase the camera session has already been created.
        cameraManager.resumeCaptureSession();

        webView.superview?.bringSubview(toFront: webView);

        cameraStarted = true;

        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK);
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }

    @objc(stopCamera:)
    func stopCamera(command: CDVInvokedUrlCommand) {

        cameraManager.stopCaptureSession();

        // Remove the view, so that we don't see the last frame of the stream.
        parentView?.removeFromSuperview();
        parentView = nil;

        cameraStarted = false;

        var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR);
        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK);

        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }

    @objc(takePicture:)
    func takePicture(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Camera session isn't started");
        if(!cameraStarted) {
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        } else {
            cameraManager.capturePictureWithCompletion({ (image, error) -> Void in
                let base64Image = UIImageJPEGRepresentation(image!, 0.85)!
                    .base64EncodedString(options: .lineLength64Characters)
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: base64Image);
                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
            });
        }
    }

    @objc(switchCamera:)
    func switchCamera(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Camera session isn't started");

        if(!cameraStarted) {
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        } else {
            let cameraDevice = cameraManager.cameraDevice;
            let cameraView = cameraDevice == CameraDevice.front ? "back" : "front"

            cameraManager.cameraDevice = cameraDevice == CameraDevice.front ? CameraDevice.back : CameraDevice.front

            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: cameraView);
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        }
    }

    @objc(switchFlash:)
    func switchFlash(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Camera session isn't started");
        if(!cameraStarted) {
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        } else {
            cameraManager.changeFlashMode();
            let flashMode = cameraManager.flashMode;

            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: flashMode.rawValue);
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        }
    }

    @objc(startVideoCapture:)
    func startVideoCapture(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Camera session isn't started");
        if(!cameraStarted) {
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        } else {

            if(cameraManager.cameraOutputMode == .stillImage) {
                print("Camera output is stillImage, switching to videoWithMic");
                cameraManager.cameraOutputMode = CameraOutputMode.videoWithMic;
            }

            cameraManager.startRecordingVideo();
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK);
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        }
    }

    @objc(stopVideoCapture:)
    func stopVideoCapture(command: CDVInvokedUrlCommand) {

        var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Camera session isn't started");
        if(!cameraStarted) {
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        } else {

            cameraManager.stopVideoRecording { (URL, error) in

                let asset = AVURLAsset(url: NSURL(fileURLWithPath: (URL?.absoluteString)!) as URL, options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                let cgImage = try? imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil);
                // !! check the error before proceeding
                let uiImage = UIImage(cgImage: cgImage!)
                let base64Image = UIImageJPEGRepresentation(uiImage, 0.85)!
                    .base64EncodedString(options: .lineLength64Characters)

                let returnValues = [URL?.absoluteString, base64Image];

                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: returnValues as [Any]);
                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
                if(cameraManager.cameraOutputMode == .videoWithMic) {
                    cameraManager.cameraOutputMode = CameraOutputMode.stillImage;
                }
            }
        }

    }

    @objc(recordingTimer:)
    func recordingTimer(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Camera session isn't started");
        if(!cameraStarted) {
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        } else {
            let duration = cameraManager.recordedDuration.seconds;
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: duration);
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        }
    }


}
