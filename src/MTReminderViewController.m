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
#import "MTLocalNotification.h"
#import "PCImageDirectorySaver.h"
#import "Time.h"
#import "MTWebViewController.h"

@interface MTReminderViewController () <UIActionSheetDelegate>
{
    int selectedIndexPathRow;
}
@property (nonatomic, retain) NSMutableArray *reminderList;
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
    return 1; //<- just for the mean time
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"MTReminderCell";
    
    MTReminderCell *tbCell = (MTReminderCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tbCell == nil) {
        
        tbCell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
        
    }
    
    NSDictionary *dict          = [self.reminderList objectAtIndex:indexPath.row];
    UILocalNotification *notif  = [dict objectForKey:@"notification"];
    NSDate *fireDate            = notif.fireDate;
    Medicine *med               = (Medicine *) [dict objectForKey:@"Medicine"];
    
    tbCell.takerName.text           = med.medicineTaker.name;
    tbCell.medicineName.text        = med.medicineName;
    tbCell.medicineQuantity.text    = [med.quantity stringValue];
    tbCell.medicineUnit.text        = med.unit;
    tbCell.medicineImageView.image  = [[PCImageDirectorySaver directorySaver]imageFilePath:med.medicineImagePath];//profile.image;
    tbCell.profileImageView.image   = [[PCImageDirectorySaver directorySaver]imageFilePath:med.medicineTaker.profileImagePath];
    //[tbCell.medicineImage loadImageFromURL:[NSURL URLWithString:med.medicineImagePath]];
    //[tbCell.TakerImage loadImageFromURL:[NSURL URLWithString:med.medicineTaker.profileImagePath]];
    //tbCell.alarmImage.image = [UIImage imageNamed:alarmImage];
    //tbCell.takenTime.text = takenTime;
    
    NSString *status = nil;
    NSArray *arrTime = [NSArray arrayWithArray:[med.times allObjects]];
    for(Time *time in arrTime) {
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time.time doubleValue]]; //<- retrieve the date
        NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
        dateFormat.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormat setDateFormat:@"hh:mm aa"];
        NSString *strTime = [dateFormat stringFromDate:date];
        
        NSDateFormatter *fireDateFormat = [[[NSDateFormatter alloc] init] autorelease];
        [fireDateFormat setDateFormat:@"hh:mm aa"];
        NSString *strFireTime = [fireDateFormat stringFromDate:fireDate];
        
        if([strFireTime isEqualToString:strTime]) {
            status = time.status;
        }
    }
    
    if(status) {
        tbCell.scheduleStatus.text = status;
    }
    
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"hh:mm aa"];
    NSString *strTime = [dateFormat stringFromDate:fireDate];
    tbCell.scheduleTime.text = strTime;
    
    NSDateFormatter *dateFormat2 = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat2 setDateFormat:@"MM/dd/yy"];
    NSString *strDate= [dateFormat2 stringFromDate:fireDate];
    tbCell.scheduleDate.text = strDate;

    return tbCell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndexPathRow = indexPath.row;
    NSString *medicineCurrentStatus = nil;
    NSDictionary *dict = [self.reminderList objectAtIndex:selectedIndexPathRow];
    UILocalNotification *notif = [dict objectForKey:@"notification"];
    NSDate *fireDate = notif.fireDate;
    Medicine *med = (Medicine *) [dict objectForKey:@"Medicine"];
    NSArray *arrTime = [NSArray arrayWithArray:[med.times allObjects]];
    
    for(Time *time in arrTime) {
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time.time doubleValue]]; //<- retrieve the date
        NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
        dateFormat.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormat setDateFormat:@"hh:mm aa"];
        NSString *strTime = [dateFormat stringFromDate:date];
        
        NSDateFormatter *fireDateFormat = [[[NSDateFormatter alloc] init] autorelease];
        //fireDateFormat.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [fireDateFormat setDateFormat:@"hh:mm aa"];
        NSString *strFireTime = [fireDateFormat stringFromDate:fireDate];
       
        if([strFireTime isEqualToString:strTime]) {
            
            NSArray *stringList = [time.status componentsSeparatedByString:@" "];
            medicineCurrentStatus = (NSString *) [stringList objectAtIndex:0];
            break;
        }
    }
    BOOL disableFirst2Buttons = NO;
    if([medicineCurrentStatus isEqualToString:@"Skip"] || [medicineCurrentStatus isEqualToString:@"Taken"]) {
        disableFirst2Buttons = YES;
    }
    
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:nil] autorelease];
    
    [actionSheet addButtonWithTitle:@"Take Now"];
    [actionSheet addButtonWithTitle:@"Skip Now"];
    [actionSheet addButtonWithTitle:@"View Details"];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    
    if(disableFirst2Buttons) {
        NSUInteger buttonIndex = 0;
    for (UIView* view in actionSheet.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            if (buttonIndex == 0 || buttonIndex == 1) {
                UIButton* button = (UIButton*)view;
                button.enabled = NO;
            }
            buttonIndex++;
        }
    }
    }
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
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
    NSDictionary *dict = [self.reminderList objectAtIndex:indexPath.row];
    UILocalNotification *notif = [dict objectForKey:@"notification"];
    Medicine *med = (Medicine *) [dict objectForKey:@"Medicine"];
    [[MTLocalNotification sharedInstance] deleteNotificationWithMedicine:med fromNotification:notif];
    [self retrieveNotificationList];
    [_tableView reloadData];
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

