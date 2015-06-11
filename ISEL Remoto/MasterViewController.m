//
//  iR Control
//
//  Created by Omar & Alejandro .   @osharim
//  Copyright (c) 2015 Bentel Mexico. All rights reserved.
//  www.bentel.mx

#import "MasterViewController.h"



@interface MasterViewController ()

@end

@implementation MasterViewController

//Not necesary.
//@synthesize RemoteControl = _RemoteControl;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //SET BACKGROUND IMAGE TO VIEW CONTAINER BUTTONS
    
    UIColor *ImageBackground = [ [UIColor alloc] initWithPatternImage: [UIImage imageNamed:@"container.png"]];
    self.UIViewContainerButtons.backgroundColor = ImageBackground;
    
    
    
    // INIT OBJECT  EncodeDataIntoFSK
    
    _RemoteControl = [ [RemoteControl alloc] init];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
    BOTON
 
    @id : POWER
 
*/

- (IBAction)ChannelUp:(id)sender {
   // 1.- channel +
    [_RemoteControl SendSignalWithProtocol:@"009" AndKeyPressed:@"1"];

    
}

- (IBAction)ChannelDown:(id)sender {
    
    
   // 2.- channel -
    [_RemoteControl SendSignalWithProtocol:@"009" AndKeyPressed:@"2"];
    
}



- (IBAction)Power:(id)sender {
    [_RemoteControl SendSignalWithProtocol:@"009" AndKeyPressed:@"0"];
}
@end
