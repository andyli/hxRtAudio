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
 * The public device information structure for returning queried values.
 */
typedef DeviceInfo = 
{
	/**
	 * true if the device capabilities were successfully probed.
	 */
	var probed:Bool;
	
	/**
	 * Device identifier.
	 */
	var name:String;
	
	/**
	 * Maximum output channels supported by device.
	 */
	var outputChannels:Int;
	
	/**
	 * Maximum input channels supported by device.
	 */
	var inputChannels:Int;
	
	/**
	 * Maximum simultaneous input/output channels supported by device.
	 */
	var duplexChannels:Int;
	
	/**
	 * true if this is the default output device.
	 */
	var isDefaultOutput:Bool;
	
	/**
	 * true if this is the default input device.
	 */
	var isDefaultInput:Bool;
	
	/**
	 * Supported sample rates (queried from list of standard rates).
	 */
	var sampleRates:Array<Int>;
	
	/**
	 * Array of supported data formats.
	 */
	var nativeFormats:Array<RtAudioFormat>;
}