//
//  iR Control
//
//  Created by Omar & Alejandro .   @osharim
//  Copyright (c) 2015 Bentel Mexico. All rights reserved.
//  www.bentel.mx

#import <UIKit/UIKit.h>
#import "RemoteControl.h"


@interface MasterViewController : UITableViewController

@property (nonatomic,retain) RemoteControl *RemoteControl;

@property (weak, nonatomic) IBOutlet UIView *UIViewContainerButtons;

- (IBAction)ChannelUp:(id)sender;
- (IBAction)ChannelDown:(id)sender;
- (IBAction)Power:(id)sender;

@end
