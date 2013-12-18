//
//  playerViewController.h
//  ui
//
//  Created by teammate on 13/7/26.
//  Copyright (c) 2013年 teammate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
//#import "AppDelegate.h"

@interface playerViewController : UIViewController{
    
    NSArray *news;
    NSMutableData *data;
    
}
@property (strong, nonatomic) IBOutlet UIView *playerpage;
- (IBAction)logoutaction:(id)sender;
- (IBAction)showlog:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userheight;
@property (weak, nonatomic) IBOutlet UILabel *userweight;
@property (weak, nonatomic) IBOutlet UILabel *usergrade;
@property (weak, nonatomic) IBOutlet UILabel *userposition;
@property (weak, nonatomic) IBOutlet UIImageView *userphoto;
@property (strong, nonatomic)NSString *connectioncase;

@end
