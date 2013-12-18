//
//  PlayerCell.m
//  testtableselect
//
//  Created by teammate on 13/10/6.
//  Copyright (c) 2013年 teammate. All rights reserved.
//

#import "PlayerCell.h"

@implementation PlayerCell

@synthesize nameLabel=_nameLabel;
@synthesize Playerphoto=_Playerphoto;
@synthesize Playerposition=_Playerposition;
//@synthesize selectedlabel=_selectedlabel;



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
