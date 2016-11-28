//
//  DeviceDetailViewController.m
//  Notique
//
//  Created by Justin Bush on 12/01/13.
//  Copyright (c) 2016 DevSec LTD. All rights reserved.
//

#import "DeviceDetailViewController.h"
#import <Social/Social.h>

@interface DeviceDetailViewController (Private)

- (void)observeKeyboard;
- (void)ignoreKeyboard;
- (void)showActionSheet:(id)sender;

@end

@interface DeviceDetailViewController ()

@end

@implementation DeviceDetailViewController

@synthesize previewController;
@synthesize url;

#define VERTICAL_KEYRBOARD_MARGIN 4.0f

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self observeKeyboard];
    
    self.nameTextField.delegate = self;
    
    // Check for first launch
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch2"]) {
        
        NSLog(@"Second launch, display tutorial 2");
        
        [PXAlertView showAlertWithTitle:@"Setting a Title"
                                message:@"First things first, let's give your document a name. You can easily do this by tapping the title. Try it now!"
                            cancelTitle:@"Alright"
                             otherTitle:nil
                            contentView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tip-Title.png"]]
                             completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             }];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch2"];
    }
    
    [_nameTextField setFont:[UIFont fontWithName:@"Raleway" size:20]];
    [_companyTextField setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18]];
    
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    if (self.device) {
        [self.nameTextField setText:[self.device valueForKey:@"name"]];
        [self.versionTextField setText:[self.device valueForKey:@"version"]];
        [self.companyTextField setText:[self.device valueForKey:@"company"]];
        
        [self.companyTextField setDelegate:self];
        self.companyTextField.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self ignoreKeyboard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (self.device) {
        // update existing device
        [self.device setValue:self.nameTextField.text forKey:@"name"];
        [self.device setValue:self.versionTextField.text forKey:@"version"];
        [self.device setValue:self.companyTextField.text forKey:@"company"];
        [self.device setValue:[NSDate date] forKey:@"date"];
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Saved"
                                                       description:@"Your file has been saved."
                                                              type:TWMessageBarMessageTypeSuccess];
    } else {
        // Create a new managed object
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:context];
        [newDevice setValue:self.nameTextField.text forKey:@"name"];
        [newDevice setValue:self.versionTextField.text forKey:@"version"];
        [newDevice setValue:self.companyTextField.text forKey:@"company"];
        [newDevice setValue:[NSDate date] forKey:@"date"];
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Saved"
                                                       description:@"Your file has been saved."
                                                              type:TWMessageBarMessageTypeSuccess];
    }
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Error"
                                                       description:@"There was an error with saving you file."
                                                              type:TWMessageBarMessageTypeError];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textViewDidBeginEditing:(UITextView	*)companyTextField {
    // Hide Status Bar & Navigation Bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[self navigationController] setToolbarHidden:YES animated:YES];
    
    // Check for first launch
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch3"]) {
        
        NSLog(@"Third launch, display tutorial 3");
        
        [PXAlertView showAlertWithTitle:@"Gesture Control"
                                message:@"Upon editing a document, you will find yourself in a full screen editor. To dismiss yourself from full screen, simply swipe down on the page and the navigation bar will reappear."
                            cancelTitle:@"Okay"
                             otherTitle:nil
                            contentView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SwipeDownDiagram.png"]]
                             completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             }];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch3"];
    }
}

- (void)textViewDidEndEditing:(UITextView *)companyTextField {
    // Show Status Bar & Navigation Bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[self navigationController] setToolbarHidden:NO animated:YES];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch4"]) {
        
        NSLog(@"Fourth launch, display tutorial 4");
        
        [PXAlertView showAlertWithTitle:@"Saving"
                                message:@"Finally, lets save your document. Tap the save icon to save it to the cloud! Alternatively you can tap the X icon, this will disregard all changes made to the document."
                            cancelTitle:@"Stop Annoying Me"
                             otherTitle:nil
                            contentView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tip-Save.png"]]
                             completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             }];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch4"];
    }
}

- (BOOL)textView:(UITextView *)companyTextField shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [companyTextField scrollRangeToVisible:range];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark -
#pragma mark Keyboard Handling

