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

//@property (nonatomic,retain) IBOutlet PCAsyncImageView *medicineImage;
@property (nonatomic, assign) IBOutlet UILabel *medicineName;
@property (nonatomic, assign) IBOutlet UILabel *quantity;
@property (nonatomic, assign) IBOutlet UILabel *unit;
@property (nonatomic, assign) IBOutlet UILabel *frequency;
@property (nonatomic, assign) IBOutlet UILabel *scheduleTime;
@property (nonatomic, assign) IBOutlet UIImageView *medicineImageView;

@end
