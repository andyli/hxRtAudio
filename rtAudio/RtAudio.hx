package rtAudio;

import cpp.Lib;
import cpp.vm.Thread;
import cpp.vm.Lock;
import rtAudio.Api;
import rtAudio.RtAudioFormat;
import rtAudio.RtAudioStreamFlags;

#if cpp @:require(HXCPP_MULTI_THREADED) #end
class RtAudio 
{	
	/**
	 * A static function to determine the available compiled audio APIs.
	 * 
	 * @return Array of compiled Api.
	 */
	static public function getCompiledApi():Array<Api> {
		var apis = [];
		#if neko
			var ary:Array<Int> = neko.Lib.nekoToHaxe(_RtAudio_getCompiledApi());
			for (i in ary) {
				apis.push(Type.createEnumIndex(Api, i));
			}
		#else
			for (i in _RtAudio_getCompiledApi()) {
				apis.push(Type.createEnumIndex(Api, i));
			}
		#end
		return apis;
	}
	
	/**
	 * The class constructor.
	 * 
	 * @param	?api	The compiled Api to be used. If no API argument is specified and multiple API support has been
	 * 					compiled, the default order of use is JACK, ALSA, OSS (Linux
	 * 					systems) and ASIO, DS (Windows systems).
	 */
	public function new(?api:Api):Void {
		handle = _RtAudio_new(Type.enumIndex(api == null ? UNSPECIFIED : api));
	}
	
	/**
	 * @return The audio API specifier for the current instance of RtAudio.
	 */
	public function getCurrentApi():Api {
		return Type.createEnumIndex(Api, _RtAudio_getCurrentApi(handle));
	}
	
	/**
	 * A public function that queries for the number of audio devices available.
	 * 
	 * <p>This function performs a system query of available devices each time it
	 * is called, thus supporting devices connected after instantiation. If
	 * a system error occurs during processing, a warning will be issued.</p>
	 * 
	 * @return The number of audio devices available.
	 */
	public function getDeviceCount():Int {
		return _RtAudio_getDeviceCount(handle);
	}
	
	/**
	 * Any device integer between 0 and getDeviceCount() - 1 is valid.
	 * If an invalid argument is provided, an RtError (type = INVALID_USE)
	 * will be printed to the console. If a device is busy or otherwise 
	 * unavailable, the DeviceInfo member "probed" will have a value of "false" 
	 * and all other members are null. If the specified device is the
	 * current default input or output device, the corresponding
	 * "isDefault" member will have a value of "true".
	 * 
	 * @param	device	Any device integer between 0 and getDeviceCount() - 1.
	 * @return	DeviceInfo for a specified device number.
	 */
	public function getDeviceInfo(device:Int):DeviceInfo {
		var info:Dynamic = _RtAudio_getDeviceInfo(handle, device);
		
		var nativeFormatsBitMask:Int = info.nativeFormats;
		var nativeFormats = [];
		if ( nativeFormatsBitMask & RtAudioFormatValue.RTAUDIO_SINT8 > 0 )
			nativeFormats.push(RTAUDIO_SINT8);
		if ( nativeFormatsBitMask & RtAudioFormatValue.RTAUDIO_SINT16 > 0 )
			nativeFormats.push(RTAUDIO_SINT16);
		if ( nativeFormatsBitMask & RtAudioFormatValue.RTAUDIO_SINT24 > 0 )
			nativeFormats.push(RTAUDIO_SINT24);
		if ( nativeFormatsBitMask & RtAudioFormatValue.RTAUDIO_SINT32 > 0 )
			nativeFormats.push(RTAUDIO_SINT32);
		if ( nativeFormatsBitMask & RtAudioFormatValue.RTAUDIO_FLOAT32 > 0 )
			nativeFormats.push(RTAUDIO_FLOAT32);
		if ( nativeFormatsBitMask & RtAudioFormatValue.RTAUDIO_FLOAT64 > 0 )
			nativeFormats.push(RTAUDIO_FLOAT64);
		
		info.nativeFormats = nativeFormats;
		
		#if neko
		info.sampleRates = neko.Lib.nekoToHaxe(info.sampleRates);
		#end
		return info;
	}
	
