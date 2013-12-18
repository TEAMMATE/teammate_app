//
//  logViewController.m
//  ui
//
//  Created by teammate on 13/12/7.
//  Copyright (c) 2013年 teammate. All rights reserved.
//

#import "logViewController.h"
#import <FacebookSDK/FacebookSDK.h>



@interface logViewController ()

@end

@implementation logViewController

@synthesize spinner;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)performLogin:(id)sender {
    [self.spinner startAnimating];
    AppDelegate *appdelegat =[UIApplication sharedApplication].delegate;
    [appdelegat openSession];
}
-(void)login:(id)sender{
    
}
-(void)signupsql:(id)sender{
    
}
- (void)loginFailed
{
    [self.spinner stopAnimating];
}

@end
