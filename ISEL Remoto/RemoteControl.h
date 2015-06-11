//
//  iR Control
//
//  Created by Omar & Alejandro .   @osharim
//  Copyright (c) 2015 Bentel Mexico. All rights reserved.
//  www.bentel.mx

#import <Foundation/Foundation.h>
#import "EncodeSignalFSK.h"

@interface RemoteControl : NSObject


@property (strong,nonatomic) EncodeSignalFSK *EncodeDataIntoSignal;



/*
    
 Summary:   Obtiene el protocolo y la tecla oprimida que se require enviar.
 
 */

- (void)SendSignalWithProtocol:(NSString*)protocol AndKeyPressed:(NSString*)KeyPressed;




@end
