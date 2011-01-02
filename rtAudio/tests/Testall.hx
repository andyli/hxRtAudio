/**
 * Ported from...
 * 
 * testall.cpp
 * by Gary P. Scavone, 2007-2008
 * 
 * This program will make a variety of calls
 * to extensively test RtAudio functionality.
 */

package rtAudio.tests;

import cpp.Lib;
import cpp.Sys;
import cpp.io.File;
import rtAudio.RtAudio;
import rtAudio.Api;
import rtAudio.RtAudioFormat;
import rtAudio.RtAudioStreamFlags;

class Testall 
{
	inline static var BASE_RATE = 0.005;
	inline static var TIME = 1.0;
	static var channels:Int;
	
	static function usage():Void {
		// Error function in case of incorrect command-line
		// argument specifications
		Lib.print("\nuseage: testall N fs <iDevice> <oDevice> <iChannelOffset> <oChannelOffset>\n");
		Lib.print("    where N = number of channels,\n");
		Lib.print("    fs = the sample rate,\n");
		Lib.print("    iDevice = optional input device to use (default = 0),\n");
		Lib.print("    oDevice = optional output device to use (default = 0),\n");
		Lib.print("    iChannelOffset = an optional input channel offset (default = 0),\n");
		Lib.print("    and oChannelOffset = optional output channel offset (default = 0).\n\n");
		Sys.exit(0);
	}
	
	// Interleaved buffers
	static function sawi( rt:RtAudio ):Int
	{
		var buffer:Array<Float> = rt.outputBuffer;
		var lastValues:Array<Float> = rt.userData;

		if ( rt.status > 0 )
			Lib.println("Stream underflow detected!");

		var counter = 0;
		for ( i in 0...rt.bufferFrames) {
			for ( j in 0...channels ) {
				buffer[counter++] = lastValues[j];
				lastValues[j] += BASE_RATE * (j + 1 + (j * 0.1));
				if ( lastValues[j] >= 1.0 ) lastValues[j] -= 2.0;
			}
		}

		return 0;
	}
	
	// Non-interleaved buffers
	static function sawni( rt:RtAudio ):Int
	{
		var buffer:Array<Float> = rt.outputBuffer;
		var lastValues:Array<Float> = rt.userData;

		if ( rt.status > 0 )
			Lib.println("Stream underflow detected!");

		var increment:Float;
		var counter = 0;
		for ( j in 0...channels ) {
			increment = BASE_RATE * (j + 1 + (j * 0.1));
			for ( i in 0...rt.bufferFrames) {
				buffer[counter++] = lastValues[j];
				lastValues[j] += increment;
				if ( lastValues[j] >= 1.0 ) lastValues[j] -= 2.0;
			}
		}

		return 0;
	}
	
	static function inout( rtAudio:RtAudio ):Int
	{
		if ( rtAudio.status > 0 ) Lib.println("Stream over/underflow detected.");
		
		var bytes:Int = rtAudio.userData;
		var outputBuffer:Array<Int> = rtAudio.outputBuffer;
		var inputBuffer:Array<Int> = rtAudio.inputBuffer;
		
		for (i in 0...outputBuffer.length) {
			outputBuffer[i] = inputBuffer[i];
		}
		
		return 0;
	}
	
	static var dac:RtAudio;
	
	static public function main():Void 
	{
		var bufferFrames:Int, fs:Int, oDevice:Int = 0, iDevice:Int = 0, iOffset:Int = 0, oOffset:Int = 0;
		var stdin = File.stdin();
		
		var argv = Sys.args();
		var argc = argv.length;

		// minimal command-line checking
		if (argc < 2 || argc > 6 ) usage();

		dac = new RtAudio();
		if ( dac.getDeviceCount() < 1 ) {
			Lib.print("\nNo audio devices found!\n");
			Sys.exit( 1 );
		}

		channels = Std.parseInt(argv[0]);
		fs = Std.parseInt(argv[1]);
		if ( argc > 2 )
		iDevice = Std.parseInt(argv[2]);
		if ( argc > 3 )
		oDevice = Std.parseInt(argv[3]);
		if ( argc > 4 )
		iOffset = Std.parseInt(argv[4]);
		if ( argc > 5 )
		oOffset = Std.parseInt(argv[5]);

		var data:Array<Float> = [];
		for (i in 0...channels) data.push(0);

		// Let RtAudio print messages to stderr.
		dac.showWarnings( true );

		// Set our stream parameters for output only.
		bufferFrames = 256;
		var oParams = {
			deviceId:oDevice,
			nChannels:channels,
			firstChannel:oOffset
		};

		var options = {
			flags:RtAudioStreamFlags.RTAUDIO_HOG_DEVICE,
			numberOfBuffers:0,
			streamName:"",
			priority:0
		}
		
		dac.openStream( oParams, null, RtAudioFormat.RTAUDIO_FLOAT64, fs, bufferFrames, sawi, data, options );
		Lib.println("\nStream latency = " + dac.getStreamLatency());

		// Start the stream
		dac.startStream();
		Lib.print("\nPlaying ... press <enter> to stop.\n");
		stdin.readLine();

		// Stop the stream
		dac.stopStream();

		// Restart again
		Lib.print("Press <enter> to restart.\n");
		stdin.readLine();
		dac.startStream();

		// Test abort function
		Lib.print("Playing again ... press <enter> to abort.\n");
		stdin.readLine();
		dac.abortStream();

		// Restart another time
		Lib.print("Press <enter> to restart again.\n");
		stdin.readLine();
		dac.startStream();

		Lib.print("Playing again ... press <enter> to close the stream.\n");
		stdin.readLine();

		if ( dac.isStreamOpen() ) dac.closeStream();

		// Test non-interleaved functionality
		options.flags = RtAudioStreamFlags.RTAUDIO_NONINTERLEAVED;

		dac.openStream( oParams, null, RtAudioFormat.RTAUDIO_FLOAT64, fs, bufferFrames, sawni, data, options );

		Lib.print("Press <enter> to start non-interleaved playback.\n");
		stdin.readLine();

		// Start the stream
		dac.startStream();
		Lib.print("\nPlaying ... press <enter> to stop.\n");
		stdin.readLine();

		if ( dac.isStreamOpen() ) dac.closeStream();

		// Now open a duplex stream.
		var bufferBytes:Int = 0;
		var iParams = {
			deviceId:iDevice,
			nChannels:channels,
			firstChannel:iOffset
		};
		options.flags = RtAudioStreamFlags.RTAUDIO_NONINTERLEAVED;

		dac.openStream( oParams, iParams, RtAudioFormat.RTAUDIO_SINT32, fs, bufferFrames, inout, bufferBytes, options );

		bufferBytes = bufferFrames * channels * 4;

		Lib.print("Press <enter> to start duplex operation.\n");
		stdin.readLine();

		// Start the stream
		dac.startStream();
		Lib.print("\nRunning ... press <enter> to stop.\n");
		stdin.readLine();

		// Stop the stream
		dac.stopStream();
		Lib.print("\nStopped ... press <enter> to restart.\n");
		stdin.readLine();

		// Restart the stream
		dac.startStream();
		Lib.print("\nRunning ... press <enter> to stop.\n");
		stdin.readLine();

		if ( dac.isStreamOpen() ) dac.closeStream();
	}
	
}