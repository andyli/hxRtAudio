package rtAudio;

class RtAudioFormat {
	inline static public var RTAUDIO_SINT8 = 0x1;    // 8-bit signed integer.
	inline static public var RTAUDIO_SINT16 = 0x2;   // 16-bit signed integer.
	inline static public var RTAUDIO_SINT24 = 0x4;   // Lower 3 bytes of 32-bit signed integer.
	inline static public var RTAUDIO_SINT32 = 0x8;   // 32-bit signed integer.
	inline static public var RTAUDIO_FLOAT32 = 0x10; // Normalized between plus/minus 1.0.
	inline static public var RTAUDIO_FLOAT64 = 0x20; // Normalized between plus/minus 1.0.
}