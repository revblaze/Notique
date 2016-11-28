//
//  AppDelegate.h
//  Notique
//
//  Created by Justin Bush on 12/01/13.
//  Copyright (c) 2016 DevSec LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TWMessageBarManager/TWMessageBarManager.h>

// This notification is fired when the database is updated from iCloud
extern NSString * const SADatabaseUpdateNotification;

// Fires when user switches iCloud support On/Off
extern NSString * const SADatabaseRestartNotification;

// Setting for iCloud Enable/Disable switch
extern NSString * const kSettingsiCloudEnabledKey;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

// Reloads local database if user changes iCloud settings
- (void)restartDatabase;


@end
