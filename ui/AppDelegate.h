//
//  AppDelegate.h
//  ui
//
//  Created by teammate on 13/6/28.
//  Copyright (c) 2013年 teammate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "recordViewController.h"
#import "presetViewController.h"
#import "logViewController.h"
#import "playerViewController.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSInteger mycount;
    NSArray *news;
    NSMutableData *data;
}
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong,nonatomic)UINavigationController *navController;
@property (strong,nonatomic)playerViewController *mainViewController;
@property (strong,nonatomic)UIStoryboard *mainstoryboard;


@property (strong,nonatomic)NSString *useremail;
@property (strong,nonatomic)NSString *username;
@property (strong,nonatomic)NSString *userheight;
@property (strong,nonatomic)NSString *userweight;
@property (strong,nonatomic)NSString *teamID;
@property (strong,nonatomic)NSString *userID;


@property(strong,nonatomic)NSMutableArray *teammember;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void) openSession;

@end
