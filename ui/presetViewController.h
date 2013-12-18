//
//  presetViewController.h
//  ui
//
//  Created by teammate on 13/9/25.
//  Copyright (c) 2013年 teammate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "recordViewController.h"

@interface ViewController:UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    //三個textField
    IBOutlet UITextField *quartercount;
    IBOutlet UITextField *quartertime;
    NSArray *news;
    NSMutableData *data;
   
}
//@property (nonatomic,retain)recordViewController *recordData;
@property (strong,nonatomic) IBOutlet UITextField *quartercount;
@property (strong,nonatomic) IBOutlet UITextField *quartertime;

@property (weak, nonatomic) IBOutlet UINavigationItem *headtitle;
@property (weak, nonatomic) IBOutlet UIPickerView *pickopp;
//@property (strong, nonatomic)NSString *connectoincase;
@property (strong,nonatomic)NSURLConnection *congetallteam;
@property (strong,nonatomic)NSURLConnection *congetteammember;
- (IBAction)startgame:(id)sender;

- (IBAction)quarternumber:(id)sender;
- (IBAction)onequartertime:(id)sender;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@property(nonatomic,strong)NSArray *teamname;
//@property (nonatomic,strong) NSMutableArray *allteamname;
@property (nonatomic,strong) NSString *teamname1;
//- (IBAction)comfirm:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *oppname;

@property (strong,nonatomic)NSString *oneteam;
@property (strong,nonatomic)NSMutableArray *allteam;
@end
