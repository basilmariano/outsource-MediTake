//
//  MTReminderViewController.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/23/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MTReminderViewController.h"
#import "MTReminderCell.h"
#import "MTNavigationViewController.h"
#import "Medicine.h"
#import "ManageObjectModel.h"

@interface MTReminderViewController ()

@property(nonatomic,retain) NSMutableArray *reminderList;

@end

@implementation MTReminderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName =[[XCDeviceManager manager] xibNameForDevice:@"MTReminderViewController"];

    self = [super initWithNibName:nibName bundle:nil];
    if (self) {
        // Custom initialization
        _reminderList = [[NSMutableArray alloc] init];
        self.navigationItem.title = @"Reminder";
    }
    return self;
}

- (void) dealloc
{
    [_tableView release];
    [_fetchedResultsController release];
    [super dealloc];
}

#pragma mark  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*id  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];*/
   return self.reminderList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /*NSInteger count = [[_fetchedResultsController sections] count];
     NSLog(@"Sections %d",count);
     return count;*/
    return 1; //<- just for the mean time
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"MTReminderCell";
    
    MTReminderCell *tbCell = (MTReminderCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tbCell == nil) {
        
        tbCell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
        
    }
    
    if(!self.reminderList.count)
        return tbCell;
    
    NSDictionary *dict = [self.reminderList objectAtIndex:indexPath.row];
    NSDate *fireDate = [dict objectForKey:@"fireDate"];
    Medicine *med = (Medicine *) [dict objectForKey:@"Medicine"];
    tbCell.takerName.text = med.medicineTaker.name;
    tbCell.medicineName.text = med.medicineName;
    tbCell.scheduleStatus.text = med.status;
    //tbCell.takenTime.text = takenTime;
    tbCell.medicineQuantity.text = [med.quantity stringValue];
    tbCell.medicineUnit.text = med.unit;
    tbCell.medicineImage.image = med.image;
    tbCell.TakerImage.image = med.medicineTaker.image;
    //tbCell.alarmImage.image = [UIImage imageNamed:alarmImage];
    
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"hh:mm aa"];
    NSString *strTime = [dateFormat stringFromDate:fireDate];
    tbCell.scheduleTime.text = strTime;
    
    return tbCell;
}
/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 return  tableView;
 }*/


#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  indexPath;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Profile *profile = [_fetchedResultsController objectAtIndexPath:indexPath];
    [MTProfileManager deleteProfile:profile];
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            // [controller:_fetchedResultsController configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

- (void) fetchResultCatcher:(NSIndexPath *)a withAotherParam:(NSUInteger)b {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self retrieveNotificationList];
}

- (void)retrieveNotificationList
{
    NSArray *notifLIst = [UIApplication sharedApplication].scheduledLocalNotifications;
    NSLog(@"notif %d",notifLIst.count);
    if(self.reminderList.count)
        [self.reminderList removeAllObjects];
    
    for(UILocalNotification *notif in notifLIst) {
     
        NSDictionary *dict = notif.userInfo;
        NSArray *medPKList = (NSArray *) [dict objectForKey:@"Medicines"];
        for(NSString *pk in medPKList) {
            NSLog(@"String %@",pk);
            NSManagedObject *managedObject=[[[ManageObjectModel objectManager] managedObjectContext] objectWithID: [[[ManageObjectModel objectManager] persistentStoreCoordinator] managedObjectIDForURIRepresentation:[NSURL URLWithString:pk]]];

            Medicine *med = (Medicine *) managedObject;
            NSLog(@"Med %@",med.medicineName);
            NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  med,@"Medicine",
                                  notif.fireDate,@"fireDate",
                                   nil];
            [self.reminderList addObject:dict2];
            NSLog(@"reminderList %d",self.reminderList.count);
        }
    }
    
    [_tableView reloadData];

}

- (void) viewWillAppear:(BOOL)animated
{
    [self retrieveNotificationList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
