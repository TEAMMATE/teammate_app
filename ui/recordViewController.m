//
//  recordViewController.m
//  ui
//
//  Created by teammate on 13/7/26.
//  Copyright (c) 2013年 teammate. All rights reserved.
//

#import "recordViewController.h"
#import <UIKit/UIKit.h>

@interface recordViewController()
{
    
}
@end

//#define quarterlong 600 // one quarter has 600 seconds in normal game.
#define TimeUnin 1 //one time minus one second

@implementation recordViewController

@synthesize quarterlong;
@synthesize quartercount;
@synthesize nowquarter;
@synthesize playernumber;
@synthesize playername;
@synthesize playerphoto;
@synthesize person1;
@synthesize person2;
@synthesize person3;
@synthesize person4;
@synthesize person5;

@synthesize myteamname;
@synthesize myteamscore;
@synthesize opteamname;
@synthesize opteamscore;
@synthesize myscore;
@synthesize oppscore;
@synthesize quarternow;
@synthesize nowTime;
@synthesize lastTime;

@synthesize oppteamID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
bool isRunning;//time clock "yes" means time is countdown, "No" means time is idle.


- (void)viewDidLoad
{
    
    onequarterlong =quarterlong;
    howmanyquarter =quartercount;
    
    opteamname.text =self.awayname;
    NSLog(@"節數：%d節  每節：%d分鐘",onequarterlong,howmanyquarter);//確定時間與節數有傳過來
    nowplayer =playername[0];
    nowplayerid=@"1";
    statusname[0]=@"GO";
    statusname[1]=@"GO";
    
    statusevent[0]=@"TEAMMATE";
    statusevent[1]=@"TEAMMATE";
    [super viewDidLoad];
    //begin with score 0
	myteamscore.text = [NSString stringWithFormat:@"%d",myscore];
    opteamscore.text = [NSString stringWithFormat:@"%d",oppscore];
    
    //lastTime =onequarterlong*60;  //one quarter long
    
    nowTime =lastTime; //nowtime是計時器的時間
    
    //quarternow =1;//第一節
    if (quarternow==1){
        nowquarter.text=@"第一節";
    }else if(quarternow==2) {
        nowquarter.text=@"第二節";
    }else if (quarternow ==3){
        nowquarter.text=@"第三節";
    }else if (quarternow ==4){
        nowquarter.text=@"第四節";
    }else if (quarternow>4 && (myscore==[opteamscore.text intValue])){
        nowquarter.text=@"延長賽";
    }

    
    [self showNowTime];
    
    countreset = -1;//resetcount is used to change initial time
    isRunning=NO;

    [person1 setImage:[UIImage imageNamed:playerphoto[0]] forState:UIControlStateNormal];
    [person2 setImage:[UIImage imageNamed:playerphoto[1]] forState:UIControlStateNormal];
    [person3 setImage:[UIImage imageNamed:playerphoto[2]] forState:UIControlStateNormal];
    [person4 setImage:[UIImage imageNamed:playerphoto[3]] forState:UIControlStateNormal];
    [person5 setImage:[UIImage imageNamed:playerphoto[4]] forState:UIControlStateNormal];
    
    
  /*  NSArray *keyvalue =[NSArray arrayWithObjects:@"gameDate",@"home",@"awayID",@"awayname", nil];
    NSArray *objectvalue =[NSArray arrayWithObjects:@"130701",@"1",@"2",@"台大電機", nil];
    NSDictionary *gameinfo =[NSDictionary dictionaryWithObjects:objectvalue forKeys:keyvalue];
    NSData *jsonk =[[CJSONSerializer serializer]serializeDictionary:gameinfo error:nil];
    NSString *jsons =[[NSString alloc]initWithData:jsonk encoding:NSUTF8StringEncoding];
    
    basicinfo = jsons;
    NSLog(@"%@",basicinfo);
    */
   //update =[[NSMutableArray alloc]init];
    //[update addObject:jsons];

    NSLog(@"oppteamID%@",oppteamID);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// time managementment
-(IBAction)startpause:(UIButton *)sender{
    if (isRunning == NO) {
        isRunning = YES;
        [self init_timer];
        [buttonstartpause setTitle:@"暫停" forState:UIControlStateNormal];
    }else{
        isRunning = NO;
        lastTime=nowTime;
        [Ctimer invalidate];
        Ctimer =nil;
        [buttonstartpause setTitle:@"繼續" forState:UIControlStateNormal];
    }
}
-(void) showNowTime{
    min = nowTime/60;
    sec = (nowTime - min*60);
    timer.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
}
-(void) init_timer{
    nowTime =lastTime;
    Ctimer =[NSTimer scheduledTimerWithTimeInterval:TimeUnin target:self selector:@selector(GameTimer_Count) userInfo:nil repeats:YES];
}
-(void) GameTimer_Count{
    if (nowTime >0) {
        nowTime--;
        [self showNowTime];
        eventtime =(onequarterlong*60-nowTime)+onequarterlong*60*(quarternow-1);
        NSLog(@"%d",eventtime);
    }
    else{
        isRunning=NO;
        [Ctimer invalidate];
        Ctimer=nil;
        nowTime = onequarterlong*60;
        [self showNowTime];
        [buttonstartpause setTitle:@"開始" forState:UIControlStateNormal];

        quarternow++;
        if (quarternow==2) {
            nowquarter.text=@"第二節";
        }else if (quarternow ==3){
            nowquarter.text=@"第三節";
        }else if (quarternow ==4){
            nowquarter.text=@"第四節";
        }else if (quarternow>4 && (myscore==[opteamscore.text intValue])){
            nowquarter.text=@"延長賽";
        }
    }
}

-(IBAction)reset:(UIButton *)sender{
    //countreset++;
    lastTime =onequarterlong*60;// -(countreset % 10)*60;
    [Ctimer invalidate];
    Ctimer =nil;
    isRunning =NO;
    nowTime =onequarterlong*60;// -(countreset % 10)*60;
    [self showNowTime];
}

-(void)updatestatus{
    for (int i=1; i<10; i++) {
        statusevent[10-i]=statusevent[9-i];
        statusname[10-i]=statusname[9-i];
    }
    statusevent[0]=nowevent;
    statusname[0]=nowplayer;
    
    status.text = [NSString stringWithFormat:@"1. %6@ %6@\n2. %6@ %6@\n3. %6@ %6@\n",statusname[0] , statusevent[0],statusname[1], statusevent[1],statusname[2], statusevent[2]];
}

//IBaction about my team score
- (IBAction)twoptmade:(UIButton *)sender{
    myscore=myscore+2;
    myteamscore.text = [NSString stringWithFormat: @"%d",myscore];
    nowevent =@"2ptmade";
    
    AppDelegate *appdelegat =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:appdelegat.managedObjectContext];
    [entity setValue:nowplayerid forKey:@"name"];
    [entity setValue:nowevent forKey:@"event"];
    [entity setValue:[NSNumber numberWithInt:eventtime] forKey:@"time"];
    NSEntityDescription *entity2 =[NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:appdelegat.managedObjectContext];
    [entity2 setValue:nowplayerid forKey:@"name"];
    [entity2 setValue:@"2ptattempt" forKey:@"event"];
    [entity2 setValue:[NSNumber numberWithInt:eventtime] forKey:@"time"];
    
    NSError *error;
    BOOL isSaved =[appdelegat.managedObjectContext save:&error];
    NSLog(@"successful add event %d",isSaved);
    
    
    // add status
    [self updatestatus];
    
}
- (IBAction)twoptmiss:(UIButton *)sender{
    nowevent =@"2ptmiss";
    
    AppDelegate *appdelegat =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:appdelegat.managedObjectContext];
    [entity setValue:nowplayerid forKey:@"name"];
    [entity setValue:@"2ptattempt" forKey:@"event"];
    [entity setValue:[NSNumber numberWithInt:eventtime] forKey:@"time"];
    NSError *error;
    BOOL isSaved =[appdelegat.managedObjectContext save:&error];
    NSLog(@"successful add event %d",isSaved);
    
    [self updatestatus];
    
    
}
- (IBAction)threeptmade:(UIButton *)sender{
    nowevent =@"3pt made";
    myscore=myscore+3;
    myteamscore.text = [NSString stringWithFormat: @"%d",myscore];
    AppDelegate *appdelegat =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:appdelegat.managedObjectContext];
    [entity setValue:nowplayerid forKey:@"name"];
    [entity setValue:@"3ptmade" forKey:@"event"];
    [entity setValue:[NSNumber numberWithInt:eventtime] forKey:@"time"];
    NSEntityDescription *entity2 =[NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:appdelegat.managedObjectContext];
    [entity2 setValue:nowplayerid forKey:@"name"];
    [entity2 setValue:@"3ptattempt" forKey:@"event"];
    [entity2 setValue:[NSNumber numberWithInt:eventtime] forKey:@"time"];
    
    NSError *error;
    BOOL isSaved =[appdelegat.managedObjectContext save:&error];
    NSLog(@"successful add event %d",isSaved);
    
    [self  updatestatus];
}
- (IBAction)threeptmiss:(UIButton *)sender{
    nowevent =@"3pt miss";
    AppDelegate *appdelegat =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:appdelegat.managedObjectContext];
    [entity setValue:nowplayerid forKey:@"name"];
    [entity setValue:@"3ptattempt" forKey:@"event"];
    [entity setValue:[NSNumber numberWithInt:eventtime] forKey:@"time"];
    NSError *error;
    BOOL isSaved =[appdelegat.managedObjectContext save:&error];
    NSLog(@"successful add event %d",isSaved);
    
    [self updatestatus];
    
}
- (IBAction)oneptmade:(UIButton *)sender{
    nowevent =@"1pt-made";
    myscore=myscore+1;
    myteamscore.text = [NSString stringWithFormat: @"%d",myscore];
    
    AppDelegate *appdelegat =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:appdelegat.managedObjectContext];
    [entity setValue:nowplayerid forKey:@"name"];
    [entity setValue:@"1ptmade" forKey:@"event"];
    [entity setValue:[NSNumber numberWithInt:eventtime] forKey:@"time"];
    NSEntityDescription *entity2 =[NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:appdelegat.managedObjectContext];
    [entity2 setValue:nowplayerid forKey:@"name"];
    [entity2 setValue:@"1ptattempt" forKey:@"event"];
    [entity2 setValue:[NSNumber numberWithInt:eventtime] forKey:@"time"];
    
    NSError *error;
    BOOL isSaved =[appdelegat.managedObjectContext save:&error];
    NSLog(@"successful add event %d",isSaved);
    
    [self updatestatus];
}

