//
//  MTMedicineCell.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/19/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MTMedicineCell.h"

@implementation MTMedicineCell

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

- (void) dealloc
{
    //[_medicineImage release];
   /* [_medicineImageView release];
    [_medicineName release];
    [_quantity release];
    [_unit release];
    [_frequency release];
    [_scheduleTime release];*/
    [super dealloc];
}

@end
