var exec = require('cordova/exec');

var PLUGIN_NAME = "LastCam";

var LastCam = function() {};

LastCam.startCamera = function(options, onSuccess, onError) {
	options = options || {};
	options.x = options.x || 0;
	options.y = options.y || 0;
	options.width = options.width || window.screen.width;
	options.height = options.height || window.screen.height;
	options.camera = options.camera || ".Back";

	exec(onSuccess, onError, PLUGIN_NAME, "startCamera", [options.x, options.y, options.width, options.height, options.camera]);
};

LastCam.stopCamera = function(onSuccess, onError) {
	exec(onSuccess, onError, PLUGIN_NAME, "stopCamera", []);
};

LastCam.switchCamera = function(onSuccess, onError) {
	exec(onSuccess, onError, PLUGIN_NAME, "switchCamera", []);
};

LastCam.takePicture = function(onSuccess, onError) {
	exec(onSuccess, onError, PLUGIN_NAME, "takePicture", []);
};

LastCam.startVideoCapture = function(onSuccess, onError) {
	exec(onSuccess, onError, PLUGIN_NAME, "startVideoCapture", []);
};

LastCam.stopVideoCapture = function(onSuccess, onError) {
	exec(onSuccess, onError, PLUGIN_NAME, "stopVideoCapture", []);
};

LastCam.recordingTimer = function(onSuccess, onError) {
	exec(onSuccess, onError, PLUGIN_NAME, "recordingTimer", []);
};


module.exports = LastCam;
