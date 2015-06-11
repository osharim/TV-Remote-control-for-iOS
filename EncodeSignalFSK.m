//
//  iR Control
//
//  Created by Omar & Alejandro .   @osharim
//  Copyright (c) 2015 Bentel Mexico. All rights reserved.
//  www.bentel.mx

#import "EncodeSignalFSK.h"


@implementation EncodeSignalFSK{
    
    float amplitude ;
    float phaseShiftInPi;
    const char* bit0;
    const char* bit1 ;
    NSString *heading ;
    NSString *tailing;
    NSString *_KeyValue;
    float lowFreq;
    float highFreq;
}


const  double sampleRate = 44100;


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)initAudioSignal{
    
    //__bridge transfers a pointer between Objective-C and Core Foundation with no transfer of ownership.
    OSStatus result = AudioSessionInitialize(NULL, NULL, ToneInterruptionListener, (__bridge void *)(self));
    if (result == kAudioSessionNoError)
    {
        //way to allow sounds to be played even if the ringer switch is set to off is like so
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    }
    
}

/*
 Configuramos el protocolo y codigo a enviar
 
 */

- (void)SetProtocol:(NSString*)protocol AndSetKeyPressed:(NSString*)keyPressed{
    _Protocol = protocol;
    _KeyValue = keyPressed;
    
}

/*
 CONFIGURACION DE PULSOS */


- (void)ConfigurePulseLeaderWithDataInMs:(NSString *)miliseconds{
    
    if([miliseconds isEqualToString:@"1"]){
        
        // CONFIGURACION PARA BIT 0
        
        amplitude =   1;
        
        phaseShiftInPi = 1.99;
        
        heading = @"^";
        tailing = @"_________________";
        lowFreq = 559;
        highFreq = 210;
    }
    
    
    
    if([miliseconds isEqualToString:@"2"]){
        
        // CONFIGURACION PARA BIT 1
        
        amplitude =   1;
        
        phaseShiftInPi = 0;
        
        heading = @"_^^^^^^^^^^^^^";
        tailing = @"^";
        lowFreq = 110;
        highFreq = 565;
    }
    
}



/* Enviamos los datos */

