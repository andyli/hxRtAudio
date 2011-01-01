package rtAudio;

typedef StreamOptions =
{
	var flags:Int /* RtAudioStreamFlags */;
	var numberOfBuffers:Int;
	var streamName:String;
	var priority:Int;
}