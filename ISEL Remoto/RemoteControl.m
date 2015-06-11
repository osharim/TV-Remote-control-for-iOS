//
//  iR Control
//
//  Created by Omar & Alejandro .   @osharim
//  Copyright (c) 2015 Bentel Mexico. All rights reserved.
//  www.bentel.mx

#import "RemoteControl.h"

@implementation RemoteControl


- (id)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"Init iR Control");
        _EncodeDataIntoSignal = [ [EncodeSignalFSK alloc] init ];
    
    }
    return self;
}


/*
 
 @summary:  Obtiene el protocolo y la tecla oprimida del protocolo seleccionado.
 @param:    protocol    Codigo del protocolo siguiendo los estanares.001~N
 @param:    KeyPressed  Codigo de la tecla oprimida, para cada protocolo o modelo diferentes asignaciones.
 */

- (void)SendSignalWithProtocol:(NSString*)protocol AndKeyPressed:(NSString*)KeyPressed{
    
    
    //Configuramos el protocolo y tecla a enviar
    [_EncodeDataIntoSignal SetProtocol:protocol AndSetKeyPressed:KeyPressed];
    
    //Enviamos el codigo dependiendo nuestra configuracion.
    [_EncodeDataIntoSignal SendDataToEmiter];



}

@end