- (void)SendDataToEmiter{
    
    
    if (toneUnit){
        status = 0;
        AudioOutputUnitStop(toneUnit);
        AudioUnitUninitialize(toneUnit);
        AudioComponentInstanceDispose(toneUnit);
        toneUnit = nil;
        if(dataQueue != NULL){
            free(dataQueue);
            dataQueue = NULL;
        }
        
    }else{
        [self initAudioSignal];
        
        //EN USO
        status = 1;
        qIndex = 0;
        
        bit0 =  [@"_" UTF8String];
        bit1 = [@"^" UTF8String];
        
        [self ConfigurePulseLeaderWithDataInMs:@"1"];
        
        //Configuracion frecuencia
        
        int FrecuencyLowData = round(sampleRate/lowFreq);
        int lowSize =FrecuencyLowData*sizeof(double);
        
        int FrecuencyHighData = round(sampleRate/highFreq);
        int highSize = FrecuencyHighData*sizeof(double);
        
        //Creamos array con el tamaño de lowSteps
        double BufferForLowData[FrecuencyLowData];
        double BufferForHighData[FrecuencyHighData];
        
        
        //calcula FSK y guarda el pulso en alto en el buffer asignado BufferForLowData | BufferForHighData
        
        BOOL changeFreq = false;
        int type_bit = 0;
        GenerateFSKEncoding(BufferForLowData, lowFreq, FrecuencyLowData, amplitude, phaseShiftInPi,changeFreq,type_bit);
        GenerateFSKEncoding(BufferForHighData, highFreq, FrecuencyHighData, amplitude, phaseShiftInPi,changeFreq, type_bit);
        //en este punto tenemos guardado en cada buffer el tamaño de la señal en bajo y alto.
        
        
        // BIS SE ENVIARAN PARA PODER PARAR CUANDO SE TERMINE DE ENVIAR
        for (int i=0; i<heading.length; ++i) {
            NSString* h = [heading substringWithRange:NSMakeRange(i, 1)];
            if([h isEqualToString:@"_"]) {
                qSteps+=FrecuencyLowData;
            } else if([h isEqualToString:@"^"]) {
                qSteps+=FrecuencyHighData;
            }
        }
        
        
        // CONTAMOS CUANTOS BIS SE ENVIARAN PARA PODER PARA CUANDO SE TERMINE DE ENVIAR
        
        for (int i=0; i<tailing.length; ++i) {
            NSString* t = [tailing substringWithRange:NSMakeRange(i, 1)];
            if([t isEqualToString:@"_"]) {
                qSteps+=FrecuencyLowData;
                
            } else if([t isEqualToString:@"^"]) {
                qSteps+=FrecuencyHighData;
            }
        }
        
        //****************************************************************************************
        
        
        [self ConfigurePulseLeaderWithDataInMs:@"2"];
        
        //Configuracion frecuencia
        
        int FrecuencyLowData2 = round(sampleRate/lowFreq);
        int lowSize2 =FrecuencyLowData2*sizeof(double);
        
        int FrecuencyHighData2 = round(sampleRate/highFreq);
        int highSize2 = FrecuencyHighData2*sizeof(double);
        
        //Creamos array con el tamaño de lowSteps
        double BufferForLowData2[FrecuencyLowData2];
        double BufferForHighData2[FrecuencyHighData2];
        
        changeFreq = true;
        // tipo de bit
        type_bit = 1;
        //calcula FSK y guarda el pulso en alto en el buffer asignado BufferForLowData | BufferForHighData
        GenerateFSKEncoding(BufferForLowData2, lowFreq, FrecuencyLowData2, amplitude, phaseShiftInPi,changeFreq,type_bit);
        GenerateFSKEncoding(BufferForHighData2, highFreq, FrecuencyHighData2, amplitude, phaseShiftInPi,changeFreq,type_bit);
        //en este punto tenemos guardado en cada buffer el tamaño de la señal en bajo y alto.
        
        
        // CONTAMOS CUANTOS BIS SE ENVIARAN PARA PODER PARAR CUANDO SE TERMINE DE ENVIAR
        for (int i=0; i<heading.length; ++i) {
            NSString* h = [heading substringWithRange:NSMakeRange(i, 1)];
            if([h isEqualToString:@"_"]) {
                qSteps+=FrecuencyLowData2;
            } else if([h isEqualToString:@"^"]) {
                qSteps+=FrecuencyHighData2;
            }
        }
        
        
        // CONTAMOS CUANTOS BIS SE ENVIARAN PARA PODER PARA CUANDO SE TERMINE DE ENVIAR
        
        for (int i=0; i<tailing.length; ++i) {
            NSString* t = [tailing substringWithRange:NSMakeRange(i, 1)];
            if([t isEqualToString:@"_"]) {
                qSteps+=FrecuencyLowData2;
                
            } else if([t isEqualToString:@"^"]) {
                qSteps+=FrecuencyHighData2;
            }
        }
        
    
        //bits se enviaran para poder parar la ejecucion cuando terminen.
        dataQueue = (double*)malloc(sizeof(double)*qSteps);
        
        PulseToSendInSignal = dataQueue;
        
        if([_KeyValue isEqual:@"0"]){
            
            Power(PulseToSendInSignal, BufferForHighData2, highSize2,BufferForLowData,lowSize, FrecuencyLowData,FrecuencyHighData2);
            
        }
        
        if([_KeyValue isEqual:@"1"]){
            
            ChannelUp(PulseToSendInSignal, BufferForHighData2, highSize2,BufferForLowData,lowSize, FrecuencyLowData,FrecuencyHighData2);
            
        }
        if([_KeyValue isEqual:@"2"]){
            
            ChannelDown(PulseToSendInSignal, BufferForHighData2, highSize2,BufferForLowData,lowSize, FrecuencyLowData,FrecuencyHighData2);
            
        }
        
        
        PulseToSendInSignal = dataQueue;
        
        [self createToneUnit];
        
        //cargamos el tono
        // Stop changing parameters on the unit
        OSErr err = AudioUnitInitialize(toneUnit);
        NSAssert1(err == noErr, @"Error initializing unit: %d", err);
        
        //empezamos a emitir en el canal.
        // Start playback
        err = AudioOutputUnitStart(toneUnit);
        NSAssert1(err == noErr, @"Error starting unit: %d", err);
        
        
        
    }
    
    
}


