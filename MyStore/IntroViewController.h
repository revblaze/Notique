//
//  IntroViewController.h
//  Notique
//
//  Created by Justin Bush on 1/8/2014.
//  Copyright (c) 2016 DevSec LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"

@class DeviceViewController;
@class AppDelegate;

@interface IntroViewController : UIViewController <EAIntroDelegate>

@property (nonatomic, retain) DeviceViewController *deviceViewController;
@property (weak, nonatomic) IBOutlet UIImageView *logScreen;

@end
