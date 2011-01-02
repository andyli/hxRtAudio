/**
 * Ported from...
 * 
 * record.cpp
 * by Gary P. Scavone, 2007
 * 
 * This program records audio from a device and writes it to a
 * header-less binary file.  Use the 'playraw', with the same
 * parameters and format settings, to playback the audio.
 */

package rtAudio.tests;

import cpp.Lib;
import cpp.Sys;
import cpp.io.File;
import cpp.io.FileOutput;
import rtAudio.RtAudio;
import rtAudio.Api;
import rtAudio.RtAudioFormat;

typedef InputData = {
	var buffer:Array<Int>;
	var totalFrames:Int;
	var frameCounter:Int;
	var channels:Int;
};

class Record 
{	
	static function usage():Void {
		// Error function in case of incorrect command-line
		// argument specifications
		Lib.print( "\nuseage: record N fs <duration> <device> <channelOffset>\n" );
		Lib.print( "    where N = number of channels,\n" );
		Lib.print( "    fs = the sample rate,\n" );
		Lib.print( "    duration = optional time in seconds to record (default = 2.0),\n" );
		Lib.print( "    device = optional device to use (default = 0),\n" );
		Lib.print( "    and channelOffset = an optional channel offset on the device (default = 0).\n\n" );
		Sys.exit( 0 );
	}
	
	static function input(rtAudio:RtAudio) {
		var iData:InputData = rtAudio.userData;
		var inputBuffer:Array<Int> = rtAudio.inputBuffer;
		var nBufferFrames = rtAudio.bufferFrames;

		var frames = nBufferFrames;
		if ( iData.frameCounter + nBufferFrames > iData.totalFrames ) {
			frames = iData.totalFrames - iData.frameCounter;
		}

		for (i in 0...frames) {
			iData.buffer.push(inputBuffer[i]);
		}
		iData.frameCounter += frames;

		if ( iData.frameCounter >= iData.totalFrames ) {
			return 2;
		} else {
			return 0;
		}
	}
	
	static var adc = new RtAudio();
	
	static public function main():Void
	{		
		var channels:Int, fs:Int, bufferFrames:Int, device:Int = 0, offset:Int = 0;
		var time:Float = 2.0;
		var fd:FileOutput;

		// minimal command-line checking
		var argv = Sys.args();
		var argc = argv.length;
		if ( argc < 2 || argc > 5 ) usage();
		
		if ( adc.getDeviceCount() < 1 ) {
			Lib.print( "\nNo audio devices found!\n" );
			Sys.exit( 1 );
		}

		channels = Std.parseInt(argv[0]);
		fs = Std.parseInt(argv[1]);
		if ( argc > 3 )
		time = Std.parseFloat(argv[2]);
		if ( argc > 4 )
		device = Std.parseInt(argv[3]);
		if ( argc > 5 )
		offset = Std.parseInt(argv[4]);

		// Let RtAudio print messages to stderr.
		adc.showWarnings( true );

		// Set our stream parameters for input only.
		bufferFrames = 512;
		var iParams = {
			deviceId:device,
			nChannels:channels,
			firstChannel:offset
		};
		
		var data = {
			buffer:new Array<Int>(),
			totalFrames:0,
			frameCounter:0,
			channels:0
		};
		
		adc.openStream( null, iParams, RtAudioFormat.RTAUDIO_SINT16, fs, bufferFrames, input, data );
		
		if (!adc.isStreamOpen()) return;

		data.totalFrames = cast fs * time;
		data.frameCounter = 0;
		data.channels = channels;

		adc.startStream();
		
		if (!adc.isStreamRunning()) return;

		Lib.println( "\nRecording for " + time + " seconds ... writing file 'record.raw' (buffer frames = " + bufferFrames + ")." );
		while ( adc.isStreamRunning() ) {
			Sys.sleep( 0.1 ); // wake every 100 ms to check if we're done
		}

		// Now write the entire data to the file.
		fd = File.write( "record.raw", true );
		
		for (i in data.buffer) {
			fd.writeInt16(i);
		}
		
		fd.flush();
		fd.close();

		if (adc.isStreamOpen()) adc.closeStream();
	}
	
}