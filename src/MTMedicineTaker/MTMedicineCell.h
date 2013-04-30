//
//  MTMedicineCell.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/19/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCAsyncImageView.h"

@interface MTMedicineCell : UITableViewCell

@property (nonatomic,retain) IBOutlet PCAsyncImageView *medicineImage;
@property (nonatomic,retain) IBOutlet UILabel *medicineName;
@property (nonatomic,retain) IBOutlet UILabel *quantity;
@property (nonatomic,retain) IBOutlet UILabel *unit;
@property (nonatomic,retain) IBOutlet UILabel *frequency;
@property (nonatomic,retain) IBOutlet UILabel *scheduleTime;

@end
