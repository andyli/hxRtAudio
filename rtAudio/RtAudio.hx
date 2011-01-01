package rtAudio;

import cpp.Lib;
import cpp.vm.Gc;
import rtAudio.Api;

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
		return _RtAudio_getDeviceInfo(handle, device);
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
		format:Int /*RtAudioFormat*/,
		sampleRate:Int,
		bufferFrames:Int,
		?userData:Dynamic = null,
		?options:StreamOptions = null
	):Void {
		if (outputParameters != null) {
			outputBuffer = switch(format) {
				case	RtAudioFormat.RTAUDIO_SINT8,
						RtAudioFormat.RTAUDIO_SINT16,
						RtAudioFormat.RTAUDIO_SINT24,
						RtAudioFormat.RTAUDIO_SINT32: cast new Array<Int>();
						
				case	RtAudioFormat.RTAUDIO_FLOAT32,
						RtAudioFormat.RTAUDIO_FLOAT64: cast new Array<Float>();
						
				default: throw "unknown RtAudioFormat";
			}
			
			for (i in 0...bufferFrames * outputParameters.nChannels)
				outputBuffer.push(0);
			
		} else {
			outputBuffer = null;
		}
		
		if (inputParameters != null) {
			inputBuffer = switch(format) {
				case	RtAudioFormat.RTAUDIO_SINT8,
						RtAudioFormat.RTAUDIO_SINT16,
						RtAudioFormat.RTAUDIO_SINT24,
						RtAudioFormat.RTAUDIO_SINT32: cast new Array<Int>();
						
				case	RtAudioFormat.RTAUDIO_FLOAT32,
						RtAudioFormat.RTAUDIO_FLOAT64: cast new Array<Float>();
						
				default: throw "unknown RtAudioFormat";
			}
			
			for (i in 0...bufferFrames * inputParameters.nChannels)
				inputBuffer.push(0);
			
		} else {
			inputBuffer = null;
		}
		
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
	}
	
	public var handle(default, null):Dynamic;
	public var streamCallback:RtAudioCallback;
	var outputBuffer:Dynamic;
	var inputBuffer:Dynamic;
	
	public function callStreamCallback( args:{
		outputBuffer:Dynamic,
		inputBuffer:Dynamic,
		nFrames:Int,
		streamTime:Float,
		status:Int,
		userData:Dynamic
	}):Int {
		return streamCallback(args.outputBuffer, args.inputBuffer, args.nFrames, args.streamTime, args.status, args.userData);
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