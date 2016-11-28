//
//  DeviceDetailViewController.h
//  Notique
//
//  Created by Justin Bush on 12/01/13.
//  Copyright (c) 2016 DevSec LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "PXAlertView.h">
#import <MessageUI/MessageUI.h>
#import <TWMessageBarManager/TWMessageBarManager.h>

@class PreviewViewController;
@class ProductViewController;

@interface DeviceDetailViewController : UIViewController <UITextViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate, MFMessageComposeViewControllerDelegate> {
    IBOutlet UIBarButtonItem *shareButton;

}

@property (nonatomic, retain) PreviewViewController *previewController;
@property (nonatomic, copy) NSString *url;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *versionTextField;
@property (weak, nonatomic) IBOutlet UITextView *companyTextField;
@property (strong) NSManagedObject *device;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
