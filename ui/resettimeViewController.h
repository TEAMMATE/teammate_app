//
//  resettimeViewController.h
//  ui
//
//  Created by teammate on 13/9/26.
//  Copyright (c) 2013年 teammate. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "recordViewController.h"



@interface resettimeViewController : UIViewController<UITextFieldDelegate>
{
    int originalmin;
    int originalsec;
}
@property  NSInteger *originalremaintime;

- (IBAction)minremain:(id)sender;
- (IBAction)secondremain:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *minremaintextfield;
@property (weak, nonatomic) IBOutlet UITextField *secremaintextfield;


- (IBAction)backgame:(id)sender;
- (IBAction)cancelgame:(id)sender;

@end