void ChannelUp(double* PulseToSendInSignal, double* BufferForHighData2, double highSize2,
               double* BufferForLowData, double lowSize,int FrecuencyLowData, int FrecuencyHighData2){
    
    
    
    memcpy(PulseToSendInSignal, BufferForHighData2, highSize2);
    PulseToSendInSignal+=FrecuencyHighData2;
    
    
    memcpy(PulseToSendInSignal, BufferForHighData2, highSize2);
    PulseToSendInSignal+=FrecuencyHighData2;
    
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForHighData2, highSize2);
    PulseToSendInSignal+=FrecuencyHighData2;
    
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
}

void ChannelDown(double* PulseToSendInSignal, double* BufferForHighData2, double highSize2,
                 double* BufferForLowData, double lowSize,int FrecuencyLowData, int FrecuencyHighData2){
    
    
    // BITS CHANNEL DOWN 11000000100001
    
    memcpy(PulseToSendInSignal, BufferForHighData2, highSize2);
    PulseToSendInSignal+=FrecuencyHighData2;
    
    
    memcpy(PulseToSendInSignal, BufferForHighData2, highSize2);
    PulseToSendInSignal+=FrecuencyHighData2;
    
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForHighData2, highSize2);
    PulseToSendInSignal+=FrecuencyHighData2;
    
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForHighData2, highSize2);
    PulseToSendInSignal+=FrecuencyHighData2;
    
}


void Power(double* PulseToSendInSignal, double* BufferForHighData2, double highSize2,
           double* BufferForLowData, double lowSize,int FrecuencyLowData, int FrecuencyHighData2){
    
    
    // BITS CHANNEL DOWN 11000000001100
    
    //  BIT 1
    
    memcpy(PulseToSendInSignal, BufferForHighData2, highSize2);
    PulseToSendInSignal+=FrecuencyHighData2;
    
    
    memcpy(PulseToSendInSignal, BufferForHighData2, highSize2);
    PulseToSendInSignal+=FrecuencyHighData2;
    
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForHighData2, highSize2);
    PulseToSendInSignal+=FrecuencyHighData2;
    
    memcpy(PulseToSendInSignal, BufferForHighData2, highSize2);
    PulseToSendInSignal+=FrecuencyHighData2;
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    memcpy(PulseToSendInSignal, BufferForLowData, lowSize);
    PulseToSendInSignal+=FrecuencyLowData;
    
    
    
}





/**
 
 
 Procesa y guarda todos los datos ingresados en forma de ondas a traves de FSK.
 
 @summary Calculamos cuantos bits se enviaran en total a traves de los strings - o ^ que se ingresen
 @param:  buf double lowData[lowSteps|highSteps] es el apuntador array ;
 @param:  freq Frecuencia ingresada por el usuario en campos - lowSteps o highSteps
 @param:  steps Contiene el periodo de la onda dado por round(sampleRate/lowFreq|highFreq) ejem. 441000/900 = 45
 @return: (void)
 
 **/


void GenerateFSKEncoding(double* buf, int freq, int steps, float amplitude, float phaseShiftInPi,bool changeFreq, int type_bit){
    
    
    double theta=0;
    double theta_increment = 2.0 * M_PI * freq / sampleRate;
    
    for (int i=0; i<steps; ++i) {
        
        
        double result = (sin(theta+phaseShiftInPi*M_PI) * amplitude);
        
        if(type_bit){
            // bit == 1 en philips requiere señares de tipo ___|'''''|   (inversa)
            
            
            // solo estara en alto 24 periodos -> 24/44100 = 0.00045ms
            if (i<=40) {
                
                result = 0;
                
            }else{
                
                result = 99;
            }
            
            
        }else{
            
            if(changeFreq && result > 0 ){
                
                
                // solo estara en alto 24 periodos -> 24/44100 = 0.00045ms
                if (i>=40) {
                    
                    result = 0;
                    
                }else{
                    
                    result = 99;
                }
            }
            
        }
        
        
        buf[i] = result;
        
        
        theta+=theta_increment;
        
        if (theta > 2.0 * M_PI)
        {
            theta -= 2.0 * M_PI;
        }
        
        
    }
    
    
}







/**
 
 Duerme Al hilo
 
 **/



- (void)stop
{
    
    // NSLog(@"interrumpido");
    if (toneUnit)
    {
        
        //[self sendData:[self sendButton]];
        float interval_ =  interval;
        if (interval_>0) {
            
            // Sleep for a while. This makes it easiest to test various problematic cases.
            [NSThread sleepForTimeInterval:interval/1000];
            
            
        }
        
    }
    
    //paramos de enviar la señal, pero no matamos el thread.
    [self StopSendSignal];
}




