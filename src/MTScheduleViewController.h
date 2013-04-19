//
//  MTScheduleViewController.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/18/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTScheduleViewController : UIViewController <UITabBarDelegate,UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UIButton *buttonFrequency;
@property (nonatomic, retain) IBOutlet UIButton *buttonFrequencyDay;
@property (nonatomic, retain) IBOutlet UIButton *buttonAddTime;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *labelFrequencyValue;
@property (nonatomic, retain) IBOutlet UILabel *labelFrequencyDayValue;
@property (nonatomic, retain) IBOutlet UILabel *labelFrequencyDayTitle;
@property (nonatomic,retain) NSMutableArray *dayList;

+(MTScheduleViewController *) scheduleController;
@end
