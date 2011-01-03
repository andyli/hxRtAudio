package rtAudio;

/**
 * <p>All RtAudio clients must create a function of type RtAudioCallback
 * to read and/or write data from/to the audio stream.  When the
 * underlying audio system is ready for new input or output data, this
 * function will be invoked.</p>
 * 
 * <p>To continue normal stream operation, the RtAudioCallback function
 * should return a value of zero.  To stop the stream and drain the
 * output buffer, the function should return a value of one.  To abort
 * the stream immediately, the client should return a value of two.</p>
 */
typedef RtAudioCallback = RtAudio -> Int;