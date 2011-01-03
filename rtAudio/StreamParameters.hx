package rtAudio;

/**
 * The structure for specifying input or ouput stream parameters.
 */
typedef StreamParameters =
{
	/**
	 * Device index (0 to getDeviceCount() - 1).
	 */
	var deviceId:Int;
	
	/**
	 * Number of channels.
	 */
	var nChannels:Int;
	
	/**
	 * First channel index on device (default = 0).
	 */
	var firstChannel:Int;
}