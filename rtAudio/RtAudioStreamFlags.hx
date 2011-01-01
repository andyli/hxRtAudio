package rtAudio;

class RtAudioStreamFlags 
{
	inline static public var RTAUDIO_NONINTERLEAVED = 0x1;    // Use non-interleaved buffers (default = interleaved).
	inline static public var RTAUDIO_MINIMIZE_LATENCY = 0x2;  // Attempt to set stream parameters for lowest possible latency.
	inline static public var RTAUDIO_HOG_DEVICE = 0x4;        // Attempt grab device and prevent use by others.
	inline static public var RTAUDIO_SCHEDULE_REALTIME = 0x8; // Try to select realtime scheduling for callback thread.
}