package rtAudio;

enum Api {
	UNSPECIFIED;    /*!< Search for a working compiled API. */
	LINUX_ALSA;     /*!< The Advanced Linux Sound Architecture API. */
	LINUX_OSS;      /*!< The Linux Open Sound System API. */
	UNIX_JACK;      /*!< The Jack Low-Latency Audio Server API. */
	MACOSX_CORE;    /*!< Macintosh OS-X Core Audio API. */
	WINDOWS_ASIO;   /*!< The Steinberg Audio Stream I/O API. */
	WINDOWS_DS;     /*!< The Microsoft Direct Sound API. */
	RTAUDIO_DUMMY;   /*!< A compilable but non-functional API. */
}