- (IBAction)oneptmiss:(UIButton *)sender{
    nowevent =@"1pt-miss";
    AppDelegate *appdelegat =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:appdelegat.managedObjectContext];
    [entity setValue:nowplayerid forKey:@"name"];
    [entity setValue:@"1ptattempt" forKey:@"event"];
    [entity setValue:[NSNumber numberWithInt:eventtime] forKey:@"time"];
    NSError *error;
    BOOL isSaved =[appdelegat.managedObjectContext save:&error];
    NSLog(@"successful add event %d",isSaved);

    [self updatestatus];
}

- (IBAction)steal:(UIButton *)sender;
{
    nowevent =@"steal";
    
    AppDelegate *appdelegat =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:appdelegat.managedObjectContext];
    [entity setValue:nowplayerid forKey:@"name"];
    [entity setValue:@"steal" forKey:@"event"];
    [entity setValue:[NSNumber numberWithInt:eventtime] forKey:@"time"];
    NSError *error;
    BOOL isSaved =[appdelegat.managedObjectContext save:&error];
    NSLog(@"successful add event %d",isSaved);

    [self updatestatus];
}
- (IBAction)turnover:(UIButton *)sender{
    nowevent = @"turnover";
    
    AppDelegate *appdelegat =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:appdelegat.managedObjectContext];
    [entity setValue:nowplayerid forKey:@"name"];
    [entity setValue:@"turnover" forKey:@"event"];
    [entity setValue:[NSNumber numberWithInt:eventtime] forKey:@"time"];
    NSError *error;
    BOOL isSaved =[appdelegat.managedObjectContext save:&error];
    NSLog(@"successful add event %d",isSaved);
    
    [self updatestatus];
}
- (IBAction)block:(UIButton *)sender{
    nowevent =@"Block";
    
    AppDelegate *appdelegat =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:appdelegat.managedObjectContext];
    [entity setValue:nowplayerid forKey:@"name"];
    [entity setValue:@"block" forKey:@"event"];
    [entity setValue:[NSNumber numberWithInt:eventtime] forKey:@"time"];
    NSError *error;
    BOOL isSaved =[appdelegat.managedObjectContext save:&error];
    NSLog(@"successful add event %d",isSaved);
    
    [self updatestatus];
}
- (IBAction)fuol:(UIButton *)sender{
    nowevent=@"Foul";
    
    AppDelegate *appdelegat =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:appdelegat.managedObjectContext];
    [entity setValue:nowplayerid forKey:@"name"];
    [entity setValue:@"foul" forKey:@"event"];
    [entity setValue:[NSNumber numberWithInt:eventtime] forKey:@"time"];
    NSError *error;
    BOOL isSaved =[appdelegat.managedObjectContext save:&error];
    NSLog(@"successful add event %d",isSaved);

    [self updatestatus];
}

