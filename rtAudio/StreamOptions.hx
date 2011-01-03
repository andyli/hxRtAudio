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