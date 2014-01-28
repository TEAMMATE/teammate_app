//
//  uploadCell.m
//  ui
//
//  Created by SengChia ching on 2014/1/28.
//  Copyright (c) 2014年 teammate. All rights reserved.
//

#import "uploadCell.h"

@implementation uploadCell
@synthesize date=_date;
@synthesize vsopp=_vsopp;
@synthesize scoreratio=_scoreratio;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