	/**
	 * If the underlying audio API does not provide a "default
	 * device", or if no devices are available, the return value will be
	 * 0.  Note that this is a valid device identifier and it is the
	 * client's responsibility to verify that a device is available
	 * before attempting to open a stream.
	 * 
	 * @return The index of the default output device.
	 */
	public function getDefaultOutputDevice():Int {
		return _RtAudio_getDefaultOutputDevice(handle);
	}
	
	/**
	 * If the underlying audio API does not provide a "default
	 * device", or if no devices are available, the return value will be
	 * 0.  Note that this is a valid device identifier and it is the
	 * client's responsibility to verify that a device is available
	 * before attempting to open a stream.
	 * 
	 * @return The index of the default input device.
	 */
	public function getDefaultInputDevice():Int {
		return _RtAudio_getDefaultInputDevice(handle);
	}
	
	/**
	 * A function that closes a stream and frees any associated stream memory.
	 * 
	 * <p>If a stream is not open, this function issues a warning and
	 * returns (no exception is thrown).</p>
	 */
	public function closeStream():Void {
		_RtAudio_closeStream(handle);
	}
	
	/**
	 * A function that starts a stream.
	 * 
	 * <p>An RtError (type = SYSTEM_ERROR) is printed to console if an error 
	 * occurs during processing. An RtError (type = INVALID_USE) is printed 
	 * to console if a stream is not open. A warning is issued if the stream 
	 * is already running.</p>
	 */
	public function startStream():Void {
		_RtAudio_startStream(handle);
	}
	
	/**
	 * Stop a stream, allowing any samples remaining in the output queue to be played.
	 * 
	 * <p>An RtError (type = SYSTEM_ERROR) is printed to console if an error occurs
	 * during processing.  An RtError (type = INVALID_USE) is printed to console 
	 * if a stream is not open.  A warning is issued if the stream is already
	 * stopped.</p>
	 */
	public function stopStream():Void {
		_RtAudio_stopStream(handle);
	}
	
	/**
	 * Stop a stream, discarding any samples remaining in the input/output queue.
	 * 
	 * <p>An RtError (type = SYSTEM_ERROR) is printed to console if an error occurs
	 * during processing.  An RtError (type = INVALID_USE) is printed to console if a
	 * stream is not open.  A warning is issued if the stream is already
	 * stopped.</p>
	 */
	public function abortStream():Void {
		_RtAudio_abortStream(handle);
	}
	
	/**
	 * @return true if a stream is open and false if not.
	 */
	public function isStreamOpen():Bool {
		return _RtAudio_isStreamOpen(handle);
	}
	
	/**
	 * @return true if the stream is running and false if it is stopped or not open.
	 */
	public function isStreamRunning():Bool {
		return _RtAudio_isStreamRunning(handle);
	}
	
	/**
	 * If a stream is not open, an RtError (type = INVALID_USE) will be printed to console.
	 * 
	 * @return The number of elapsed seconds since the stream was started.
	 */
	public function getStreamTime():Float {
		return _RtAudio_getStreamTime(handle);
	}
	
	/**
	 * The stream latency refers to delay in audio input and/or output
	 * caused by internal buffering by the audio system and/or hardware.
	 * For duplex streams, the returned value will represent the sum of
	 * the input and output latencies. If a stream is not open, an
	 * RtError (type = INVALID_USE) will be printed to console. If the 
	 * API does not report latency, the return value will be zero.
	 * 
	 * @return The internal stream latency in sample frames.
	 */
	public function getStreamLatency():Int {
		return _RtAudio_getStreamLatency(handle);
	}
	
