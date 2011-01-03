package rtAudio;

enum RtAudioStreamFlags 
{
	/**
	 * Use non-interleaved buffers (default = interleaved).
	 */
	RTAUDIO_NONINTERLEAVED;
	
	/**
	 * Attempt to set stream parameters for lowest possible latency.
	 */
	RTAUDIO_MINIMIZE_LATENCY;
	
	/**
	 * Attempt grab device and prevent use by others.
	 */
	RTAUDIO_HOG_DEVICE;
	
	/**
	 * Try to select realtime scheduling for callback thread.
	 */
	RTAUDIO_SCHEDULE_REALTIME;
}

/**
 * These are the real value exist in the original rtAudio.
 */
class RtAudioStreamFlagsValue
{
	inline static public var RTAUDIO_NONINTERLEAVED = 0x1;
	inline static public var RTAUDIO_MINIMIZE_LATENCY = 0x2;
	inline static public var RTAUDIO_HOG_DEVICE = 0x4;
	inline static public var RTAUDIO_SCHEDULE_REALTIME = 0x8;
}