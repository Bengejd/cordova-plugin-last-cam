// MARK: Cordova Exposures.

import AVFoundation
import CoreImage
import MediaPlayer
import UIKit
import CameraManager

let cameraManager = CameraManager()
var parentView: UIView? = nil;
var view = UIView(frame: parentView!.bounds);

// MARK: CAMERA PREVIEW METHODS BELOW.
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
        view = UIView(frame: parentView!.bounds)
        parentView!.addSubview(view)
        parentView!.isUserInteractionEnabled = true

        cameraManager.writeFilesToPhoneLibrary = false
        cameraManager.addPreviewLayerToView(parentView!)

        // Add this in there, incase the camera session has already been created.
        cameraManager.resumeCaptureSession();

        webView.superview?.bringSubview(toFront: webView)

        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK);

        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }

    @objc(stopCamera:)
    func stopCamera(command: CDVInvokedUrlCommand) {
        cameraManager.stopCaptureSession();

        // Remove the view, so that we don't see the last frame of the stream.
        parentView?.removeFromSuperview();
        parentView = nil;

        var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR);
        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK);

        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }

    @objc(takePicture:)
    func takePicture(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR);

        cameraManager.capturePictureWithCompletion({ (image, error) -> Void in
            let base64String = UIImagePNGRepresentation(image!)!.base64EncodedString(options: .lineLength64Characters)
        })

        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "This is a test mother fuckers!");
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }

   @objc(switchCamera:)
    func switchCamera(command: CDVInvokedUrlCommand!) {
    print("Switching Cameras")
    cameraManager.cameraDevice = cameraManager.cameraDevice ==
        CameraDevice.front ? CameraDevice.back : CameraDevice.front
    }

    @objc(startVideoCapture:)
    func startVideoCapture(command: CDVInvokedUrlCommand) {

        var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR);
        cameraManager.startRecordingVideo()

        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK);
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
    }

    @objc(stopVideoCapture:)
    func stopVideoCapture(command: CDVInvokedUrlCommand) {

    }


}
