//
//  MTProfileCell.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/3/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MTProfileCell.h"

@implementation MTProfileCell


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
    UIImageView *selBGView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BrownCellBG.png"]] autorelease];
    self.selectedBackgroundView = selBGView;
}

@end
