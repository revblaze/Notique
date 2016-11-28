//
//  DeviceViewController.m
//  Notique
//
//  Created by Justin Bush on 12/01/13.
//  Copyright (c) 2016 DevSec LTD. All rights reserved.
//

#import "DeviceViewController.h"
#import "AppDelegate.h"

@interface DeviceViewController ()

@property (strong) NSMutableArray *devices;

@end

@interface DeviceViewController () {
    UIView *rootView;
}

@end

@implementation DeviceViewController

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
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // Check for first launch
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch1"]) {
        
        NSLog(@"First launch, display tutorial 1");
        
        [PXAlertView showAlertWithTitle:@"Creating a Document"
                                message:@"Ready to create your first document? Click the add button to get started."
                            cancelTitle:@"Got it"
                             otherTitle:nil
                            contentView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tip-Add.png"]]
                             completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             }];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch1"];
    }
    
    /*
    // using self.navigationController.view - to display EAIntroView above navigation back
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[self navigationController] setToolbarHidden:NO animated:YES];
    
    // Check for first launch
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hasSeenTutorial"]) {
        
        NSLog(@"First launch, display tutorial");
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // Display intro view for iPad
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasSeenTutorial"];
        }
        else {
            // Display intro view for iPhone
            [self performSegueWithIdentifier: @"IntroView" sender: self];
        }
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    */
    
    // Register for database notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(databaseRestartNotification:) name:SADatabaseRestartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(databaseUpdateNotification:) name:SADatabaseUpdateNotification object:nil];
}

#pragma mark - Notifications

- (void)databaseRestartNotification:(NSNotification *)notification
{
    NSLog(@"User switched iCloud support");
    NSLog(@"PLEASE UPDATE YOUR UI");
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
    NSSortDescriptor * dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:@[dateDescriptor]];
    self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
    
    [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Sync in Progress"
                                                   description:@"Connecting to iCloud..."
                                                          type:TWMessageBarMessageTypeInfo];
}

- (void)databaseUpdateNotification:(NSNotification *)notification
{
    NSLog(@"New data from iCloud");
    NSLog(@"PLEASE UPDATE YOUR UI");
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
    NSSortDescriptor * dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:@[dateDescriptor]];
    self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
    NSSortDescriptor * dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:@[dateDescriptor]];
    self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[self navigationController] setToolbarHidden:NO animated:YES];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSManagedObject *device = [self.devices objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [device valueForKey:@"name"]]];
    cell.textLabel.font=[UIFont fontWithName:@"Raleway" size:18];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSDate * date = [device valueForKey:@"date"];
    NSString * lastEditedString = [NSString stringWithFormat:@"Last edited: %@", [dateFormatter stringFromDate:date]];
    [cell.detailTextLabel setText:lastEditedString];
    
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.imageView.image = [UIImage imageNamed:@"NotiqueFile"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [context deleteObject:[self.devices objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove device from table view
        [self.devices removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"UpdateDevice" sender:self];
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

/* Launch Intro
-(IBAction)goTest:(id)sender {
    [self performSegueWithIdentifier:@"IntroView" sender:self];
}
 */

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"UpdateDevice"]) {
        NSManagedObject *selectedDevice = [self.devices objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        DeviceDetailViewController *destViewController = segue.destinationViewController;
        destViewController.device = selectedDevice;
    }
    
    if ([[segue identifier] isEqualToString:@"IntroView"])
    {
        IntroViewController *introViewController = (IntroViewController*)[segue destinationViewController];
    }

}

@end
