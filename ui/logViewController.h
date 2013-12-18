//
//  logViewController.h
//  ui
//
//  Created by teammate on 13/12/7.
//  Copyright (c) 2013年 teammate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface logViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *logViewController;

@property (weak, nonatomic) IBOutlet UITextField *input_accoint;
@property (weak, nonatomic) IBOutlet UITextField *input_password;

@property (weak, nonatomic) IBOutlet UIButton *emaillogin;
@property (weak, nonatomic) IBOutlet UIButton *signin;
@property (strong, nonatomic)IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *FacebookLogin;


- (IBAction)performLogin:(id)sender;
-(void)loginFailed;
- (IBAction)login:(id)sender;

- (IBAction)signupsql:(id)sender;

@end