- (IBAction)assist:(UIButton *)sender{
    nowevent =@"Assist";
    AppDelegate *appdelegat =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:appdelegat.managedObjectContext];
    [entity setValue:nowplayerid forKey:@"name"];
    [entity setValue:@"assist" forKey:@"event"];
    [entity setValue:[NSNumber numberWithInt:eventtime] forKey:@"time"];
    NSError *error;
    BOOL isSaved =[appdelegat.managedObjectContext save:&error];
    NSLog(@"successful add event %d",isSaved);

    [self updatestatus];
}
- (IBAction)offreb:(UIButton *)sender{
    nowevent =@"Off-REB";
    AppDelegate *appdelegat =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:appdelegat.managedObjectContext];
    [entity setValue:nowplayerid forKey:@"name"];
    [entity setValue:@"offreb" forKey:@"event"];
    [entity setValue:[NSNumber numberWithInt:eventtime] forKey:@"time"];
    NSError *error;
    BOOL isSaved =[appdelegat.managedObjectContext save:&error];
    NSLog(@"successful add event %d",isSaved);

    [self updatestatus];
}
- (IBAction)defreb:(UIButton *)sender{
    nowevent =@"Def-REB";
    
    AppDelegate *appdelegat =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:appdelegat.managedObjectContext];
    [entity setValue:nowplayer forKey:@"name"];
    [entity setValue:@"defreb" forKey:@"event"];
    [entity setValue:[NSNumber numberWithInt:eventtime] forKey:@"time"];
    NSError *error;
    BOOL isSaved =[appdelegat.managedObjectContext save:&error];
    NSLog(@"successful add event %d",isSaved);

    [self updatestatus];
}



