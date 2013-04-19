//
//  MTProfileInfoViewController.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/15/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTProfileInfoViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *profileName;
@property (nonatomic, retain) IBOutlet UIButton *profileImage;
@property (nonatomic, retain) IBOutlet UIButton *addmedicine;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

-(IBAction)editProfilePicture:(id)sender;
-(IBAction)addMedicine:(id)sender;
- (id)initWithProfileName: (NSString *)profileName;

@end
