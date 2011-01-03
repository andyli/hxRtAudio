package rtAudio;

/**
 * RtAudio data format type.
 * 
 * <p>Support for signed integers and floats.  Audio data fed to/from an
 * RtAudio stream is assumed to ALWAYS be in host byte order.  The
 * internal routines will automatically take care of any necessary
 * byte-swapping between the host format and the soundcard.  Thus,
 * endian-ness is not a concern in the following format definitions.</p>
 */
enum RtAudioFormat {
	/**
	 * 8-bit signed integer.
	 */
	RTAUDIO_SINT8;
	
	/**
	 * 16-bit signed integer.
	 */
	RTAUDIO_SINT16;
	
	/**
	 * Lower 3 bytes of 32-bit signed integer. Not supported in hxRtAudio.
	 */
	RTAUDIO_SINT24;
	
	/**
	 * 32-bit signed integer.
	 */
	RTAUDIO_SINT32;
	
	/**
	 * Normalized between plus/minus 1.0.
	 */
	RTAUDIO_FLOAT32;
	
	/**
	 * Normalized between plus/minus 1.0.
	 */
	RTAUDIO_FLOAT64;
}

/**
 * These are the real value exist in the original rtAudio.
 */
class RtAudioFormatValue {
	inline static public var RTAUDIO_SINT8 = 0x1;
	inline static public var RTAUDIO_SINT16 = 0x2;
	inline static public var RTAUDIO_SINT24 = 0x4;
	inline static public var RTAUDIO_SINT32 = 0x8;
	inline static public var RTAUDIO_FLOAT32 = 0x10;
	inline static public var RTAUDIO_FLOAT64 = 0x20;
}