- (void)observeKeyboard {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)ignoreKeyboard {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardDidShow:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbRect = [[self view] convertRect:kbRect fromView:nil];
    CGSize kbSize = kbRect.size;
    CGRect aRect = self.view.frame;
    
    /* This should work, but doesn't quite qet the job done */
    //    UIEdgeInsets insets = self.textView.contentInset;
    //    insets.bottom = kbSize.height;
    //    self.textView.contentInset = insets;
    //
    //    insets = self.textView.scrollIndicatorInsets;
    //    insets.bottom = kbSize.height;
    //    self.textView.scrollIndicatorInsets = insets;
    
    /* Instead, we just adjust the frame of the uitextview */
    
    
    aRect.size.height -= kbSize.height+ VERTICAL_KEYRBOARD_MARGIN;
    self.companyTextField.frame = aRect;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    if (!CGRectContainsPoint(aRect, self.companyTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.companyTextField.frame.origin.y - kbSize.height);
        [self.companyTextField setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    NSDictionary* info = [aNotification userInfo];
    
    /* If you're following the docs, this is how to reset the contentInsets adjusted when keyboard was shown */
    // reset the content insets to restore the text view's content area to its proper size
    //    UIEdgeInsets contentInsets = self.textView.contentInset;
    //    contentInsets.bottom = 0;
    //    self.textView.contentInset = contentInsets;
    //    self.textView.scrollIndicatorInsets = contentInsets;
    
    /* Instead, we restore the original size of the textView frame */
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbRect = [[self view] convertRect:kbRect fromView:nil];
    CGSize kbSize = kbRect.size;
    CGRect frame = self.companyTextField.frame;
    frame.size.height += kbSize.height + VERTICAL_KEYRBOARD_MARGIN;
    self.companyTextField.frame = frame;
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showActionSheet:(id)sender {
    
    NSArray *activityItems;
    activityItems = @[_companyTextField.text];
    
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc]
     initWithActivityItems:activityItems
     applicationActivities:nil];
    
    [self presentViewController:activityController
                       animated:YES completion:nil];
}

// Alternative Custom Action Sheet
/*
- (IBAction)showActionSheet:(id)sender {
 
 NSString *actionSheetTitle = @"Share via";
 NSString *other1 = @"Email...";
 NSString *other2 = @"Twitter...";
 NSString *other3 = @"Message...";
 NSString *other4 = @"Facebook...";
 NSString *other5 = @"Email (as attachment)...";
 NSString *cancelTitle = @"Cancel";
 
 UIActionSheet *actionSheet = [[UIActionSheet alloc]
 initWithTitle:actionSheetTitle
 delegate:self
 cancelButtonTitle:cancelTitle
 destructiveButtonTitle:nil
 otherButtonTitles:other1, other2, other3, other4, other5, nil];
 
 [actionSheet showInView:self.view];
 
}
 
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
 
    // Email Document
    if ([buttonTitle isEqualToString:@"Other Button 1"]) {
        NSLog(@"Email Document");
        
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            [picker setSubject:_nameTextField.text];
            [picker setMessageBody:_companyTextField.text isHTML:NO];
            [self presentViewController:picker animated:YES completion:nil];
        }
        else
        {
            [PXAlertView showAlertWithTitle:@"Email Failed"
                                    message:@"Unable to share this file. Make sure you've got an active internet connection."
                                cancelTitle:@"Dismiss"
                                 otherTitle:nil
                                contentView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MailAlert.png"]]
                                 completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                 }];
        }
    }
    
    if ([buttonTitle isEqualToString:@"Other Button 2"]) {
        NSLog(@"Tweet Document");
        
        // Tweet Document
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:_companyTextField.text];
            [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    
    if ([buttonTitle isEqualToString:@"Other Button 3"]) {
        NSLog(@"Message Document");
        
        // Message Document
        if(![MFMessageComposeViewController canSendText]) {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            return;
        }
        NSString *message = [NSString stringWithFormat:_companyTextField.text];
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        [messageController setBody:message];
        // Present message view controller on screen
        [self presentViewController:messageController animated:YES completion:nil];
    }
    
    if ([buttonTitle isEqualToString:@"Other Button 4"]) {
        NSLog(@"Facebook Document");
        
        // Facebook Document
        SLComposeViewController *composeController = [SLComposeViewController
                                                      composeViewControllerForServiceType:SLServiceTypeFacebook];
        [composeController setInitialText:_companyTextField.text];
        [self presentViewController:composeController
                           animated:YES completion:nil];
    }
    
    if ([buttonTitle isEqualToString:@"Other Button 5"]) {
        NSLog(@"Email Document as Attachment");
    
        // Email Document as Attachment
        if ([buttonTitle isEqualToString:@"Cancel Button"]) {
            NSLog(@"Cancel pressed --> Cancel ActionSheet");
            if ([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
                picker.mailComposeDelegate = self;
                [picker setSubject:_nameTextField.text];
                [picker setMessageBody:@"See attachment." isHTML:NO];
            
                NSString *emailBody = self->_companyTextField.text;
                NSData * fileData = [emailBody dataUsingEncoding:NSUTF8StringEncoding];
                NSString * fileName = self.nameTextField.text.length > 0 ? self.nameTextField.text : @"Untitled.txt";
                [picker addAttachmentData:fileData mimeType:@"text/txt" fileName:fileName];
            
                [self presentViewController:picker animated:YES completion:nil];
            }
            else
            {
                [PXAlertView showAlertWithTitle:@"Email Failed"
                                        message:@"Unable to share this file. Make sure you've got an active internet connection."
                                    cancelTitle:@"Dismiss"
                                     otherTitle:nil
                                    contentView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MailAlert.png"]]
                                     completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                     }];
                }
            }
        }
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
 */

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
