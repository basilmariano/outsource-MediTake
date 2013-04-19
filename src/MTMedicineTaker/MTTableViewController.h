//
//  MTTableViewController.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/4/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTTableViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (id)initWithTableViewName:(NSString *)name andEntityName:(NSString *)entityName andSectionNumber: (int) sectionCount;
@end
