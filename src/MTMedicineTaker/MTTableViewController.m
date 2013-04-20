//
//  MTTableViewController.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/4/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MTTableViewController.h"
#import "MTReminderCell.h"
#import "MTProfileCell.h"
#import "MTNavigationViewController.h"
#import "MTProfileViewController.h"
#import "Profile.h"
#import "MTProfileInfoViewController.h"

@interface MTTableViewController () <UITableViewDataSource,UITableViewDelegate>
{
    int sectionNumber;
}

@property(nonatomic,retain) NSMutableArray *list;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *entityName;

@end

@implementation MTTableViewController

- (id)initWithTableViewName:(NSString *)name andEntityName:(NSString *)entityName andSectionNumber: (int) sectionCount
{
    _list = [[NSMutableArray alloc]init];
    //default
    
    NSString *nibName =[[XCDeviceManager manager] xibNameForDevice:@"MTTableViewController"];
    self = [super initWithNibName:nibName bundle:nil];
    if (self) {
        // Custom initialization
        _name = [[NSString alloc] init];
        _name = name;
        sectionNumber = sectionCount;
        _entityName = entityName;
    
        if([name isEqualToString:@"Reminders"]) {
            
            self.title = @"Reminders";
            //
        }
        else
        {
            self.title = @"All Profile";
            UIImage *entries = [UIImage imageNamed:@"ButtonPlus.png"];
            UIButton *buttonEntries = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonEntries.frame = CGRectMake(0, 0, 26.5, 26);
            [buttonEntries setImage:entries forState:UIControlStateNormal];
            [buttonEntries addTarget:self action:@selector(onButtonAddProfileClicked) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *barButton = [[[UIBarButtonItem alloc] initWithCustomView:buttonEntries]autorelease];
            
            self.navigationItem.rightBarButtonItem = barButton;
            
        }
        
    }
    return self;
}

- (void) dealloc
{
    [_tableView release];
    [_name release];
    [_list release];
    [super dealloc];
}

- (NSFetchedResultsController *)fetchedResultsControllerwithEntityName:(NSString *)entityName andSortDescriptorName:(NSString *)sortDescriptorName andCacheName:(NSString *)cacheName {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSLog(@"EntityName and sortDescriptorName = %@, %@",entityName,sortDescriptorName);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:entityName inManagedObjectContext:[[ManageObjectModel objectManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:sortDescriptorName ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:8];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[[ManageObjectModel objectManager] managedObjectContext] sectionNameKeyPath:nil
                                                   cacheName:cacheName];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

- (void) onButtonAddProfileClicked
{
    NSString *nibName = [[XCDeviceManager manager] xibNameForDevice:@"MTProfileViewController"];
    MTProfileViewController *profileController = [[[MTProfileViewController alloc] initWithNibName:nibName bundle:nil] autorelease];
    [self.navigationController pushViewController:profileController animated:YES];
}

- (void) reminderData
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([_name isEqualToString:@"Profile"]) {
        if([Profile profileCount] == 0) {
            NSString *nibName = [[XCDeviceManager manager] xibNameForDevice:@"MTProfileViewController"];
            MTProfileViewController *profileController = [[[MTProfileViewController alloc] initWithNibName:nibName bundle:nil] autorelease];
            [self.navigationController pushViewController:profileController animated:YES];
        }
    }
    
    //execute the profileFetchedResultsController
    NSError *error = nil;
    if([_name isEqualToString:@"Profile"]) {
   
        if(![[self fetchedResultsControllerwithEntityName:@"Profile" andSortDescriptorName:@"name" andCacheName:@"profileList"] performFetch:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}


- (void) viewDidUnload
{
    self.fetchedResultsController = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([_name isEqualToString:@"Profile"]) {
        [self getProfileData];
    } else {
        //get the reminder data
        //[self getRemindersData];
    }
    
    [_tableView reloadData];
}

- (void) getProfileData
{
    [_list removeAllObjects];
    [_list addObjectsFromArray:[Profile profileList]];
}

#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /*NSInteger count = [[_fetchedResultsController sections] count];
    NSLog(@"Sections %d",count);
    return count;*/
    return sectionNumber; //<- just for the mean time
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int selecteRow = (int) indexPath.row;
    
    if([_name isEqualToString:@"Reminders"])
        return  [self reminder:tableView andRow:selecteRow];
    else
        return  [self profile:tableView andRow:indexPath];
    
}
/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return  tableView;
}*/


#pragma UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"BASIL");
    if([_name isEqualToString:@"Profile"]) {
        Profile *profile = [_fetchedResultsController objectAtIndexPath:indexPath];
        MTProfileInfoViewController *profileInfoController = [[[MTProfileInfoViewController alloc] initWithProfileName: profile.name]autorelease];
        [self.navigationController pushViewController:profileInfoController animated:YES];
    }
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

#pragma NSFetchedResultsControllerDelegate

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
            if([_name isEqualToString:@"Profile"]) {
                
                [self profile:tableView andRow:indexPath];
                
            }else{
                
            
            }
           // [_fetchedResultsController:controller configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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

#pragma Cells for different table view data
- (UITableViewCell *)profile :(UITableView *)tableView andRow:(NSIndexPath*) indexPath
{
    NSString *CellIdentifier = @"MTProfileCell";
    
    MTProfileCell *tbCell = (MTProfileCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tbCell == nil) {
        
        tbCell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
        
    }
    
    Profile *profile = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    tbCell.profileName.text = profile.name;
    tbCell.profileImage.image = profile.image;
    tbCell.arrowImage.image = [UIImage imageNamed:@"ArrowBlack"];
    
    return tbCell;
}


- (UITableViewCell *)reminder :(UITableView *)tableView andRow:(int) rows
{
    NSString *CellIdentifier = @"MTReminderCell";
    
    MTReminderCell *tbCell = (MTReminderCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tbCell == nil) {
        
        tbCell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
        
    }
    
    if(_list.count > 0)
        return tbCell;
    
    NSDictionary *contacts = (NSDictionary *) [_list objectAtIndex:rows];
    NSString *name = [contacts objectForKey: @"takerName"];
    NSString *medicine = [contacts objectForKey:@"medicineName"];
    NSString *scheduleTime = [contacts objectForKey:@"scheduleTime"];
    NSString *scheduleStatus = [contacts objectForKey:@"scheduleStatus"];
    NSString *takenTime = [contacts objectForKey: @"takenTime"];
    NSString *medicineQuantity = [contacts objectForKey:@"medicineQuantity"];
    NSString *medicineUnit = [contacts objectForKey:@"medicineUnit"];
    NSString *medicineImage = [contacts objectForKey:@"medicineImage"];
    NSString *takerImage = [contacts objectForKey:@"takerImage"];
    NSString *alarmImage = [contacts objectForKey:@"alerImage"];
    
    tbCell.takerName.text = name;
    tbCell.medicineName.text = medicine;
    tbCell.scheduleTime.text = scheduleTime;
    tbCell.scheduleStatus.text = scheduleStatus;
    tbCell.takenTime.text = takenTime;
    tbCell.medicineQuantity.text = medicineQuantity;
    tbCell.medicineUnit.text = medicineUnit;
    tbCell.medicineImage.image = [UIImage imageNamed:medicineImage];
    tbCell.TakerImage.image = [UIImage imageNamed:takerImage];
    tbCell.alarmImage.image = [UIImage imageNamed:alarmImage];
    
    return tbCell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
