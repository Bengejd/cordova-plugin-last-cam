import { Injectable } from '@angular/core';
import { Cordova, IonicNativePlugin, Plugin } from '@ionic-native/core';

/*
 @Name: @ionic-native/LastCam
 @Description: This is the LastCam's ionic native implementation. Kept in this folder for simplicity sake.
 */

export interface CameraPreviewOptions {
  /** The left edge in pixels, default 0 */
  x?: number;

  /** The top edge in pixels, default 0 */
  y?: number;

  /** The width in pixels, default window.screen.width */
  width?: number;

  /** The height in pixels, default window.screen.height */
  height?: number;

  /** Choose the camera to use 'front' or 'rear', default 'front' */
  camera?: string;

  /** Preview box to the back of the webview (true => back, false => front) , default false */
  toBack?: boolean;
}

@Plugin({
  pluginName: 'LastCam',
  plugin: 'cordova-plugin-last-cam',
  pluginRef: 'LastCam',
  repo:
    'https://github.com/bengejd/cordova-plugin-last-cam',
  platforms: ['iOS']
})
@Injectable()
export class LastCam extends IonicNativePlugin {
  /**
   * Starts the camera preview instance.
   * @param {CameraPreviewOptions} options
   * @return {Promise<any>}
   */
  @Cordova({
    successIndex: 1,
    errorIndex: 2
  })
  startCamera(options: CameraPreviewOptions): Promise<any> {
    return;
  }

  /**
   * Stops the camera preview instance. (iOS)
   * @return {Promise<any>}
   */
  @Cordova()
  stopCamera(): Promise<any> {
    return;
  }

  /**
   * Switch from the rear camera and front camera, if available.
   * @return {Promise<any>}
   */
  @Cordova()
  switchCamera(): Promise<any> {
    return;
  }

  /**
   * Take the picture (base64)
   * @return {Promise<any>}
   */
  @Cordova({
    successIndex: 0,
    errorIndex: 1
  })
  takePicture(): Promise<any> {
    return;
  }

  /**
   * Start the video capture
   * @return {Promise<any>}
   */
  @Cordova()
  startVideoCapture(): Promise<any> {
    return;
  }

  /**
   * Stops the video capture
   * @return {Promise<any>}
   */
  @Cordova({
    successIndex: 1,
    errorIndex: 2
  })
  stopVideoCapture(): Promise<any> {
    return;
  }
}
