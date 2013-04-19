//
//  MTFrequencyDatesViewController.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/19/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTFrequencyDatesViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) IBOutlet UIView *frequencyWeekView;
@property(nonatomic,retain) IBOutlet UIButton *buttonDone;
@property(nonatomic,retain) IBOutlet UISwitch *switcher;
- (IBAction)onButtonDoneClicked:(id)sender;
- (IBAction)weekFrequencySwitcher:(id)sender;
- (id)initWithFrequencyDayName:(NSString *)frequencyName;
@end