- (IBAction)laststep:(UIButton *)sender{
    for (int i=0; i<9; i++) {
        statusname[i]=statusname[i+1];
        statusevent[i]=statusevent[i+1];
    }
    statusevent[9]=nil;
    statusname[9]=nil;
    
    status.text = [NSString stringWithFormat:@"1. %6@ %6@\n2. %6@ %6@\n3. %6@ %6@\n",statusname[0] , statusevent[0],statusname[1], statusevent[1],statusname[2], statusevent[2]];
    
   /* AppDelegate *appdelegat =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Record" inManagedObjectContext:nil];
    NSFetchRequest *fetchrqst =[[NSFetchRequest alloc]init];
    [fetchrqst setEntity:entity];
    appdelegat.managedObjectContext del
 */   
    
}


- (IBAction)recorddone:(UIButton *)sender{
    AppDelegate *appdelegat =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Record" inManagedObjectContext:appdelegat.managedObjectContext];
    
    NSFetchRequest *fetchrqst =[[NSFetchRequest alloc]init];
    [fetchrqst setEntity:entity];
    NSArray *array =[appdelegat.managedObjectContext executeFetchRequest:fetchrqst error:nil];
   // [fetchrqst release];
    
    //array of events
    update =[[NSMutableArray alloc]init];
   // NSMutableDictionary *recorddict=[[NSMutableDictionary alloc]init]
    for (NSManagedObject *obj in array) {
        
        NSArray *keyy = [NSArray arrayWithObjects:@"event", @"playerID", @"time", nil];
        NSArray *objectt = [NSArray arrayWithObjects:[obj valueForKey:@"event"], [obj valueForKey:@"name"],[obj valueForKey:@"time"], nil];
        NSDictionary *dictionaryy = [NSDictionary dictionaryWithObjects:objectt forKeys:keyy];
        
        //NSData *jsonk =[[CJSONSerializer serializer]serializeDictionary:dictionaryy error:nil];
        //NSString *jsons =[[NSString alloc]initWithData:jsonk encoding:NSUTF8StringEncoding];
        
       // NSLog(@"EVENTS = %@",jsons);
       // [update addObject:jsonk];
        [update addObject:dictionaryy];
    }
    
    //this part is only for check
    //NSData *jsdata =[[CJSONSerializer serializer]serializeArray:update error:nil];
    NSLog(@"Updataarray = %@",update);
    
    NSString *opscore = [NSString stringWithFormat:@"%d",oppscore];
   // NSString *mscore = [NSString stringWithFormat:@"%d",myscore];
    NSArray *keyvalue =[NSArray arrayWithObjects:@"gameDATE",@"homeID",@"awayID",@"awayName",@"records",@"awayScore_total",@"gameLocation",@"isOverTime", nil];
    NSArray *objectvalue =[NSArray arrayWithObjects:@"131219",appdelegat.teamID,oppteamID,opteamname.text, update, opscore, @"台大", @"no", nil];
    NSDictionary *gameinfo =[NSDictionary dictionaryWithObjects:objectvalue forKeys:keyvalue];
    NSLog(@"gameInfo=%@",gameinfo);
    NSData *jsonk =[[CJSONSerializer serializer]serializeDictionary:gameinfo error:nil];
    NSString *jsons =[[NSString alloc]initWithData:jsonk encoding:NSUTF8StringEncoding];
    //NSString *jsum=[jsstring stringByAppendingString:jsons];
    
    
        NSString *post =[[NSString alloc] initWithFormat:@"result=%@",jsons];
        NSLog(@"POST = %@",post);
    
    
        NSURL *url=[NSURL URLWithString:@"http://140.112.107.77/cgi/cgi_test.php"];
        
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
    
        NSError *error;
        NSURLResponse *response;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    
        NSLog(@"DATA = %@",data);
        
    
    // delete core data
    for (NSManagedObject *obj in array) {
        [appdelegat.managedObjectContext deleteObject:obj];
    }
    [appdelegat.managedObjectContext save:&error];
    
}


