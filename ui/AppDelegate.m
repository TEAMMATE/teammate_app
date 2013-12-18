//
//  AppDelegate.m
//  ui
//
//  Created by teammate on 13/6/28.
//  Copyright (c) 2013年 teammate. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation AppDelegate
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize navController=_navController;
@synthesize mainViewController=_mainviewController;
@synthesize mainstoryboard=_mainstoryboard;
@synthesize teamID;
@synthesize useremail;
@synthesize userID;
@synthesize teammember;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
 //   recordViewController *controller = (recordViewController *)self.window.rootViewController;
    //playerViewController *controller=(playerViewController *)self.window.rootViewController;
   // [self.window makeKeyAndVisible];
    self.mainstoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    self.mainViewController =[self.mainstoryboard instantiateViewControllerWithIdentifier:@"intro"];

    //   recordViewController *record =[self.storyboard instantiateViewControllerWithIdentifier:@"recordview"];
    
    
    self.navController=[[UINavigationController alloc]initWithRootViewController:self.mainViewController];
    [self.navController setNavigationBarHidden:NO];
    self.window.rootViewController=self.navController;
    [self.window makeKeyAndVisible];
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        //to-do, show in view.
        [self openSession];
    }else{
        //no, display the login page.
        [self showloginView];
    }
  
    return YES;
}


-(void)showloginView
{
    UIViewController *topViewController=[self.navController topViewController];
    UIViewController *modalViewController=[topViewController modalViewController];
    
    logViewController *loginviewcontroller=[self.mainstoryboard instantiateViewControllerWithIdentifier:@"loginview"];
    
    [topViewController presentViewController:loginviewcontroller animated:NO completion:nil];
    // If the login screen is not already displayed, display it. If the login screen is
    // displayed, then getting back here means the login in progress did not successfully
    // complete. In that case, notify the login view so it can update its UI appropriately.
    if (![modalViewController isKindOfClass:[logViewController class]]) {
        logViewController *loginviewcontroller=[self.mainstoryboard instantiateViewControllerWithIdentifier:@"loginview"];
        [topViewController presentViewController:loginviewcontroller animated:NO completion:nil];
    } else {
        logViewController *loginviewcontroller=(logViewController *)modalViewController;
        [loginviewcontroller loginFailed];
    }
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

-(void)sessionStateChanged:(FBSession *)session
                     state:(FBSessionState)state
                     error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:{
                UIViewController *topViewController=[self.navController topViewController];
            
             if ([[topViewController modalViewController]
                 isKindOfClass:[logViewController class]]) {
                [topViewController dismissModalViewControllerAnimated:YES];
                 [self getinfo];
                //NSLog(@"%@ %@",user.name, [user objectforkey:@"email"]);
                //NSLog(@"User session found");
            }
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            //once the user has logged in, we want them to be looking at root view
            [self.navController popToRootViewControllerAnimated:NO];
            [FBSession.activeSession closeAndClearTokenInformation];
            [self showloginView];
            break;
        default:
            break;
    }
    if (error) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openSession
{
    NSArray *permissions=[NSArray arrayWithObjects:@"email", nil];
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
    [self getinfo];

}
-(void)getinfo{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe]startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user,NSError *error){
            if (!error) {
                    useremail=[[NSString alloc]initWithFormat:@"%@",[user objectForKey:@"email"]];
                    NSLog(@"getinfo=%@,%@,%@",user.id,user.name,useremail);
            }
        }];
    }
}

#pragma mark mysql connection

- (void) POSTTOUBUNTO{
 
    AppDelegate *appdeleget=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *mail=[[NSString alloc]initWithFormat:@"%@",appdeleget.useremail ];
    NSString *Xvar=[[NSString alloc]initWithFormat:@"0"];
    NSString *Xtable=[[NSString alloc]initWithFormat:@"USER"];
    NSString *Xtarget=[[NSString alloc]initWithFormat:@"email"];
    NSString *Xid=[[NSString alloc]initWithFormat:@"%@",mail];
    //NSString *Xadd=[[NSString alloc]initWithFormat:@"?"];
    /*
     $table = $_POST['table'];
     $add = $_POST['add'];
     $id = $_POST['id'];
     $var = $_POST['var'];
     $target = $_POST['target'];
     */
    NSString * post = [[NSString alloc] initWithFormat:@"var=%@&id=%@&target=%@&table=%@",Xvar,Xid,Xtarget,Xtable];
    NSData * postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSString * postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://140.112.107.77/cgi/xcode_retrive.php?"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (conn) NSLog(@"Connection Successful");
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    data=[[NSMutableData alloc]init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)thedata{
    [data appendData:thedata];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible= NO;
    news=[NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
    NSLog(@"user=%@",[[news valueForKey:@"name"]componentsJoinedByString:@""]);
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
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] & ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
