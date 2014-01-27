//
//  playerViewController.m
//  ui
//
//  Created by teammate on 13/7/26.
//  Copyright (c) 2013年 teammate. All rights reserved.
//

#import "playerViewController.h"
#import "AppDelegate.h"
//#import "presetViewController.h"
@interface playerViewController ()

@end



@implementation playerViewController

@synthesize usergrade;
@synthesize userheight;
@synthesize username;
@synthesize userposition;
@synthesize userweight;
@synthesize userphoto;
@synthesize connectioncase;
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
   // [self POSTTOUBUNTO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Logout"
                                              style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(logoutButtonWasPressed:)];
    AppDelegate *appdeleget=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSLog(@"loginemail=%@",appdeleget.useremail);
    NSDate *myDate=[NSDate new];
    NSDateFormatter *df=[NSDateFormatter new];
    [df setDateFormat:@"yyMMdd"];
    NSLog(@"date=%@",[df stringFromDate:myDate]);

    
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:appdeleget.managedObjectContext];
    [fetch setEntity:entity];
    NSArray *array =[appdeleget.managedObjectContext executeFetchRequest:fetch error:nil];
    
    if ([array count]==0) {
        NSLog(@"array is nil");
    }else{
        for (NSManagedObject *obj in array) {
            username.text=[NSString stringWithFormat:@"姓名：%@",[obj valueForKey:@"userName"]];
            userweight.text=[NSString stringWithFormat:@"體重：%@KG",[obj valueForKey:@"weight"]];
            userheight.text=[NSString stringWithFormat:@"身高：%@CM",[obj valueForKey:@"height"]];
        }
    }
    //load exist user image
    userphoto.image=[self loadimage];
    

    
	// Do any additional setup after loading the view.
 
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutaction:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (IBAction)showlog:(id)sender {
    //AppDelegate *appdeleget=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    //NSString *mail=[[NSString alloc ]initWithFormat:@"%@",appdeleget.useremail];
    NSLog(@"playerview=%@",[[news valueForKey:@"userID"]componentsJoinedByString:@""]);

    
    [self POSTTOUBUNTO];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://teammate.cc/cgi/applogin.php?userID=%@",[[news valueForKey:@"userID"]componentsJoinedByString:@""]]]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self POSTTOUBUNTO];

}


- (void) POSTTOUBUNTO{
    connectioncase=@"1";
    AppDelegate *appdeleget=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *mail=[[NSString alloc]initWithFormat:@"%@",appdeleget.useremail ];
    
    NSString * post = [[NSString alloc] initWithFormat:@"var=2&table=USER as u, BASKET_PLAYER as p WHERE p.userID = u.userID AND u.email='%@'",mail];
    
    NSData * postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSString * postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://140.112.107.77/cgi/xcode_retrive.php?"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (conn) NSLog(@"Connection1 Successful");
    //[self getteammember];
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
//    NSManagedObject *userinfo=[NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext]
    

    news=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    
    //save coredata userinfo
    AppDelegate *appdelegat =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *enty=[NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:appdelegat.managedObjectContext];
    NSFetchRequest *fetch =[[NSFetchRequest alloc]init];
    [fetch setEntity:enty];
    NSMutableArray *array=[[appdelegat.managedObjectContext executeFetchRequest:fetch error:nil]mutableCopy];
    if ([array count]!=0) {
        NSLog(@"array is not empty");
    }//array is empty
    else
    {
        int i=1;
        for (NSManagedObject *obj in array) {
            NSLog(@"%@,%@",[obj valueForKey:@"height"],[NSNumber numberWithInt:i]);
            i=i+1;
        }
        NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:appdelegat.managedObjectContext];
    
        [entity setValue:[[news valueForKey:@"name"]componentsJoinedByString:@""] forKey:@"userName"];
    
        int weight=[[[news valueForKey:@"userWeight"]componentsJoinedByString:@""]intValue];
        int Height=[[[news valueForKey:@"userHeight"]componentsJoinedByString:@""]intValue];
    
        [entity setValue:[NSNumber numberWithInt:weight] forKey:@"weight"];
        [entity setValue:[NSNumber numberWithInt:Height] forKey:@"Height"];
    
        NSError *error;
        BOOL isSaved =[appdelegat.managedObjectContext save:&error];
        NSLog(@"successful add event %d",isSaved);
    }
    for (NSManagedObject *obj in array){
    username.text=[NSString stringWithFormat:@"姓名：%@",[obj valueForKey:@"userName"]];
    userweight.text=[NSString stringWithFormat:@"體重：%@KG",[obj valueForKey:@"weight"]];
    userheight.text=[NSString stringWithFormat:@"身高：%@CM",[obj valueForKey:@"height"]];
    }
    //get user ID
    AppDelegate *appdeleget=[[UIApplication sharedApplication]delegate];
    appdeleget.userID=[[news valueForKey:@"userID"]componentsJoinedByString:@""];
    NSLog(@"appdelegetID=%@",appdeleget.userID);
    //get photo
    NSURL *url=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://140.112.107.77/images/%@.jpg",appdeleget.userID]];
    NSData *mydata=[NSData dataWithContentsOfURL:url];
    if ([UIImage imageWithData:mydata]!=nil) {
        [self saveImage:[UIImage imageWithData:mydata]];
        NSLog(@"yes");
    }
    
    
    NSLog(@"teamID=%@",[[news valueForKey:@"teamID"]componentsJoinedByString:@""]);
    appdeleget.teamID=[NSString stringWithFormat:@"%@",[[news valueForKey:@"teamID"]componentsJoinedByString:@""]];
    //connectioncase=@"2";
    // get team ID
}
-(void)saveImage:(UIImage *)image
{
    if (image!=nil) {
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory=[paths objectAtIndex:0];
        NSString *path=[documentsDirectory stringByAppendingPathComponent:@"user.jpg"];
        NSData *data=UIImageJPEGRepresentation(image, 0);
        [data writeToFile:path atomically:YES];
    }
}

-(UIImage *)loadimage
{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *ducmentsDirectory =[paths objectAtIndex:0];
    NSString *path=[ducmentsDirectory stringByAppendingPathComponent:@"user.jpg"];
    UIImage *image=[UIImage imageWithContentsOfFile:path];
    return image;
}


/*
-(void)getteammember{
    AppDelegate *appdeleget=(AppDelegate *)[[UIApplication sharedApplication]delegate];
 
     Select * from USER as u, BASKET_PLAYER as p WHERE p.userID = u.userID AND u.userID=30
  
    //用ＩＤ取球隊隊伍ＩＤ teamID
    NSString * post = [[NSString alloc] initWithFormat:@"var=2&table=USER as u, BASKET_PLAYER as p WHERE p.userID = u.userID AND u.userID=%@",appdeleget.userID];
    NSLog(@"getmember userID%@",appdeleget.userID);
    NSData * postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSString * postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://140.112.107.77/cgi/xcode_retrive.php?"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection * connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connect) {
        NSLog(@"Connection2 Successful");
    }
}
*/


@end
