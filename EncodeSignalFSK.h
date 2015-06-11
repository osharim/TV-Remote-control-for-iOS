//
//  iR Control
//
//  Created by Omar & Alejandro .   @osharim
//  Copyright (c) 2015 Bentel Mexico. All rights reserved.
//  www.bentel.mx

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface EncodeSignalFSK : NSObject{
    
    
    AudioComponentInstance toneUnit;
    double* dataQueue;
    double* PulseToSendInSignal;
    unsigned long qSteps;
    unsigned long qIndex;
    int status;
    int interval;
    
    
    
}

//Protocolo a enviar
@property (strong,nonatomic)   NSString *Protocol;

//KeyValue - Tecla a enviar
@property (strong,nonatomic)  NSString *KeyValue;



/* Summary:   Una ves configurado el protocolo y la tecla a enviar se puede enviar el codigo. */
 
- (void)SendDataToEmiter;

 
 /* Summary:   Obtiene el protocolo y la tecla oprimida que se require enviar. */

- (void)SetProtocol:(NSString*)protocol AndSetKeyPressed:(NSString*)keyPressed;


@end


