//
//  IntroViewController.m
//  Notique
//
//  Created by Justin Bush on 1/8/2014.
//  Copyright (c) 2016 DevSec LTD. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self showIntro];
    // Only allow portrait (standard behaviour)
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasSeenTutorial"];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startApp:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showIntro {
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Welcome";
    page1.desc = @"Code Master 3 for iOS 7";
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    page1.titleImage = [UIImage imageNamed:@"title1"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"iCloud Support";
    page2.desc = @"iCloud has been enabled for you to sync your files across all of your devices. You can disable it in the manage section.";
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    page2.titleImage = [UIImage imageNamed:@"title2"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"Preview";
    page3.desc = @"Working with HTML5? Preview your dedicated web-based files in the fully functional web browser.";
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    page3.titleImage = [UIImage imageNamed:@"title3"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"";
    page4.desc = @"And much more to come - swipe to continue.";
    page4.bgImage = [UIImage imageNamed:@"bg4"];
//  page4.titleImage = [UIImage imageNamed:@"title4"];
    [self animate];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
    [intro setDelegate:self];
    
    [intro showInView:self.view animateDuration:0.3];

}

-(void)animate {
    [UIView animateWithDuration:60.0f delay:0.0 options:UIViewAnimationTransitionNone animations:
     ^{
         //Move the image view to 100, 100 over 10 seconds.
         _logScreen.frame = CGRectMake(0.0f, -243.0f, _logScreen.frame.size.width, _logScreen.frame.size.height);
     }
                     completion:^(BOOL finished){if (finished){
    
    [UIView animateWithDuration:10 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _logScreen.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);}
                     completion:NULL];}}];}


@end
