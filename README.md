# Last Cam

> Last Cam is a Cordova Plugin that brings to the table what other camera plugins lack: Video Capture capabilities 
within a custom Camera view.

![LastCam](assets/last-cam-logo.png)

## Table of Contents
- [Install](#install)
- [Required Setup](#required-setup)
    - [import](#import)
- [Methods](#methods)
    - [Start Camera](###start-camera)
    - [Stop Camera](#stop-camera)
- [Badge](#badge)
- [Example Readmes](#example-readmes)
- [Related Efforts](#related-efforts)
- [Maintainers](#maintainers)
- [Contribute](#contribute)
- [License](#license)

# Cordova Plugin Last Cam
<a href="https://badge.fury.io/js/cordova-plugin-camera-preview" target="_blank"><img height="21" style='border:0px;height:21px;' border='0' src="https://badge.fury.io/js/cordova-plugin-camera-preview.svg" alt="NPM Version"></a>
<a href='https://www.npmjs.org/package/cordova-plugin-camera-preview' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://img.shields.io/npm/dt/cordova-plugin-camera-preview.svg?label=NPM+Downloads' border='0' alt='NPM Downloads' /></a>

Cordova plugin that allows camera interaction from Javascript and HTML

**Releases are being kept up to date when appropriate. However, this plugin is under constant development. As such it is recommended to use master to always have the latest fixes & features.**

**PR's are greatly appreciated. Maintainer(s) wanted.**

# Features

<ul>
  <li>Start a camera preview from HTML code.</li>
  <li>Maintain HTML interactivity.</li>
  <li>Set a custom position for the camera preview box.</li>
  <li>Set a custom size for the preview box.</li>
</ul>

# Installation

Use any one of the installation methods listed below depending on which framework you use.

To install the master version with latest fixes and features

```
cordova plugin add https://github.com/bengejd/cordova-plugin-last-cam.git

ionic cordova plugin add https://github.com/bengejd/cordova-plugin-last-cam.git
```

And Ionic-Native inclusion.

```
npm install @ionic-native/LastCam
```

Import `LastCam` into your constructor.
 ```
import {LastCam} from '@ionic-native/last-cam';
...
 
constructor(private lastCam: LastCam) {
   }
...
 ```

### iOS Quirks

It is not possible to test in a simulator. You must use a real device for all testing.

#### config.xml
If you are developing for iOS 10+ you must also add the following to your config.xml

```xml
<config-file platform="ios" target="*-Info.plist" parent="NSCameraUsageDescription" overwrite="true">
  <string>Allow the app to use your camera</string>
</config-file>
```

```xml
<config-file platform="ios" target="*-Info.plist" parent="NSPhotoLibraryUsageDescription" overwrite="true">
  <string>Allow the app to save media to your camera roll</string>
</config-file>
```

```xml
<config-file platform="ios" target="*-Info.plist" parent="NSMicrophoneUsageDescription" overwrite="true">
  <string>Allow access to your microphone to record video with audio</string>
</config-file>
```

#### app.scss

Be sure to include the following in your app.scss, or else the camera-preview will not display.

```css
html, body, .ion-app, .ion-content {
  background-color: transparent !important;
}
```


# Usage

#### startCamera(options, [successCallback, errorCallback])

<info>Starts the camera preview instance.</info><br/>

<strong>Options:</strong>
All options stated are optional and will default to values here

* `x` - Defaults to 0
* `y` - Defaults to 0
* `width` - Defaults to window.screen.width
* `height` - Defaults to window.screen.height
* `camera` - Defaults to back camera

```javascript
let options = {
  x: 0,
  y: 0,
  width: window.screen.width,
  height: window.screen.height,
  camera: ".Back",
};

CameraPreview.startCamera(options)
.then(() => { })
.catch(error => console.log(error));
```

#### stopCamera([successCallback, errorCallback])

<info>Stops the camera preview instance. </info>

```javascript
CameraPreview.stopCamera();
```

#### switchCamera([successCallback, errorCallback])

<info>
Switches between the front and back camera, if they are available. 

Returns a string containing the camera direction ('front' or 'back')
</info>

```javascript
CameraPreview.switchCamera()
.then(direction => {
    console.log('New camera direction: ', direction)
})
.catch(err => { 
    console.log(err);
});
```



### takePicture([successCallback, errorCallback])

<info>Takes a picture</info>

```javascript
CameraPreview.takePicture().then(base64PictureData) {
  /*
    base64PictureData is base64 encoded jpeg image. Use this data to store to a file or upload.
    Its up to the you to figure out the best way to save it to disk or whatever for your application.
  */
};
```

<info>
Here is and example of how you use the `base64PictureData`
</info>
 
```javascript
  imageSrcData = 'data:image/jpeg;base64,' + base64PictureData;
```

Now it can be put into a regular `<img src="imageSrcData">` tag.

<info> 
If you run into issues with the imageSrcData being caught by Angular or Ionic as an unsafeXss, you can do the 
following the fix the error:
</info><br><br>


In your `component.ts` file
```typescript

import {DomSanitizer} from '@angular/platform-browser';
...

constructor(private DomSanitizer: DomSanitizer){
...
}
```

HTML

```html
<img [src]="DomSanitizer.bypassSecurityTrustResourceUrl(imageSrcData)">
```

#### switchFlash([successCallback, errorCallback])

Switches the flash mode between `0 (off)`, `1 (on)` and `2(auto)`.

Returns an int containing the flash mode: `0, 1, or 2`

```javascript
CameraPreview.switchFlash()
.then(mode => {
    console.log('New flash mode: ', mode)
})
.catch(err => { 
    console.log(err);
});
```

# Credits

Created by Jordan Benge [@bengejd](https://github.com/bengejd)


