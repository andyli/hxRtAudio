/**
 * Ported from...
 * 
 * testall.cpp
 * by Gary P. Scavone, 2007-2008
 * 
 * <p>This program will make a variety of calls
 * to extensively test RtAudio functionality.</p>
 */

package rtAudio.tests;

import sys.io.File;
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
		Sys.print("\nuseage: testall N fs <iDevice> <oDevice> <iChannelOffset> <oChannelOffset>\n");
		Sys.print("    where N = number of channels,\n");
		Sys.print("    fs = the sample rate,\n");
		Sys.print("    iDevice = optional input device to use,\n");
		Sys.print("    oDevice = optional output device to use,\n");
		Sys.print("    iChannelOffset = an optional input channel offset (default = 0),\n");
		Sys.print("    and oChannelOffset = optional output channel offset (default = 0).\n\n");
		Sys.exit(0);
	}
	
	// Interleaved buffers
	static function sawi( rt:RtAudio ):Int
	{
		var buffer:Array<Float> = rt.outputBuffer;
		var lastValues:Array<Float> = rt.userData;

		if ( rt.status > 0 )
			Sys.println("Stream underflow detected!");

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
			Sys.println("Stream underflow detected!");

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
		if ( rtAudio.status > 0 ) Sys.println("Stream over/underflow detected.");
		
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
		var bufferFrames:Int, fs:Int, oDevice:Int, iDevice:Int, iOffset:Int = 0, oOffset:Int = 0;
		var stdin = Sys.stdin();

		var argv = Sys.args();
		var argc = argv.length;

		// minimal command-line checking
		if (argc < 2 || argc > 6 ) usage();

		dac = new RtAudio();
		if ( dac.getDeviceCount() < 1 ) {
			Sys.print("\nNo audio devices found!\n");
			Sys.exit( 1 );
		}
		
		
		Sys.println("DeviceCount: " + dac.getDeviceCount());
        
        var defIn = dac.getDefaultInputDevice();
        Sys.println("DefaultInputDevice: " + defIn + " " + dac.getDeviceInfo(defIn));
		
        var defOut = dac.getDefaultOutputDevice();
        Sys.println("DefaultOutputDevice: " + defOut + " " + dac.getDeviceInfo(defOut));
		

		channels = Std.parseInt(argv[0]);
		fs = Std.parseInt(argv[1]);
		iDevice = argc > 2 ? Std.parseInt(argv[2]) : dac.getDefaultInputDevice();
		oDevice = argc > 3 ? Std.parseInt(argv[3]) : dac.getDefaultOutputDevice();
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
			flags:[RTAUDIO_HOG_DEVICE],
			numberOfBuffers:0,
			streamName:"",
			priority:0
		}
        
		dac.openStream( oParams, null, RTAUDIO_FLOAT64, fs, bufferFrames, sawi, data, options );
		Sys.println("\nStream latency = " + dac.getStreamLatency());

		// Start the stream
		dac.startStream();
		Sys.print("\nPlaying ... press <enter> to stop.\n");
        stdin.readLine();

		// Stop the stream
		dac.stopStream();

		// Restart again
		Sys.print("Press <enter> to restart.\n");
		stdin.readLine();
		dac.startStream();

		// Test abort function
		Sys.print("Playing again ... press <enter> to abort.\n");
		stdin.readLine();
		dac.abortStream();

		// Restart another time
		Sys.print("Press <enter> to restart again.\n");
		stdin.readLine();
		dac.startStream();

		Sys.print("Playing again ... press <enter> to close the stream.\n");
		stdin.readLine();

		if ( dac.isStreamOpen() ) dac.closeStream();

		// Test non-interleaved functionality
		options.flags = [RtAudioStreamFlags.RTAUDIO_NONINTERLEAVED];

		dac.openStream( oParams, null, RtAudioFormat.RTAUDIO_FLOAT64, fs, bufferFrames, sawni, data, options );

		Sys.print("Press <enter> to start non-interleaved playback.\n");
		stdin.readLine();

		// Start the stream
		dac.startStream();
		Sys.print("\nPlaying ... press <enter> to stop.\n");
		stdin.readLine();

		if ( dac.isStreamOpen() ) dac.closeStream();

		// Now open a duplex stream.
		var bufferBytes:Int = 0;
		var iParams = {
			deviceId:iDevice,
			nChannels:channels,
			firstChannel:iOffset
		};
		options.flags = [RtAudioStreamFlags.RTAUDIO_NONINTERLEAVED];

		dac.openStream( oParams, iParams, RtAudioFormat.RTAUDIO_SINT32, fs, bufferFrames, inout, bufferBytes, options );

		bufferBytes = bufferFrames * channels * 4;

		Sys.print("Press <enter> to start duplex operation.\n");
		stdin.readLine();

		// Start the stream
		dac.startStream();
		Sys.print("\nRunning ... press <enter> to stop.\n");
		stdin.readLine();

		// Stop the stream
		dac.stopStream();
		Sys.print("\nStopped ... press <enter> to restart.\n");
		stdin.readLine();

		// Restart the stream
		dac.startStream();
		Sys.print("\nRunning ... press <enter> to stop.\n");
		stdin.readLine();

		if ( dac.isStreamOpen() ) dac.closeStream();
	}
	
}