//playerID=[NSMutableArray arrayWithObjects:@"12",@"1",@"27",@"28",@"3",@"54",@"65",Nil];

- (IBAction)player1:(id)sender {
    nowplayer =playername[0];
    nowplayerid =@"12";
    //cell.Playerphoto.image=[UIImage imageNamed:[playerphoto objectAtIndex:indexPath.row]];
    
}
- (IBAction)player2:(id)sender {
    nowplayer =playername[1];
    nowplayerid=@"1";
}
- (IBAction)player3:(id)sender {
    nowplayer =playername[2];
    nowplayerid =@"27";
}


- (IBAction)player4:(id)sender {
    nowplayer =playername[3];
    nowplayerid=@"28";
}
- (IBAction)player5:(id)sender {
   nowplayer =playername[4];
    nowplayerid =@"3";
}




// my team and other team score
- (IBAction)opteamscoreadd:(UIButton *)sender {
    oppscore=oppscore+1;
    opteamscore.text =[NSString stringWithFormat:@"%d",oppscore];
}
- (IBAction)opteamscoresub:(UIButton *)sender {
    if (oppscore > 0) {
        oppscore=oppscore-1;
        opteamscore.text =[NSString stringWithFormat:@"%d",oppscore];
    }
}





//未來打算做這個！！

/*

- (IBAction)resettime:(id)sender {
    resettimeViewController *resetview =[self.storyboard instantiateViewControllerWithIdentifier:@"resettime"];
    resetview.originalremaintime = lastTime;
 
    [self presentViewController:resetview animated:YES completion:nil];

    
}*/

- (IBAction)fetch:(id)sender {
    AppDelegate *appdelegat =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Record" inManagedObjectContext:appdelegat.managedObjectContext];
    NSFetchRequest *fetchrqst =[[NSFetchRequest alloc]init];
    [fetchrqst setEntity:entity];
    NSMutableArray *array =[[appdelegat.managedObjectContext executeFetchRequest:fetchrqst error:nil]mutableCopy];
    for (NSManagedObject *obj in array) {
        NSLog(@"name:%@ event:%@ time:%@",[obj valueForKey:@"name"],[obj valueForKey:@"event"],[obj valueForKey:@"time"]);
        }
}

- (IBAction)deletecoredata:(id)sender {
    AppDelegate *appdelegat =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Record" inManagedObjectContext:appdelegat.managedObjectContext];
    NSFetchRequest *fetchrqst =[[NSFetchRequest alloc]init];
    [fetchrqst setEntity:entity];
    NSArray *array =[appdelegat.managedObjectContext executeFetchRequest:fetchrqst error:nil];
  //  [fetchrqst release];
    for (NSManagedObject *obj in array) {
        [appdelegat.managedObjectContext deleteObject:obj];
    }
    NSError *error;
    [appdelegat.managedObjectContext save:&error];
}


- (IBAction)changepeople:(id)sender {
    SelectPlayerViewController *select=[self.storyboard instantiateViewControllerWithIdentifier:@"selectplayerview"];
    //將三筆資料傳到下一個頁面去
    select.quarterlong=quarterlong;
//    select.quartercount=quartercount;
    select.oppname=opteamname.text;
    select.myteamscoer=myscore;
    select.oppteamscore=oppscore;
    select.quarternow=quarternow;
    select.nowquarter=[NSString stringWithFormat:@"%@",nowquarter.text];
    select.lasttime=lastTime;
    
    [self presentViewController:select animated:YES completion:nil];
    
}
@end