#pragma mark UIActionSheelDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 2) {

        NSDictionary *dict = [self.reminderList objectAtIndex:selectedIndexPathRow];
        //UILocalNotification *notif = [dict objectForKey:@"notification"];
        Medicine *med = (Medicine *) [dict objectForKey:@"Medicine"];
        MTWebViewController *webViewController = [[[MTWebViewController alloc] initWithSearchString:med.medicineName]autorelease];
        [self.navigationController pushViewController:webViewController animated:YES];        
       
        return;
    } else if(buttonIndex == 3) {
        return;
    }
    
    NSDictionary *dict = [self.reminderList objectAtIndex:selectedIndexPathRow];
    UILocalNotification *notif = [dict objectForKey:@"notification"];
    NSDate *fireDate = notif.fireDate;
    Medicine *med = (Medicine *) [dict objectForKey:@"Medicine"];
    NSArray *arrTime = [NSArray arrayWithArray:[med.times allObjects]];
    
    for(Time *time in arrTime) {
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time.time doubleValue]]; //<- retrieve the date
        NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
        dateFormat.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormat setDateFormat:@"hh:mm aa"];
        NSString *strTime = [dateFormat stringFromDate:date];
        
        NSDateFormatter *fireDateFormat = [[[NSDateFormatter alloc] init] autorelease];
        //fireDateFormat.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [fireDateFormat setDateFormat:@"hh:mm aa"];
        NSString *strFireTime = [fireDateFormat stringFromDate:fireDate];
       
        if([strFireTime isEqualToString:strTime]) {
            NSDate *current = [NSDate date];
            NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormat setDateFormat:@"MM/dd/yy hh:mm aa"];
            NSString *strTime = [dateFormat stringFromDate:current];
            
            Time *time2 = [Time time];
            time2.time = time.time;
           
            if(buttonIndex == 0) {
                time2.status = [NSString stringWithFormat:@"Taken at %@",strTime];
            } else if (buttonIndex == 1) {
                time2.status = [NSString stringWithFormat:@"Skip at %@",strTime];
            }
        
            NSManagedObject *object = time;
            [[ManageObjectModel objectManager] deleteObject:object];
            
            [med addTimesObject:time2];
            [[ManageObjectModel objectManager] saveContext];
            break;
        }
    }
    [_tableView reloadData];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self retrieveNotificationList];
}

