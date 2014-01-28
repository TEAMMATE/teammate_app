//
//  uploadViewController.h
//  ui
//
//  Created by SengChia ching on 2014/1/28.
//  Copyright (c) 2014年 teammate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "uploadCell.h"

@interface uploadViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>
- (IBAction)backplayerview:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property(nonatomic,strong)NSMutableArray *allrecord;
@property int indexpath;
@end