	/**
	 * On some systems, the sample rate used may be slightly different
	 * than that specified in the stream parameters.  If a stream is not
	 * open, an RtError (type = INVALID_USE) will be printed to console.
	 * 
	 * @return Actual sample rate in use by the stream.
	 */
	public function getStreamSampleRate():Int {
		return _RtAudio_getStreamSampleRate(handle);
	}
	
	/**
	 * Specify whether warning messages should be printed to stderr.
	 * 
	 * @param	value true if warning messages should be printed to stderr.
	 */
	public function showWarnings(value:Bool = true):Void {
		_RtAudio_showWarnings(handle, value);
	}
	
	/**
	 * A public function for opening a stream with the specified parameters.
	 * 
	 * <p>An RtError (type = SYSTEM_ERROR) is printed to console if a stream 
	 * cannot be opened with the specified parameters or an error occurs 
	 * during processing.  An RtError (type = INVALID_USE) is printed to 
	 * console if any invalid device ID or channel number parameters are 
	 * specified.</p>
	 * 
	 * @param	outputParameters	Specifies output stream parameters to use when opening a stream,
	 * 								including a device ID, number of channels,
	 * 								and starting channel number.  For input-only streams, this
	 * 								argument should be null.  The device ID is an index value between
	 * 								0 and getDeviceCount() - 1.
	 * @param	inputParameters		Specifies input stream parameters to use when opening a stream,
	 * 								including a device ID, number of channels,
	 * 								and starting channel number.  For output-only streams, this
	 * 								argument should be null.  The device ID is an index value between
	 * 								0 and getDeviceCount() - 1.
	 * @param	format				An RtAudioFormat specifying the desired sample data format.
	 * @param	sampleRate			The desired sample rate (sample frames per second).
	 * @param	bufferFrames		Indicating the desired internal buffer size in sample frames.
	 * 								The actual value used by the device is assigned to the property 
	 * 								of the same name. A value of zero can be specified, in which case 
	 * 								the lowest allowable value is determined.
	 * @param	streamCallback		A client-defined function that will be invoked when input data is 
	 * 								available and/or output data is needed.
	 * @param	?userData			An optional pointer to data that can be accessed from the property
	 * 								of the same name.
	 * @param	?options			An optional pointer to a StreamOptions containing various global 
	 * 								stream options, including a Array of RtAudioStreamFlags and a 
	 * 								suggested number of stream buffers that can be used to control 
	 * 								stream latency. More buffers typically result in more robust 
	 * 								performance, though at a cost of greater latency.  If a value of 
	 * 								zero is specified, a system-specific median value is chosen. If the
	 * 								RTAUDIO_MINIMIZE_LATENCY flag bit is set, the lowest allowable value 
	 * 								is used. The actual value used is assigned to the property of the 
	 * 								same name. The parameter is API dependent.
	 */
	public function openStream(
		outputParameters:Null<StreamParameters>,
		inputParameters:Null<StreamParameters>,
		format:RtAudioFormat,
		sampleRate:Int,
		bufferFrames:Int,
		streamCallback:RtAudioCallback,
		?userData:Dynamic = null,
		?options:Null<StreamOptions> = null
	):Void {
		this.outputParameters = outputParameters;
		this.inputParameters = inputParameters;
		this.format = format;
		this.sampleRate = sampleRate;
		this.bufferFrames = bufferFrames;
		this.streamCallback = streamCallback;
		this.userData = userData;
		this.options = options;
		
		var optionsValue:Dynamic = options == null ? null : Reflect.copy(options);
		if (options != null) {
			var flagsValue = 0;
			for (flag in options.flags) {
				flagsValue = switch(flag) {
					case RTAUDIO_NONINTERLEAVED:	flagsValue | RtAudioStreamFlagsValue.RTAUDIO_NONINTERLEAVED;
					case RTAUDIO_MINIMIZE_LATENCY:	flagsValue | RtAudioStreamFlagsValue.RTAUDIO_MINIMIZE_LATENCY;
					case RTAUDIO_HOG_DEVICE:		flagsValue | RtAudioStreamFlagsValue.RTAUDIO_HOG_DEVICE;
					case RTAUDIO_SCHEDULE_REALTIME:	flagsValue | RtAudioStreamFlagsValue.RTAUDIO_SCHEDULE_REALTIME;
				}
			}
			optionsValue.flags = flagsValue;
		}
		
		formatValue = switch (format) {
			case RTAUDIO_SINT8: RtAudioFormatValue.RTAUDIO_SINT8;
			case RTAUDIO_SINT16: RtAudioFormatValue.RTAUDIO_SINT16;
			//case RTAUDIO_SINT24: RtAudioFormatValue.RTAUDIO_SINT24;
			case RTAUDIO_SINT32: RtAudioFormatValue.RTAUDIO_SINT32;
			case RTAUDIO_FLOAT32: RtAudioFormatValue.RTAUDIO_FLOAT32;
			case RTAUDIO_FLOAT64: RtAudioFormatValue.RTAUDIO_FLOAT64;
			default: throw "unsupported format";
		}
		
		_RtAudio_openStream( 
			handle,
			this,
			{
				outputParameters:outputParameters,
				inputParameters:inputParameters,
				format:formatValue,
				sampleRate:sampleRate,
				bufferFrames:bufferFrames,
				userData:userData,
				options:optionsValue
			}
		);
		
		if (outputParameters != null) {
			switch(format) {
				case	RTAUDIO_SINT8,
						RTAUDIO_SINT16,
						//RTAUDIO_SINT24,
						RTAUDIO_SINT32: outputBuffer = new Array<Int>();
						
				case	RTAUDIO_FLOAT32,
						RTAUDIO_FLOAT64: outputBuffer = new Array<Float>();
						
				default: throw "unknown RtAudioFormat";
			}
			
			for (i in 0...this.bufferFrames * outputParameters.nChannels)
				outputBuffer.push(0);
			
		} else {
			outputBuffer = null;
		}
		
		if (inputParameters != null) {
			switch(format) {
				case	RTAUDIO_SINT8,
						RTAUDIO_SINT16,
						//RTAUDIO_SINT24,
						RTAUDIO_SINT32: inputBuffer = new Array<Int>();
						
				case	RTAUDIO_FLOAT32,
						RTAUDIO_FLOAT64: inputBuffer = new Array<Float>();
						
				default: throw "unsupported RtAudioFormat";
			}
			
			for (i in 0...this.bufferFrames * inputParameters.nChannels)
				inputBuffer.push(0);
			
		} else {
			inputBuffer = null;
		}
		
		if (options != null) {
			options.numberOfBuffers = optionsValue.numberOfBuffers;
		}
		
		if (thread != null) {
			thread.sendMessage(false); //let the loop breaks.
			thread = null;
		}
		thread = Thread.create(threadCallback);
		lock = new Lock();
	}
	
