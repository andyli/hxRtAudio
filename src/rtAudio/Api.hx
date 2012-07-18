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