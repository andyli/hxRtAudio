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
 * The structure for specifying stream options.
 * 
 * <p>By default, RtAudio streams pass and receive audio data from the
 * client in an interleaved format.  By passing the
 * RTAUDIO_NONINTERLEAVED flag to the openStream() function, audio
 * data will instead be presented in non-interleaved buffers.  In
 * this case, each buffer argument in the RtAudioCallback function
 * will point to a single array of data, with nFrames samples for
 * each channel concatenated back-to-back.  For example, the first
 * sample of data for the second channel would be located at index 
 * nFrames (assuming the buffer pointer was recast to the correct
 * data type for the stream).</p>
 * 
 * <p>Certain audio APIs offer a number of parameters that influence the
 * I/O latency of a stream.  By default, RtAudio will attempt to set
 * these parameters internally for robust (glitch-free) performance
 * (though some APIs, like Windows Direct Sound, make this difficult).
 * By passing the RTAUDIO_MINIMIZE_LATENCY flag to the openStream()
 * function, internal stream settings will be influenced in an attempt
 * to minimize stream latency, though possibly at the expense of stream
 * performance.</p>
 *
 * <p>If the RTAUDIO_HOG_DEVICE flag is set, RtAudio will attempt to
 * open the input and/or output stream device(s) for exclusive use.
 * Note that this is not possible with all supported audio APIs.</p>
 * 
 * <p>If the RTAUDIO_SCHEDULE_REALTIME flag is set, RtAudio will attempt 
 * to select realtime scheduling (round-robin) for the callback thread.
 * The priority parameter will only be used if the RTAUDIO_SCHEDULE_REALTIME
 * flag is set. It defines the thread's realtime priority. </p>
 * 
 */
typedef StreamOptions =
{
	var flags:Array<RtAudioStreamFlags>;
	
	/**
	 * It can be used to control stream latency in the Windows DirectSound, 
	 * Linux OSS, and Linux Alsa APIs only.  A value of two is usually the
	 * smallest allowed.  Larger numbers can potentially result in more 
	 * robust stream performance, though likely at the cost of stream 
	 * latency.  The value set by the user is replaced during execution of 
	 * the openStream() function by the value actually used by the system.
	 */
	var numberOfBuffers:Int;
	
	/**
	 * It can be used to set the client name when using the Jack API.
	 * By default, the client name is set to RtApiJack. However, if you 
	 * wish to create multiple instances of RtAudio with Jack, each instance
	 * must have a unique client name.
	 */
	var streamName:String;
	
	/**
	 * If the RTAUDIO_SCHEDULE_REALTIME flag is set, RtAudio will attempt 
	 * to select realtime scheduling (round-robin) for the callback thread.
	 * The priority parameter will only be used if the RTAUDIO_SCHEDULE_REALTIME
	 * flag is set. It defines the thread's realtime priority.
	 */
	var priority:Int;
}