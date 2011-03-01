#define IMPLEMENT_API
#include <hx/CFFI.h>

#include <vector>
#include "RtAudio.h"


int callback
(
	void *outputBuffer,
	void *inputBuffer,
	unsigned int nFrames,
	double streamTime,
	RtAudioStreamStatus status,
	void *data
) {	

	const static int id_outputBuffer = val_id("outputBuffer");
	const static int id_inputBuffer = val_id("inputBuffer");
	const static int id_nFrames = val_id("nFrames");
	const static int id_streamTime = val_id("streamTime");
	const static int id_status = val_id("status");
	const static int id_userData = val_id("userData");
	const static int id_streamCallback = val_id("streamCallback");
	const static int id_inputParameters = val_id("inputParameters");
	const static int id_outputParameters = val_id("outputParameters");
	const static int id_nChannels = val_id("nChannels");
	const static int id_formatValue = val_id("formatValue");
	const static int id_threadCallbackRun = val_id("threadCallbackRun");

	value rtAudioHandle = (value) data;

	value outAry = val_field(rtAudioHandle, id_outputBuffer);
	value inAry = val_field(rtAudioHandle, id_inputBuffer);
	int format = val_field_numeric(rtAudioHandle, id_formatValue);
	
	alloc_field(rtAudioHandle, id_status, alloc_int(status));
	
	gc_enter_blocking();
	
	if (inputBuffer){
		unsigned int inAryLen = nFrames * val_field_numeric(val_field(rtAudioHandle, id_inputParameters), id_nChannels);
		
		switch(format) {
			case RTAUDIO_SINT8:
			{
				char* input = (char*) inputBuffer;
				int* hxInput = val_array_int(inAry);
				for (int i = 0 ; i < inAryLen ; ++i){
					hxInput[i] = input[i];
				}
			}
				break;
			case RTAUDIO_SINT16:
			{
				short* input = (short*) inputBuffer;
				int* hxInput = val_array_int(inAry);
				for (int i = 0 ; i < inAryLen ; ++i){
					hxInput[i] = input[i];
				}
			}
				break;
			case RTAUDIO_SINT32:
			{
				int* input = (int*) inputBuffer;
				int* hxInput = val_array_int(inAry);
				memcpy (hxInput, input, inAryLen*sizeof(int));
			}
				break;
			case RTAUDIO_FLOAT32:
			{
				float* input = (float*) inputBuffer;
				double* hxInput = val_array_double(inAry);
				for (int i = 0 ; i < inAryLen ; ++i){
					hxInput[i] = input[i];
				}
			}
				break;
			case RTAUDIO_FLOAT64:
			{
				double* input = (double*) inputBuffer;
				double* hxInput = val_array_double(inAry);
				memcpy (hxInput, input, inAryLen*sizeof(double));
			}
				break;
			default:
				;
		}
	}
	
	gc_exit_blocking();
	
	int returnVal = val_int(val_ocall0(rtAudioHandle, id_threadCallbackRun));
	
	gc_enter_blocking();
	
	if (outputBuffer){
		unsigned int outAryLen = nFrames * val_field_numeric(val_field(rtAudioHandle, id_outputParameters), id_nChannels);
		
		switch(format) {
			case RTAUDIO_SINT8:
			{
				char* out = (char*) outputBuffer;
				int* hxOut = val_array_int(outAry);
				for (int i = 0 ; i < outAryLen ; ++i){
					out[i] = hxOut[i];
				}
			}
				break;
			case RTAUDIO_SINT16:
			{
				short* out = (short*) outputBuffer;
				int* hxOut = val_array_int(outAry);
				for (int i = 0 ; i < outAryLen ; ++i){
					out[i] = hxOut[i];
				}
			}
				break;
			case RTAUDIO_SINT32:
			{
				int* out = (int*) outputBuffer;
				int* hxOut = val_array_int(outAry);
				memcpy (out, hxOut, outAryLen*sizeof(int));
			}
				break;
			case RTAUDIO_FLOAT32:
			{
				float* out = (float*) outputBuffer;
				double* hxOut = val_array_double(outAry);
				for (int i = 0 ; i < outAryLen ; ++i){
					out[i] = hxOut[i];
				}
			}
				break;
			case RTAUDIO_FLOAT64:
			{
				double* out = (double*) outputBuffer;
				double* hxOut = val_array_double(outAry);
				memcpy (out, hxOut, outAryLen*sizeof(double));
			}
				break;
			default:
				;
		}
	}
	
	gc_exit_blocking();
	
	return returnVal;
}

