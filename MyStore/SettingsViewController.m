//
//  SettingsViewController.m
//  Notique
//
//  Created by Justin Bush on 12/01/13.
//  Copyright (c) 2016 DevSec LTD. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "PXAlertView/PXAlertView.h"

@interface SettingsViewController ()

@property (nonatomic, weak) IBOutlet UISwitch * iCloudSwitch;

@end

@implementation SettingsViewController

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
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[self navigationController] setToolbarHidden:NO animated:YES];

    // Load iCloud Enabled setting
    BOOL iCloudOn = [[[NSUserDefaults standardUserDefaults] objectForKey:kSettingsiCloudEnabledKey] boolValue];
    [self.iCloudSwitch setOn:iCloudOn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[self navigationController] setToolbarHidden:NO animated:YES];
}

#pragma mark - Actions

- (IBAction)icloudAction:(id)sender
{
    // Save iCloud Enabled Setting
    [[NSUserDefaults standardUserDefaults] setObject:@(self.iCloudSwitch.isOn) forKey:kSettingsiCloudEnabledKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Restart database
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate restartDatabase];
}

- (IBAction)question:(id)sender {
    [PXAlertView showAlertWithTitle:@"Need Assistance?"
                            message:@"An entire section dedicated to problems and issues you may be experiencing will be coming shortly."
                        cancelTitle:@"Ok"
                         otherTitle:nil
                        //contentView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SwipeDownDiagram.png"]]
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                         }];
}

@end
