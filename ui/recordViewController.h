//
//  recordViewController.h
//  ui
//
//  Created by teammate on 13/7/26.
//  Copyright (c) 2013年 teammate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "presetViewController.h"
#import "resettimeViewController.h"
#import "SelectPlayerViewController.h"
@interface recordViewController : UIViewController<NSFetchedResultsControllerDelegate >
{
       
    //last 3 player's status
    NSString *statusname[10];
    NSString *statusevent[10];
    
    //point player
    NSString *nowplayer;
    NSString *nowplayerid;
    NSString *nowevent;
    
    //game info
  //  NSString *awayname;
    int homeid;
    int gamedate;
    int awayid;
    //上傳array
    NSString *basicinfo;
    
    
    NSMutableArray *update ;
    
    IBOutlet UIView *recordpage;
    
    
    //time management UI
    IBOutlet UILabel *timer;
    NSTimer *Ctimer;
    int onequarterlong;//一節有多長
    int howmanyquarter;//總共有幾節
    int eventtime;//事件發生的時間
    
    int min;
    int sec;
    int countreset;
    IBOutlet UIButton *buttonstartpause;
    IBOutlet UIButton *buttonreset;
    //team & score
    //2 buttun name +, -,
    IBOutlet UIButton *opaddscore;
    IBOutlet UIButton *opsubscore;
    // 3 status
    IBOutlet UITextView *status;

    //15 button name
    IBOutlet UIButton *button2ptmade;
    IBOutlet UIButton *buttun2ptmiss;
    IBOutlet UIButton *button3ptmade;
    IBOutlet UIButton *buttun3ptmiss;
    IBOutlet UIButton *button1ptmade;
    IBOutlet UIButton *buttun1ptmiss;
    IBOutlet UIButton *buttonsteal;
    IBOutlet UIButton *buttunblock;
    IBOutlet UIButton *buttonturnover;
    IBOutlet UIButton *buttunfoul;
    IBOutlet UIButton *buttonassist;
    IBOutlet UIButton *buttunoffreb;
    IBOutlet UIButton *buttondefreb;
    IBOutlet UIButton *buttundelete;
    IBOutlet UIButton *buttondone;
    // photo
    
}
@property(nonatomic,strong) NSMutableArray *playername;
@property(nonatomic,strong) NSMutableArray *playernumber;
@property(nonatomic,strong) NSMutableArray *playerphoto;

    - (IBAction)changepeople:(id)sender;
@property    IBOutlet UIButton *person1;
@property    IBOutlet UIButton *person2;
@property    IBOutlet UIButton *person3;
@property    IBOutlet UIButton *person4;
@property    IBOutlet UIButton *person5;
///

@property(nonatomic,strong) IBOutlet UITextView *myteamname;
@property(nonatomic,strong) IBOutlet UITextView *myteamscore;
@property(nonatomic,strong) IBOutlet UITextView *opteamname;
@property(nonatomic,strong) IBOutlet UITextView *opteamscore;
    //my team score vs opposite team score

@property int myscore;
@property int oppscore;
@property int quarternow;//目前第幾節
@property int nowTime;
@property int lastTime;



@property (strong,nonatomic) NSString *awayname;
@property (strong,nonatomic) NSString *oppteamID;
@property  int quartercount;
@property  int quarterlong;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;



//- (IBAction)resettime:(id)sender;

- (IBAction)fetch:(id)sender;
- (IBAction)deletecoredata:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *nowquarter;

    //time management
    - (IBAction)startpause:(UIButton *)sender;
    - (IBAction)reset:(UIButton *)sender;
    
    //oppsite team score and timeout
    - (IBAction)opteamscoreadd:(UIButton *)sender;
    - (IBAction)opteamscoresub:(UIButton *)sender;

    // 15 touch up inside
    - (IBAction)twoptmade:(UIButton *)sender;
    - (IBAction)twoptmiss:(UIButton *)sender;
    - (IBAction)threeptmade:(UIButton *)sender;
    - (IBAction)threeptmiss:(UIButton *)sender;
    - (IBAction)oneptmade:(UIButton *)sender;
    - (IBAction)oneptmiss:(UIButton *)sender;
    - (IBAction)steal:(UIButton *)sender;
    - (IBAction)turnover:(UIButton *)sender;
    - (IBAction)block:(UIButton *)sender;
    - (IBAction)fuol:(UIButton *)sender;
    - (IBAction)assist:(UIButton *)sender;
    - (IBAction)offreb:(UIButton *)sender;
    - (IBAction)defreb:(UIButton *)sender;
    - (IBAction)laststep:(UIButton *)sender;
    - (IBAction)recorddone:(UIButton *)sender;
-(void)updatestatus;
   
- (IBAction)player1:(id)sender;
- (IBAction)player2:(id)sender;
- (IBAction)player3:(id)sender;
- (IBAction)player4:(id)sender;
- (IBAction)player5:(id)sender;


@end
