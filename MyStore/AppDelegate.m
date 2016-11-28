//
//  AppDelegate.m
//  Notique
//
//  Created by Justin Bush on 12/01/13.
//  Copyright (c) 2016 DevSec LTD. All rights reserved.
//

#import "AppDelegate.h"


// This notification is fired when the database is updated from the iCloud
NSString * const SADatabaseUpdateNotification = @"SADatabaseUpdateNotification";

// Get's posted when user switches iCloud support On/Off
NSString * const SADatabaseRestartNotification = @"SADatabaseRestartNotification";

// Setting for iCloud Enable/Disable switch
NSString * const kSettingsiCloudEnabledKey = @"kSettingsiCloudEnabledKey";


@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
/*
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
*/
    
    // NSShadow* shadow = [NSShadow new];
    // shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
    // shadow.shadowColor = [UIColor blackColor];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"Lobster" size:30.0f],
                                                            // NSShadowAttributeName: shadow
                                                            }];
    
    // Set default setting
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kSettingsiCloudEnabledKey]) {
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:kSettingsiCloudEnabledKey];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}






#pragma mark - Core Data Save

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}





#pragma mark - Change iCloud Status

- (void)restartDatabase
{
    // Reset context and start database from beginning
    _persistentStoreCoordinator = nil;
    _managedObjectContext = nil;
    
    [self.managedObjectContext reset];
}





#pragma mark - Core Data stack

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MyStore" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    NSURL *storeURL = [[fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
    storeURL = [storeURL URLByAppendingPathComponent:@"Code Master"];
    NSDictionary *properties = [storeURL resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] error:&error];
    if (!properties) {
        if (![fileManager createDirectoryAtPath:[storeURL path] withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"%@", error);
            return nil;
        }
    }
    
    
    NSDictionary * options;
    
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kSettingsiCloudEnabledKey] boolValue]) {
        // Store file
        storeURL = [storeURL URLByAppendingPathComponent:@"MyStoreCloud.lite"];
        
        // Store options
        options = @{NSPersistentStoreUbiquitousContentNameKey: @"Transanctions",
                    NSPersistentStoreUbiquitousContainerIdentifierKey: @"85N3S3DG8M.com.revblaze.Code-Master",
                    NSMigratePersistentStoresAutomaticallyOption: @YES,
                    NSInferMappingModelAutomaticallyOption: @YES};
        
        
    } else {
        // Store file
        storeURL = [storeURL URLByAppendingPathComponent:@"MyStore.lite"];
        
        // Store options
        options = @{NSMigratePersistentStoresAutomaticallyOption: @YES,
                    NSInferMappingModelAutomaticallyOption: @YES};
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         */
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // Register for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(persistentStoreCoordinatorWillChange:) name:NSPersistentStoreCoordinatorStoresWillChangeNotification object:_persistentStoreCoordinator];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(persistentStoreCoordinatorDidChange:) name:NSPersistentStoreCoordinatorStoresDidChangeNotification object:_persistentStoreCoordinator];
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        // Make life easier by adopting the new NSManagedObjectContext concurrency API
        // the NSMainQueueConcurrencyType is good for interacting with views and controllers since
        // they are all bound to the main thread anyway
        NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        moc.mergePolicy = [[NSMergePolicy alloc] initWithMergeType:NSMergeByPropertyObjectTrumpMergePolicyType];
        [moc setPersistentStoreCoordinator: coordinator];
        
        // Register for iCloud Changes
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mergeiCloudChanges:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:coordinator];
        
        _managedObjectContext = moc;
    }
    
    // Post Restart Notification
    dispatch_async(dispatch_get_main_queue(), ^{
        // Post notification
        [[NSNotificationCenter defaultCenter] postNotificationName:SADatabaseRestartNotification object:self.managedObjectContext userInfo:nil];
    });
    
    return _managedObjectContext;
}


- (void)mergeiCloudChanges:(NSNotification *)notification
{
    
    // NSNotifications are posted synchronously on the caller's thread
    // make sure to vector this back to the thread we want, in this case
    // the main thread for our views & controller
	__weak NSManagedObjectContext* moc = [self managedObjectContext];
    
    // this only works if you used NSMainQueueConcurrencyType
    // otherwise use a dispatch_async back to the main thread yourself
    __weak AppDelegate * weakSelf = self;
    [self.managedObjectContext performBlock:^{
        
        
        
        // this takes the NSPersistentStoreDidImportUbiquitousContentChangesNotification
        // and transforms the userInfo dictionary into something that
        // -[NSManagedObjectContext mergeChangesFromContextDidSaveNotification:] can consume
        // then it posts a custom notification to let detail views know they might want to refresh.
        [moc mergeChangesFromContextDidSaveNotification:notification];
        [moc reset];
        
        // Update UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SADatabaseUpdateNotification object:weakSelf userInfo:nil];
        });
    }];
}





#pragma mark - Asynchronous iCloud Store Handlers

- (void)persistentStoreCoordinatorWillChange:(NSNotification *)notification
{
    // Save any unsaved user changes before persistent store change
    if ([self.managedObjectContext hasChanges]) {
        [self.managedObjectContext save:nil];
    }
    [self.managedObjectContext reset];
}

- (void)persistentStoreCoordinatorDidChange:(NSNotification *)notification
{
    // Update UI
    __weak AppDelegate * weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SADatabaseUpdateNotification object:weakSelf userInfo:nil];
    });
}

#pragma mark - Background context save notification

- (void)handleBackgroundContextDidSaveNotification:(NSNotification *)note
{
    __weak AppDelegate * weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.managedObjectContext mergeChangesFromContextDidSaveNotification:note];
    });
}


@end
