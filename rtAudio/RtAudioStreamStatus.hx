package rtAudio;

/**
 * RtAudio stream status (over- or underflow) flags.
 * 
 * <p>Notification of a stream over- or underflow is indicated by a
 * non-zero stream status argument in the RtAudioCallback function.
 * The stream status can be one of the following two options,
 * depending on whether the stream is open for output and/or input.</p>
 */
class RtAudioStreamStatus 
{
	/**
	 * Input data was discarded because of an overflow condition at the driver.
	 */
	inline static public var RTAUDIO_INPUT_OVERFLOW = 0x1;
	
	/**
	 * The output buffer ran low, likely causing a gap in the output sound.
	 */
	inline static public var RTAUDIO_OUTPUT_UNDERFLOW = 0x2;
}