value _RtAudio_getCompiledApi() {
	std::vector< RtAudio::Api > apis;
	RtAudio::getCompiledApi(apis);
	int apiNum = apis.size();
	value ary = alloc_array(apiNum);
	for (int i = 0 ; i < apiNum ; ++i){
		val_array_set_i(ary, i, alloc_int(apis[i]));
	}
	return ary;
}
DEFINE_PRIM(_RtAudio_getCompiledApi,0);


DEFINE_KIND(_RtAudio);

void delete_RtAudio(value a) {
	RtAudio* rtAudio = (RtAudio*) val_data(a);
	
	delete rtAudio;
}

value _RtAudio_new(value a) {	
	value handle = alloc_abstract(_RtAudio, new RtAudio((RtAudio::Api) val_int(a)));
	val_gc(handle, delete_RtAudio);
	
	return handle;
}
DEFINE_PRIM(_RtAudio_new,1);

value _RtAudio_getCurrentApi(value a) {
	RtAudio* rtAudio = (RtAudio*) val_data(a);
	return alloc_int(rtAudio->getCurrentApi());
}
DEFINE_PRIM(_RtAudio_getCurrentApi,1);

value _RtAudio_getDeviceCount(value a) {
	RtAudio* rtAudio = (RtAudio*) val_data(a);
	return alloc_int(rtAudio->getDeviceCount());
}
DEFINE_PRIM(_RtAudio_getDeviceCount,1);

value _RtAudio_getDeviceInfo(value a,value b) {
	RtAudio* rtAudio = (RtAudio*) val_data(a);
	RtAudio::DeviceInfo info = rtAudio->getDeviceInfo(val_int(b));
	
	value ret = alloc_empty_object();
	
	alloc_field(ret,val_id("probed"),alloc_bool(info.probed));
	alloc_field(ret,val_id("name"),alloc_string(info.name.c_str()));
	alloc_field(ret,val_id("outputChannels"),alloc_int(info.outputChannels));
	alloc_field(ret,val_id("inputChannels"),alloc_int(info.inputChannels));
	alloc_field(ret,val_id("duplexChannels"),alloc_int(info.duplexChannels));
	alloc_field(ret,val_id("isDefaultOutput"),alloc_bool(info.isDefaultOutput));
	alloc_field(ret,val_id("isDefaultInput"),alloc_bool(info.isDefaultInput));
	
	int num = info.sampleRates.size();
	value sampleRates = alloc_array(num);
	for (int i = 0 ; i < num ; ++i){
		val_array_set_i(sampleRates, i, alloc_int(info.sampleRates[i]));
	}
	alloc_field(ret,val_id("sampleRates"),sampleRates);
	
	alloc_field(ret,val_id("nativeFormats"),alloc_int(info.nativeFormats));
	
	return ret;
}
DEFINE_PRIM(_RtAudio_getDeviceInfo,2);

value _RtAudio_getDefaultOutputDevice(value a) {
	RtAudio* rtAudio = (RtAudio*) val_data(a);
	return alloc_int(rtAudio->getDefaultOutputDevice());
}
DEFINE_PRIM(_RtAudio_getDefaultOutputDevice,1);

value _RtAudio_getDefaultInputDevice(value a) {
	RtAudio* rtAudio = (RtAudio*) val_data(a);
	return alloc_int(rtAudio->getDefaultInputDevice());
}
DEFINE_PRIM(_RtAudio_getDefaultInputDevice,1);

value _RtAudio_closeStream(value a) {
	RtAudio* rtAudio = (RtAudio*) val_data(a);
	rtAudio->closeStream();
	return alloc_null();
}
DEFINE_PRIM(_RtAudio_closeStream,1);

value _RtAudio_startStream(value a) {
	RtAudio* rtAudio = (RtAudio*) val_data(a);
	try {
		rtAudio->startStream();
	} catch (RtError &error) {
		error.printMessage();
	}
	return alloc_null();
}
DEFINE_PRIM(_RtAudio_startStream,1);

value _RtAudio_stopStream(value a) {
	RtAudio* rtAudio = (RtAudio*) val_data(a);
	try {
		rtAudio->stopStream();
	} catch (RtError &error) {
		error.printMessage();
	}
	return alloc_null();
}
DEFINE_PRIM(_RtAudio_stopStream,1);

value _RtAudio_abortStream(value a) {
	RtAudio* rtAudio = (RtAudio*) val_data(a);
	try {
		rtAudio->abortStream();
	} catch (RtError &error) {
		error.printMessage();
	}
	return alloc_null();
}
DEFINE_PRIM(_RtAudio_abortStream,1);

