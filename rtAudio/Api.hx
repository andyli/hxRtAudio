package rtAudio;

/**
 * Audio API specifier.
 */
enum Api {
	/**
	 * Search for a working compiled API.
	 */
	UNSPECIFIED;
	
	/**
	 * The Advanced Linux Sound Architecture API.
	 */
	LINUX_ALSA;
	
	/**
	 * The Linux Open Sound System API.
	 */
	LINUX_OSS;
	
	/**
	 * The Jack Low-Latency Audio Server API.
	 */
	UNIX_JACK;
	
	/**
	 * Macintosh OS-X Core Audio API.
	 */
	MACOSX_CORE;
	
	/**
	 * The Steinberg Audio Stream I/O API.
	 */
	WINDOWS_ASIO;
	
	/**
	 * The Microsoft Direct Sound API.
	 */
	WINDOWS_DS;
	
	/**
	 * A compilable but non-functional API.
	 */
	RTAUDIO_DUMMY;
}