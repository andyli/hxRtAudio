/**
 * Copyright (c) 2011, Andy Li http://www.onthewings.net/
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, 
 * are permitted provided that the following conditions are met:
 * 
 * Redistributions of source code must retain the above copyright notice, 
 * this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, 
 * this list of conditions and the following disclaimer in the documentation 
 * and/or other materials provided with the distribution.
 * The name of the author may not be used to endorse or promote products derived 
 * from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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