- (void) retrieveNotificationList
{
    NSArray *notifLIst = [UIApplication sharedApplication].scheduledLocalNotifications;
    NSLog(@"notif count %d",notifLIst.count);
    if(self.reminderList.count) {
        [self.reminderList removeAllObjects];
    }
    if(!notifLIst.count) {
        [_tableView reloadData];
        return;
    }
    
    for(UILocalNotification *notif in notifLIst) {
        
        NSArray *medList = [Medicine medicineList];
        NSString *PKHolder = nil;
        for(Medicine *meds in medList) {
            NSDictionary *dict = notif.userInfo;
            NSArray *medPKList = (NSArray *) [dict objectForKey:@"Medicines"];
            for(NSString *pk in medPKList) {
                NSManagedObject *object = meds;
                NSString *strPK = [[[object objectID] URIRepresentation] absoluteString];
                if([strPK isEqualToString:pk]) {
                    PKHolder = strPK;
                }
            }
        }
        
        if(!PKHolder) {
            [[UIApplication sharedApplication] cancelLocalNotification:notif];
        } else {
            
            NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
            NSDate *now = [NSDate date];
            NSDateComponents *compsNow  = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | kCFCalendarUnitWeekday fromDate:now];
            NSDateComponents *compsFire = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | kCFCalendarUnitWeekday  fromDate:notif.fireDate];
            NSDate *current             = [calendar dateFromComponents:compsNow];
            NSDate *fDate               = [calendar dateFromComponents:compsFire];
            
            if(notif.repeatInterval == NSWeekCalendarUnit) {
                if(compsNow.weekday == compsFire.weekday) {
                    [self saveNotifInfoToReminderListWithNotif:notif];
                }
            } else if (notif.repeatInterval == NSDayCalendarUnit) {
                if(compsNow.day == compsFire.day) {
                    [self saveNotifInfoToReminderListWithNotif:notif];
                }
            } else {
                if([current isEqualToDate:fDate]) {
                    [self saveNotifInfoToReminderListWithNotif:notif];
                }
            }
        }
    }
    
    [self syncReminders];
}

