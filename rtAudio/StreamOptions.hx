package rtAudio;

typedef StreamOptions =
{
	var flags:Array<RtAudioStreamFlags>;
	var numberOfBuffers:Int;
	var streamName:String;
	var priority:Int;
}