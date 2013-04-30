//
//  MTReminderCell.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/3/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCAsyncImageView.h"

@interface MTReminderCell : UITableViewCell

@property(nonatomic,assign) IBOutlet UILabel *takerName;
@property(nonatomic,assign) IBOutlet UILabel *medicineName;
@property(nonatomic,assign) IBOutlet UILabel *scheduleTime;
@property(nonatomic,assign) IBOutlet UILabel *scheduleStatus;
@property(nonatomic,assign) IBOutlet UILabel *takenTime;
@property(nonatomic,assign) IBOutlet UILabel *medicineQuantity;
@property(nonatomic,assign) IBOutlet UILabel *medicineUnit;
@property(nonatomic,assign) IBOutlet UILabel *scheduleDate;
@property(nonatomic,assign) IBOutlet PCAsyncImageView *medicineImage;
@property(nonatomic,assign) IBOutlet PCAsyncImageView *TakerImage;
@property(nonatomic,assign) IBOutlet UIImageView *alarmImage;

@end