	/**
	 * This is the handle to the real RtAudio object in ndll. Don't use it unless you know what it means.
	 */
	public var handle(default, null):Dynamic;
	
	/**
	 * The streamCallback you provided when calling openStream() is stored here.
	 */
	public var streamCallback(default, null):RtAudioCallback;
	
	/**
	 * The outputParameters you provided when calling openStream() is stored here.
	 */
	public var outputParameters(default, null):Null<StreamParameters>;
	
	/**
	 * The inputParameters you provided when calling openStream() is stored here.
	 */
	public var inputParameters(default, null):Null<StreamParameters>;
	
	/**
	 * The format you provided when calling openStream() is stored here.
	 */
	public var format(default, null):RtAudioFormat; var formatValue(default, null):Int;
	
	/**
	 * The sampleRate you provided when calling openStream() is stored here.
	 */
	public var sampleRate(default, null):Int;
	
	/**
	 * The bufferFrames you provided when calling openStream() is stored here.
	 */
	public var bufferFrames(default, null):Int;
	
	/**
	 * The userData you provided when calling openStream() is stored here.
	 */
	public var userData(default, null):Dynamic;
	
	/**
	 * The options you provided when calling openStream() is stored here.
	 */
	public var options(default, null):Null<StreamOptions>;
	
	/**
	 * Status of the stream.
	 */
	public var status(default, null):Int;
	
