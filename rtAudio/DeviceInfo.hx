package rtAudio;

typedef DeviceInfo = 
{
	var probed:Bool;
	var name:String;
	var outputChannels:Int;
	var inputChannels:Int;
	var duplexChannels:Int;
	var isDefaultOutput:Bool;
	var isDefaultInput:Bool;
	var sampleRates:Array<Int>;
	var nativeFormats:Array<RtAudioFormat>;
}