value _RtAudio_isStreamOpen(value a) {
	RtAudio* rtAudio = (RtAudio*) val_data(a);
	return alloc_bool(rtAudio->isStreamOpen());
}
DEFINE_PRIM(_RtAudio_isStreamOpen,1);

value _RtAudio_isStreamRunning(value a) {
	RtAudio* rtAudio = (RtAudio*) val_data(a);
	return alloc_bool(rtAudio->isStreamRunning());
}
DEFINE_PRIM(_RtAudio_isStreamRunning,1);

value _RtAudio_getStreamTime(value a) {
	RtAudio* rtAudio = (RtAudio*) val_data(a);
	try {
		return alloc_float(rtAudio->getStreamTime());
	} catch (RtError &error) {
		error.printMessage();
		return alloc_float(0);
	}
}
DEFINE_PRIM(_RtAudio_getStreamTime,1);

value _RtAudio_getStreamLatency(value a) {
	RtAudio* rtAudio = (RtAudio*) val_data(a);
	try {
		return alloc_int(rtAudio->getStreamLatency());
	} catch (RtError &error) {
		error.printMessage();
		return alloc_int(0);
	}
}
DEFINE_PRIM(_RtAudio_getStreamLatency,1);

value _RtAudio_getStreamSampleRate(value a) {
	RtAudio* rtAudio = (RtAudio*) val_data(a);
	try {
		return alloc_int(rtAudio->getStreamSampleRate());
	} catch (RtError &error) {
		error.printMessage();
		return alloc_int(0);
	}
}
DEFINE_PRIM(_RtAudio_getStreamSampleRate,1);

value _RtAudio_showWarnings(value a,value b) {
	RtAudio* rtAudio = (RtAudio*) val_data(a);
	rtAudio->showWarnings(val_bool(b));
	return alloc_null();
}
DEFINE_PRIM(_RtAudio_showWarnings,2);

value _RtAudio_openStream(value a,value b,value c) {
	RtAudio* rtAudio = (RtAudio*) val_data(a);
	
	value outputParametersHandle = val_field(c, val_id("outputParameters"));
	RtAudio::StreamParameters * outputParameters=NULL;
	if(!val_is_null(outputParametersHandle)){
		outputParameters = new RtAudio::StreamParameters();
		outputParameters->deviceId = val_field_numeric(outputParametersHandle, val_id("deviceId"));
		outputParameters->nChannels = val_field_numeric(outputParametersHandle, val_id("nChannels"));
		outputParameters->firstChannel = val_field_numeric(outputParametersHandle, val_id("firstChannel"));
	}

	value inputParametersHandle = val_field(c, val_id("inputParameters"));
	RtAudio::StreamParameters * inputParameters = NULL;
	if(!val_is_null(inputParametersHandle)){
		inputParameters = new RtAudio::StreamParameters();
		inputParameters->deviceId = val_field_numeric(inputParametersHandle, val_id("deviceId"));
		inputParameters->nChannels = val_field_numeric(inputParametersHandle, val_id("nChannels"));
		inputParameters->firstChannel = val_field_numeric(inputParametersHandle, val_id("firstChannel"));
	}

	int format = val_field_numeric(c, val_id("format"));
	int sampleRate = val_field_numeric(c, val_id("sampleRate"));
	unsigned int bufferFrames = val_field_numeric(c, val_id("bufferFrames"));

	value optionsHandle = val_field(c, val_id("options"));
	RtAudio::StreamOptions * options = NULL;
	if(!val_is_null(optionsHandle)){
		options = new RtAudio::StreamOptions();
		options->flags = val_field_numeric(optionsHandle, val_id("flags"));
		options->numberOfBuffers = val_field_numeric(optionsHandle, val_id("numberOfBuffers"));
		options->streamName = val_string(val_field(optionsHandle, val_id("streamName")));
		options->priority = val_field_numeric(optionsHandle, val_id("priority"));
	}
	
	try {
		rtAudio->openStream(
			outputParameters,
			inputParameters,
			format,
			sampleRate,
			&bufferFrames,
			&callback,
			b,
			options
		);
	} catch (RtError &error) {
		error.printMessage();
		//std::exit(EXIT_FAILURE); // need case here
	}
	
	alloc_field(b, val_id("bufferFrames"), alloc_int(bufferFrames));
	
	if(options){
		alloc_field(optionsHandle, val_id("numberOfBuffers"), alloc_int(options->numberOfBuffers));
		delete options;
	}
	
	if (outputParameters) delete outputParameters;
	if (inputParameters) delete inputParameters;
	
	return alloc_null();
}
DEFINE_PRIM(_RtAudio_openStream,3);