	/**
	 * Buffer that needs to be filled by streamCallback when playing a output stream.
	 * You should cast it to Array<Int> or Array<Float> depending on the format you specified.
	 */
	public var outputBuffer(default, null):Dynamic;
	
	/**
	 * Buffer for storing the input stream data, that used by streamCallback.
	 * You should cast it to Array<Int> or Array<Float> depending on the format you specified.
	 */
	public var inputBuffer(default, null):Dynamic;
	
	
	/**
	 * The Thread created to call streamCallback when needed.
	 */
	var thread:Thread;
	
	/**
	 * It is locked when streamCallback is not called yet.
	 */
	var lock:Lock;
	
	/**
	 * The reture value of streamCallback is stored here temporary.
	 */
	var lastStreamCallBackResult:Dynamic; //Int
	
	/**
	 * Store a dynamic variable of true for threadCallbackRun, to avoid allocating new object.
	 */
	static var TRUE:Dynamic = true;
	
	/**
	 * Function for the thread.
	 */
	function threadCallback():Void {
		while (Thread.readMessage(true)) {
			lastStreamCallBackResult = streamCallback(this);
			lock.release();
		}
	}
	
	/**
	 * Called by the ndll.
	 * @return The reture value of streamCallback.
	 */
	function threadCallbackRun():Dynamic {
		thread.sendMessage(TRUE);
		lock.wait();
		return lastStreamCallBackResult;
	}
	
	static var _RtAudio_getCompiledApi:Void->Array<Dynamic> = Lib.load("hxRtAudio", "_RtAudio_getCompiledApi", 0);
	static var _RtAudio_new = Lib.load("hxRtAudio", "_RtAudio_new", 1);
	static var _RtAudio_getCurrentApi = Lib.load("hxRtAudio", "_RtAudio_getCurrentApi", 1);
	static var _RtAudio_getDeviceCount = Lib.load("hxRtAudio", "_RtAudio_getDeviceCount", 1);
	static var _RtAudio_getDeviceInfo = Lib.load("hxRtAudio", "_RtAudio_getDeviceInfo", 2);
	static var _RtAudio_getDefaultOutputDevice = Lib.load("hxRtAudio", "_RtAudio_getDefaultOutputDevice", 1);
	static var _RtAudio_getDefaultInputDevice = Lib.load("hxRtAudio", "_RtAudio_getDefaultInputDevice", 1);
	static var _RtAudio_closeStream = Lib.load("hxRtAudio", "_RtAudio_closeStream", 1);
	static var _RtAudio_startStream = Lib.load("hxRtAudio", "_RtAudio_startStream", 1);
	static var _RtAudio_stopStream = Lib.load("hxRtAudio", "_RtAudio_stopStream", 1);
	static var _RtAudio_abortStream = Lib.load("hxRtAudio", "_RtAudio_abortStream", 1);
	static var _RtAudio_isStreamOpen = Lib.load("hxRtAudio", "_RtAudio_isStreamOpen", 1);
	static var _RtAudio_isStreamRunning = Lib.load("hxRtAudio", "_RtAudio_isStreamRunning", 1);
	static var _RtAudio_getStreamTime = Lib.load("hxRtAudio", "_RtAudio_getStreamTime", 1);
	static var _RtAudio_getStreamLatency = Lib.load("hxRtAudio", "_RtAudio_getStreamLatency", 1);
	static var _RtAudio_getStreamSampleRate = Lib.load("hxRtAudio", "_RtAudio_getStreamSampleRate", 1);
	static var _RtAudio_showWarnings = Lib.load("hxRtAudio", "_RtAudio_showWarnings", 2);
	static var _RtAudio_openStream = Lib.load("hxRtAudio", "_RtAudio_openStream", 3);
}
