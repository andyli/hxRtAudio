package rtAudio;

class RtAudioStreamStatus 
{
	inline static public var RTAUDIO_INPUT_OVERFLOW = 0x1;    // Input data was discarded because of an overflow condition at the driver.
	inline static public var RTAUDIO_OUTPUT_UNDERFLOW = 0x2;  // The output buffer ran low, likely causing a gap in the output sound.
}