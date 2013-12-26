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
    NSLog(@"%@",connectioncase);
    AppDelegate *appdeleget=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *mail=[[NSString alloc]initWithFormat:@"%@",appdeleget.useremail ];
    //NSString *Xvar=[[NSString alloc]initWithFormat:@"0"];
    //NSString *Xtable=[[NSString alloc]initWithFormat:@"USER"];
    //NSString *Xtarget=[[NSString alloc]initWithFormat:@"email"];
    //NSString *Xid=[[NSString alloc]initWithFormat:@"%@",mail];
    //NSString *Xadd=[[NSString alloc]initWithFormat:@"?"];
    /*
     Select * from USER as u, BASKET_PLAYER as p WHERE p.userID = u.userID AND u.email=''
    */
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
    news=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //NSLog(@"user=%@",[[news valueForKey:@"name"]componentsJoinedByString:@""]);
    username.text=[NSString stringWithFormat:@"姓名：%@",[[news valueForKey:@"name"]componentsJoinedByString:@""]];
    //NSLog(@"%@",[[news valueForKey:@"userHeight"]componentsJoinedByString:@""]);
    userweight.text=[NSString stringWithFormat:@"體重：%@KG",[[news valueForKey:@"userWeight"]componentsJoinedByString:@""]];

    userheight.text=[NSString stringWithFormat:@"身高：%@CM",[[news valueForKey:@"userHeight"]componentsJoinedByString:@""]];
    //NSLog(@"school=%@", userposition.text=[NSString stringWithFormat:@"%@",[[news valueForKey:@"userschool"]componentsJoinedByString:@""]]);
    
    //get user ID
    AppDelegate *appdeleget=[[UIApplication sharedApplication]delegate];
    appdeleget.userID=[[news valueForKey:@"userID"]componentsJoinedByString:@""];
    NSLog(@"appdelegetID=%@",appdeleget.userID);
    
    NSURL *url=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://140.112.107.77/images/%@.jpg",appdeleget.userID]];
    NSData *mydata=[NSData dataWithContentsOfURL:url];
    userphoto.image=[UIImage imageWithData:mydata];
    NSLog(@"teamID=%@",[[news valueForKey:@"teamID"]componentsJoinedByString:@""]);
    appdeleget.teamID=[NSString stringWithFormat:@"%@",[[news valueForKey:@"teamID"]componentsJoinedByString:@""]];
    //connectioncase=@"2";
    // get team ID
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
