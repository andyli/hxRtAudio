package rtAudio;

import cpp.Lib;
import cpp.vm.Gc;
import rtAudio.Api;
import rtAudio.RtAudioFormat;

class RtAudio 
{	
	static public function getCompiledApi():Array<Api> {
		var apis = [];
		for (i in _RtAudio_getCompiledApi()) {
			apis.push(Type.createEnumIndex(Api, i));
		}
		return apis;
	}
	
	public function new(?api:Api):Void {
		handle = _RtAudio_new(Type.enumIndex(api == null ? UNSPECIFIED : api));
	}
	
	public function getCurrentApi():Api {
		return Type.createEnumIndex(Api, _RtAudio_getCurrentApi(handle));
	}
	
	public function getDeviceCount():Int {
		return _RtAudio_getDeviceCount(handle);
	}
	
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
		return info;
	}
	
	public function getDefaultOutputDevice():Int {
		return _RtAudio_getDefaultOutputDevice(handle);
	}
	
	public function getDefaultInputDevice():Int {
		return _RtAudio_getDefaultInputDevice(handle);
	}
	
	public function closeStream():Void {
		_RtAudio_closeStream(handle);
	}
	
	public function startStream():Void {
		_RtAudio_startStream(handle);
	}
	
	public function stopStream():Void {
		_RtAudio_stopStream(handle);
	}
	
	public function abortStream():Void {
		_RtAudio_abortStream(handle);
	}
	
	public function isStreamOpen():Bool {
		return _RtAudio_isStreamOpen(handle);
	}
	
	public function isStreamRunning():Bool {
		return _RtAudio_isStreamRunning(handle);
	}
	
	public function getStreamTime():Float {
		return _RtAudio_getStreamTime(handle);
	}
	
	public function getStreamLatency():Int {
		return _RtAudio_getStreamLatency(handle);
	}
	
	public function getStreamSampleRate():Int {
		return _RtAudio_getStreamSampleRate(handle);
	}
	
	public function showWarnings(value:Bool = true):Void {
		_RtAudio_showWarnings(handle, value);
	}
		
	public function openStream(
		outputParameters:Null<StreamParameters>,
		inputParameters:Null<StreamParameters>,
		format:RtAudioFormat,
		sampleRate:Int,
		bufferFrames:Int,
		streamCallback:RtAudioCallback,
		?userData:Dynamic = null,
		?options:StreamOptions = null
	):Void {
		this.outputParameters = outputParameters;
		this.inputParameters = inputParameters;
		this.format = format;
		this.sampleRate = sampleRate;
		this.bufferFrames = bufferFrames;
		this.streamCallback = streamCallback;
		this.userData = userData;
		this.options = options;
		
		_RtAudio_openStream( 
			handle,
			this,
			{
				outputParameters:outputParameters,
				inputParameters:inputParameters,
				format:format,
				sampleRate:sampleRate,
				bufferFrames:bufferFrames,
				userData:userData,
				options:options
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
	}
	
	public var handle(default, null):Dynamic;
	public var streamCallback(default, null):RtAudioCallback;
	public var outputParameters(default, null):Null<StreamParameters>;
	public var inputParameters(default, null):Null<StreamParameters>;
	public var format(default, null):RtAudioFormat;
	public var sampleRate(default, null):Int;
	public var bufferFrames(default, null):Int;
	public var userData(default, null):Dynamic;
	public var options(default, null):Null<StreamOptions>;
	public var status(default, null):Int;
	public var outputBuffer(default, null):Dynamic;
	public var inputBuffer(default, null):Dynamic;
	
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