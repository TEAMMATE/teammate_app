//
//  resettimeViewController.m
//  ui
//
//  Created by teammate on 13/9/26.
//  Copyright (c) 2013年 teammate. All rights reserved.
//

#import "resettimeViewController.h"

@interface resettimeViewController ()

@end

@implementation resettimeViewController
@synthesize minremaintextfield;
@synthesize secremaintextfield;


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



- (IBAction)minremain:(id)sender {
    [self textFieldShouldReturn:minremaintextfield];
}

- (IBAction)secondremain:(id)sender {
    [self textFieldShouldReturn:secremaintextfield];
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == minremaintextfield) {
        [textField resignFirstResponder];
        [secremaintextfield becomeFirstResponder];
    }
    else if (textField==secremaintextfield){
        [textField resignFirstResponder];
    }return YES;
}


- (IBAction)backgame:(id)sender {
    recordViewController *record =[self.storyboard instantiateViewControllerWithIdentifier:@"recordview"];
    record.quarterlong =(([self.minremaintextfield.text intValue]*60) +[self.secremaintextfield.text intValue]);
    record.awayname =record.awayname;
    record.quartercount =record.quartercount;
    
    [self presentViewController:record animated:YES completion:nil];
}

- (IBAction)cancelgame:(id)sender {
    recordViewController *record= [self.storyboard instantiateViewControllerWithIdentifier:@"recordview"];
    int time=*(self.originalremaintime);
    record.quarterlong = (time % 60);
    [self presentViewController:record animated:YES completion:nil];
}

@end
