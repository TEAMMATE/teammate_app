//
//  ViewController.h
//  testtableselect
//
//  Created by teammate on 13/10/3.
//  Copyright (c) 2013年 teammate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PlayerCell.h"
#import "recordViewController.h"
@interface SelectPlayerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>{
    NSMutableArray *playerselected;
    //checkpeople is the variable to check 5 starting people.
    int checkpeople;
    NSMutableArray *player;
    NSMutableArray *playerposition;
    NSMutableArray *playerphoto;
    NSMutableArray *playernumber;
    }

@property (nonatomic,strong)NSString *oppname;
@property int quartercount;
@property int quarterlong;
@property int myteamscoer;
@property int oppteamscore;
@property int quarternow;
@property int lasttime;
@property (nonatomic,strong)NSString *nowquarter;
@property (nonatomic,strong)NSMutableArray *playerID;

@property (nonatomic, strong)NSMutableArray *teammatedata;
@property (nonatomic, strong)NSDictionary *playerInfo;
@property (nonatomic, strong)NSString *oppteamID;


- (IBAction)gotorecordpage:(id)sender;
/*
-(void)getteammmember{
    
}
*/

@end
