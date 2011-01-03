package rtAudio;

/**
 * The public device information structure for returning queried values.
 */
typedef DeviceInfo = 
{
	/**
	 * true if the device capabilities were successfully probed.
	 */
	var probed:Bool;
	
	/**
	 * Device identifier.
	 */
	var name:String;
	
	/**
	 * Maximum output channels supported by device.
	 */
	var outputChannels:Int;
	
	/**
	 * Maximum input channels supported by device.
	 */
	var inputChannels:Int;
	
	/**
	 * Maximum simultaneous input/output channels supported by device.
	 */
	var duplexChannels:Int;
	
	/**
	 * true if this is the default output device.
	 */
	var isDefaultOutput:Bool;
	
	/**
	 * true if this is the default input device.
	 */
	var isDefaultInput:Bool;
	
	/**
	 * Supported sample rates (queried from list of standard rates).
	 */
	var sampleRates:Array<Int>;
	
	/**
	 * Array of supported data formats.
	 */
	var nativeFormats:Array<RtAudioFormat>;
}