/**
 
 Summary : Callback cuando stop de emitir la señal.
 
 **/



void ToneInterruptionListener(void *inClientData, UInt32 inInterruptionState)
{
    
    EncodeSignalFSK *controller = (__bridge EncodeSignalFSK*)inClientData;
    [controller stop];
    
}



/*
 ATENCION, DEFINIR ESTA CLASE, ESTA SECCION DETIENE LA EJECICION DEL SONIDO
 
 */


- (void)StopSendSignal  {
    
    status = 0;
    AudioOutputUnitStop(toneUnit);
    AudioUnitUninitialize(toneUnit);
    AudioComponentInstanceDispose(toneUnit);
    toneUnit = nil;
    if(dataQueue != NULL){
        free(dataQueue);
        dataQueue = NULL;
    }
    
    
}





/*
 
 // Configure the search parameters to find the default playback output unit
 // (called the kAudioUnitSubType_RemoteIO on iOS but
 // kAudioUnitSubType_DefaultOutput on Mac OS X)
 
 
 */



OSStatus RenderTone(
                    void *inRefCon,
                    AudioUnitRenderActionFlags 	*ioActionFlags,
                    const AudioTimeStamp 		*inTimeStamp,
                    UInt32 						inBusNumber,
                    UInt32 						inNumberFrames,
                    AudioBufferList 			*ioData)

{
    // Get the tone parameters out
    EncodeSignalFSK *controller = (__bridge EncodeSignalFSK*)inRefCon;
    
    
    
    // This is a mono tone generator so we only need the first buffer
    const int channel = 0;
    Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
    
    //printf("Start package.\n");
    // Generate the samples
    for (UInt32 frame = 0; frame < inNumberFrames; frame++)
    {
        if(controller->status){
            
            buffer[frame] = *(controller->PulseToSendInSignal);
            
            
            ++controller->PulseToSendInSignal;
            
            // si el indicque es mayor a los Steps que tenemos que hacer entonces qu pare.
            if(++controller->qIndex >= controller->qSteps){
                
                //Invokes a method of the receiver on the main thread using the default mode.
                //printf("qIndex end:%lu qSteps:%lu\n", viewController->qIndex, viewController->qSteps);
                [controller performSelectorOnMainThread:@selector(stop) withObject:nil waitUntilDone:NO];
                
                
                
                controller->status = 0;
                
                
                
                break;
                
                
            }
        }
    }
    
    return noErr;
}






- (void)createToneUnit
{
    AudioComponentDescription defaultOutputDescription;
    defaultOutputDescription.componentType = kAudioUnitType_Output;
    defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
    defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    defaultOutputDescription.componentFlags = 0;
    defaultOutputDescription.componentFlagsMask = 0;
    
    // Get the default playback output unit
    AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
    NSAssert(defaultOutput, @"Can't find default output");
    
    // Create a new unit based on this that we'll use for output
    OSErr err = AudioComponentInstanceNew(defaultOutput, &toneUnit);
    NSAssert1(toneUnit, @"Error creating unit: %d", err);
    
    // Set our tone rendering function on the unit
    AURenderCallbackStruct input;
    input.inputProc = RenderTone;
    input.inputProcRefCon = (__bridge void *)(self);
    err = AudioUnitSetProperty(toneUnit,
                               kAudioUnitProperty_SetRenderCallback,
                               kAudioUnitScope_Input,
                               0,
                               &input,
                               sizeof(input));
    NSAssert1(err == noErr, @"Error setting callback: %d", err);
    
    // Set the format to 32 bit, single channel, floating point, linear PCM
    const int four_bytes_per_float = 4;
    const int eight_bits_per_byte = 8;
    AudioStreamBasicDescription streamFormat;
    streamFormat.mSampleRate = sampleRate;
    streamFormat.mFormatID = kAudioFormatLinearPCM;
    streamFormat.mFormatFlags =
    kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
    streamFormat.mBytesPerPacket = four_bytes_per_float;
    streamFormat.mFramesPerPacket = 1;
    streamFormat.mBytesPerFrame = four_bytes_per_float;
    streamFormat.mChannelsPerFrame = 1;
    streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
    err = AudioUnitSetProperty (toneUnit,
                                kAudioUnitProperty_StreamFormat,
                                kAudioUnitScope_Input,
                                0,
                                &streamFormat,
                                sizeof(AudioStreamBasicDescription));
    NSAssert1(err == noErr, @"Error setting stream format: %d", err);
}






@end