- (void) saveNotifInfoToReminderListWithNotif:(UILocalNotification *)notif
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *compsNow  = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | kCFCalendarUnitWeekday | kCFCalendarUnitHour | kCFCalendarUnitMinute fromDate:now];
    NSDateComponents *compsFire = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | kCFCalendarUnitWeekday | kCFCalendarUnitHour | kCFCalendarUnitMinute fromDate:notif.fireDate];
    
    NSInteger currentTimeInSecs = compsNow.hour*3600 + compsNow.minute*60 + compsNow.second;
    NSInteger fireTimeInSecs    = compsFire.hour*3600 + compsFire.minute*60  + compsFire.second;
    
    if(currentTimeInSecs >= fireTimeInSecs)
        return;
    
    NSDictionary *dict = notif.userInfo;
    NSArray *medPKList = (NSArray *) [dict objectForKey:@"Medicines"];
    for(NSString *pk in medPKList) {
        //get object using primary key
        NSManagedObject *managedObject=[[[ManageObjectModel objectManager] managedObjectContext] objectWithID: [[[ManageObjectModel objectManager] persistentStoreCoordinator] managedObjectIDForURIRepresentation:[NSURL URLWithString:pk]]];
        
        Medicine *medicine = (Medicine *) managedObject;
        NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:
                               medicine,@"Medicine",
                               notif,@"notification",
                               nil];
        
        //prevent duplicated notification info in reminder
        Medicine *newMedicine = nil;
        for(NSDictionary *remDIct in self.reminderList) {
            Medicine *remMed  = [remDIct objectForKey:@"Medicine"];
            UILocalNotification *remNotif = [remDIct objectForKey:@"notification"];
            
            NSDate *remDate = remNotif.fireDate;
            NSDate *newRemDate = notif.fireDate;
            
            NSString *newMedicineTakerName = medicine.medicineTaker.name;
            NSString *remMedicineTakerName = remMed.medicineTaker.name;
            
            if([remMedicineTakerName isEqualToString:newMedicineTakerName] && [remMed.medicineName isEqualToString:medicine.medicineName] && [remDate isEqualToDate:newRemDate]) {
                newMedicine = remMed;
            }
        }
       /*
        NSDateFormatter *fireDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [fireDateFormatter setDateFormat:@"MM/dd/yy"];
        NSString *strfireDate = [fireDateFormatter stringFromDate:notif.fireDate];
        NSDate *fireDate = [fireDateFormatter dateFromString:strfireDate];
        NSNumber *secsInfireDate = [NSNumber numberWithDouble:[fireDate timeIntervalSince1970]];
        
        NSArray *timeList = [medicine.times allObjects];
        for(Time *time in timeList) {
            
             NSArray *stringFields = [time.status componentsSeparatedByString:@" "];
            NSString *currentStatus = (NSString *)[stringFields objectAtIndex:0];
            if([currentStatus isEqualToString:@"Taken"] || [currentStatus isEqualToString:@"Skip"]) {
                NSString *lastDateStatusUpdated = (NSString *)[stringFields objectAtIndex:2];
                NSDateFormatter *fireDateFormatter2 = [[[NSDateFormatter alloc] init] autorelease];
                [fireDateFormatter2 setDateFormat:@"MM/dd/yy"];
                NSDate *lastDateUpdated = [fireDateFormatter dateFromString:lastDateStatusUpdated];
                NSNumber *secsInlastDateUpdated = [NSNumber numberWithDouble:[lastDateUpdated timeIntervalSince1970]];
                NSLog(@"Time.status %@",time.status);
                if(secsInlastDateUpdated < secsInfireDate) {//<-change the time status
                    Time *newTime = [Time time];
                    newMedicine.status = medicine.status;
                    newTime.time = time.time;
                    [medicine addTimesObject:newTime];
                    
                    NSManagedObject *object = time;
                    [[ManageObjectModel objectManager] deleteObject:object];
                    [[ManageObjectModel objectManager] saveContext];
                    NSLog(@"Medicine.status %@",medicine.status);
                    NSLog(@"Time.status %@",newTime.status);
                    break;
                }
            }
        }
        
        // get the date for firedate MM/dd/yy
        // get idx 2 of time.status MM/dd/yy <- this is lower, change the time.status to med.status*/
        if(!newMedicine)
            [self.reminderList addObject:dict2];
    }
}

- (void) syncReminders
{
    NSMutableArray *reminderListHandler = [NSMutableArray arrayWithArray:self.reminderList];
    if(!reminderListHandler.count) {
        [_tableView reloadData];
        return;
    }
    
    for(int x = 0; x < reminderListHandler.count-1; x++) {
        NSDictionary *dict = self.reminderList[x];
        NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
        UILocalNotification *notif1 = [dict objectForKey:@"notification"];
        NSDate *fireDate = notif1.fireDate;
        NSDateComponents *compsFire = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | kCFCalendarUnitWeekday | kCFCalendarUnitHour | kCFCalendarUnitMinute fromDate:fireDate];
        NSInteger dateInSecs = compsFire.hour*3600 + compsFire.minute*60 + compsFire.second;
        
        int nexyIdx = x;
        nexyIdx++;
        
        NSDictionary *dict2 = self.reminderList[nexyIdx];
        UILocalNotification *notif2 = [dict2 objectForKey:@"notification"];
        NSDate *fireDate2 = notif2.fireDate;
        NSDateComponents *compsFire2 = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | kCFCalendarUnitWeekday | kCFCalendarUnitHour | kCFCalendarUnitMinute fromDate:fireDate2];
        NSInteger dateInSecs2 = compsFire2.hour*3600 + compsFire2.minute*60 + compsFire2.second;
        
        NSDictionary *tempHandler = nil;
        
        if(dateInSecs > dateInSecs2) {
            tempHandler = dict2;
            [self.reminderList insertObject:dict2 atIndex:x];
            [self.reminderList insertObject:dict atIndex:nexyIdx];
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
