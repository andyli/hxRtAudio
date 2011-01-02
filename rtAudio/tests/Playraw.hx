/**
 * Ported from...
 * 
 * playraw.cpp
 * by Gary P. Scavone, 2007
 * 
 * Play a specified raw file.  It is necessary
 * that the file be of the same data format as
 * defined below.
 */

package rtAudio.tests;

import cpp.Lib;
import cpp.Sys;
import cpp.io.File;
import cpp.io.FileInput;
import haxe.io.Eof;
import rtAudio.RtAudio;
import rtAudio.Api;
import rtAudio.RtAudioFormat;

typedef OutputData = {
  var fd:FileInput;
  var channels:Int;
};

class Playraw 
{
	static function usage():Void {
		// Error function in case of incorrect command-line
		// argument specifications
		Lib.print("\nuseage: playraw N fs file <device> <channelOffset>\n");
		Lib.print("    where N = number of channels,\n");
		Lib.print("    fs = the sample rate, \n");
		Lib.print("    file = the raw file to play,\n");
		Lib.print("    device = optional device to use (default = 0),\n");
		Lib.print("    and channelOffset = an optional channel offset on the device (default = 0).\n\n");
		Sys.exit(0);
	}
	
	// Interleaved buffers
	static function output( rtAudio:RtAudio ):Int
	{
		var outputBuffer:Array<Int> = rtAudio.outputBuffer;
		var oData:OutputData = rtAudio.userData;
		var fd = oData.fd;
		var nBufferFrames = rtAudio.bufferFrames;
		
		// In general, it's not a good idea to do file input in the audio
		// callback function but I'm doing it here because I don't know the
		// length of the file we are reading.
		
		var i = 0;
		var iend = outputBuffer.length;
		try {
			do {
				outputBuffer[i] = fd.readInt16();
			} while (++i < iend);
		} catch (eof:Eof) {
			do {
				outputBuffer[i] = 0;
			} while (++i < iend);
			return 1;
		}
		
		return 0;
	}
	
	static var dac:RtAudio;
	
	static public function main() 
	{
		var channels:Int, fs:Int, bufferFrames:Int, device:Int = 0, offset:Int = 0;
		var file:String;
		
		var argv = Sys.args();
		var argc = argv.length;

		// minimal command-line checking
		if ( argc < 3 || argc > 5 ) usage();

		dac = new RtAudio();
		if ( dac.getDeviceCount() < 1 ) {
			Lib.print("\nNo audio devices found!\n");
			Sys.exit( 0 );
		}

		channels = Std.parseInt(argv[0]);
		fs = Std.parseInt(argv[1]);
		file = argv[2];
		if ( argc > 3 )
			device = Std.parseInt(argv[3]);
		if ( argc > 4 )
			offset = Std.parseInt(argv[4]);

		var data = {
		  fd:File.read(file, true),
		  channels:channels
		};

		// Set our stream parameters for output only.
		bufferFrames = 512;
		var oParams = {
			deviceId:device,
			nChannels:channels,
			firstChannel:offset
		}

		dac.openStream( oParams, null, RtAudioFormat.RTAUDIO_SINT16, fs, bufferFrames, output, data );
		
		if (!dac.isStreamOpen()) return 0;
		
		dac.startStream();
		
		if (!dac.isStreamRunning()) return 0;

		Lib.println("\nPlaying raw file " + file + " (buffer frames = " + bufferFrames + ").");
		while ( dac.isStreamRunning() ) {
			Sys.sleep( 0.1 ); // wake every 100 ms to check if we're done
		}

		data.fd.close();
		dac.closeStream();

		return 0;
	}
	
}