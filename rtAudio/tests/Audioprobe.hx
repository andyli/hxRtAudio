/**
 * Ported from...
 * 
 * audioprobe.cpp
 * by Gary P. Scavone, 2001
 * 
 * Probe audio system and prints device info.
 */

package rtAudio.tests;

import cpp.Lib;
import cpp.Sys;
import rtAudio.RtAudio;
import rtAudio.Api;
import rtAudio.RtAudioFormat;

class Audioprobe 
{

	static public function main():Void
	{
		var apis = RtAudio.getCompiledApi();
		
		Lib.println("\nCompiled APIs:");
		for (i in 0...apis.length)
			Lib.println(i + ": " + apiMap(apis[i]));
			
		var audio = new RtAudio();
		
		Lib.println("\nCurrent API: " + apiMap( audio.getCurrentApi() ));
		
		var devices = audio.getDeviceCount();
		Lib.println("\nFound " + devices + " device(s) ...");
		
		for (i in 0...devices) {
			var info = audio.getDeviceInfo(i);

			Lib.println("\nDevice Name = " + info.name);
			if ( !info.probed )
				Lib.println("Probe Status = UNsuccessful");
			else {
				Lib.println("Probe Status = Successful");
				Lib.println("Output Channels = " + info.outputChannels);
				Lib.println("Input Channels = " + info.inputChannels);
				Lib.println("Duplex Channels = " + info.duplexChannels);
				
				if ( info.isDefaultOutput ) 
					Lib.println("This is the default output device.");
				else 
					Lib.println("This is NOT the default output device.");
				
				if ( info.isDefaultInput ) 
					Lib.println("This is the default input device.");
				else 
					Lib.println("This is NOT the default input device.");
				
				if ( info.nativeFormats.length == 0 )
					Lib.println("No natively supported data formats(?)!");
				else {
					Lib.println("Natively supported data formats:");
					
					for (format in info.nativeFormats) {
						switch (format) {
							case RTAUDIO_SINT8: Lib.println("  8-bit int");
							case RTAUDIO_SINT16: Lib.println("  16-bit int");
							case RTAUDIO_SINT24: Lib.println("  24-bit int");
							case RTAUDIO_SINT32: Lib.println("  32-bit int");
							case RTAUDIO_FLOAT32: Lib.println("  32-bit float");
							case RTAUDIO_FLOAT64: Lib.println("  64-bit float");
						}
					}
				}
				
				if ( info.sampleRates.length < 1 )
					Lib.println("No supported sample rates found!");
				else {
					Lib.print("Supported sample rates = ");
					for (sampleRate in info.sampleRates)
						Lib.print(sampleRate + " ");
				}
				
				Lib.println("");
			}
		}
		Lib.println("");
	}
	
	static function apiMap(api:Api):String {
		return switch(api) {
			case Api.MACOSX_CORE: "OS-X Core Audio";
			case Api.WINDOWS_ASIO: "Windows ASIO";
			case Api.WINDOWS_DS: "Windows Direct Sound";
			case Api.UNIX_JACK: "Jack Client";
			case Api.LINUX_ALSA: "Linux ALSA";
			case Api.LINUX_OSS: "Linux OSS";
			case Api.RTAUDIO_DUMMY: "RtAudio Dummy";
			default: throw "unknown api";
		}
	}
}