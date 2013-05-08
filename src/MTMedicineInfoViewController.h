//
//  MTMedicineInfoViewController.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/16/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTMedicineInfoViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, retain) Medicine *medicine;

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UIButton *medicineImage;
@property (nonatomic,retain) IBOutlet UITextField *medicineName;
@property (nonatomic,retain) IBOutlet UISwitch *switcher;
+(MTMedicineInfoViewController *)sharedInstance;
-(NSMutableArray *)medicineTimeList;
-(NSMutableArray *)medicineDayList;

@end
