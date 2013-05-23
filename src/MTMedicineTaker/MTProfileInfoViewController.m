//
//  MTProfileInfoViewController.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/15/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MTProfileInfoViewController.h"
#import "Profile.h"
#import "Medicine.h"
#import "MTMedicineInfoViewController.h"
#import "MTMedicineCell.h"
#import "Time.h"
#import "MTLocalNotification.h"
#import "PCImageDirectorySaver.h"
#import "PCAsyncImageView.h"

@interface MTProfileInfoViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSFetchedResultsControllerDelegate,PCAsyncImageViewDelegate>
{
    UIImagePickerController *imagePicker;
}

@property(nonatomic, retain) UIImage *previousImage;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) UIImage *originalImage;

- (NSFetchedResultsController *)fetchedResultsControllerwithEntityName:(NSString *)entityName andSortDescriptorName:(NSString *)sortDescriptorName andCacheName:(NSString *)cacheName;
@end

@implementation MTProfileInfoViewController

- (id)initWithProfileName: (NSString *)profileName
{
    NSString *nibName = [[XCDeviceManager manager] xibNameForDevice:@"MTProfileInfoViewController"];
    self = [super initWithNibName:nibName bundle:nil];
    if (self) {
        
        self.navigationItem.title = @"Profile";
        
        [[MTProfileManager profileManager] profileWithName:profileName];
        
        _name = [[NSString alloc]init];
        _originalImage = [[UIImage alloc] init];
        _name = [profileName retain];
        
        UIImage *allProfileImageInactive = [UIImage imageNamed:@"All-Profile_btn-ss.png"];
        UIImage *allProfileImageActive = [UIImage imageNamed:@"All-Profile_btn-s.png"];
        UIButton *buttonAllProfile = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonAllProfile.frame = CGRectMake(0.0f, 0.0f, 83.5f, 33.5f);
        [buttonAllProfile setImage:allProfileImageInactive forState:UIControlStateNormal];
        [buttonAllProfile setImage:allProfileImageActive forState:UIControlStateHighlighted];
        [buttonAllProfile addTarget:self action:@selector(onButtonAllProfilelicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButtonAllprofile = [[[UIBarButtonItem alloc] initWithCustomView:buttonAllProfile]autorelease];
        self.navigationItem.leftBarButtonItem = barButtonAllprofile;
   
        UIImage *doneImageInActive = [UIImage imageNamed:@"Done_btn-ss.png"];
        UIImage *doneImageActive = [UIImage imageNamed:@"Done_btn-s.png"];
        
        UIButton *buttonDone = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonDone.frame = CGRectMake(0, 0, 62.5, 33.5);
        [buttonDone setImage:doneImageInActive forState:UIControlStateNormal];
        [buttonDone setImage:doneImageActive forState:UIControlStateHighlighted];
        [buttonDone addTarget:self action:@selector(onButtonDoneClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButtonDone = [[[UIBarButtonItem alloc] initWithCustomView:buttonDone]autorelease];
        self.navigationItem.rightBarButtonItem = barButtonDone;
        
    }
    return  self;
}

- (void) dealloc
{
    [_name release];
    [_originalImage release];
    [_fetchedResultsController release];
    [super dealloc];
}

//- (void)didLoadAsyncImageView:(PCAsyncImageView *)asyncImageView
- (void)clickedAsyncImageView:(PCAsyncImageView *)asyncImageView
{

}

- (void) onButtonAllProfilelicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) populateData
{
    Profile *profile = [[MTProfileManager profileManager] profile];
    self.profileName.text = profile.name;
    [self.profileImage setImage:[[PCImageDirectorySaver directorySaver]imageFilePath:profile.profileImagePath] forState:UIControlStateNormal];
    self.originalImage = [[PCImageDirectorySaver directorySaver]imageFilePath:profile.profileImagePath];//profile.image;
    
    NSError *error = nil;
    if(![[self fetchedResultsControllerwithEntityName:@"Profile" andSortDescriptorName:@"name" andCacheName:@"profileMedicine"] performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    [_tableView reloadData];
}

/*-(Profile *) getProfile
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profile" inManagedObjectContext:[[ManageObjectModel objectManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(name like %@)",_name];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects =[[[ManageObjectModel objectManager] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    Profile *profile = (Profile *) [fetchedObjects objectAtIndex:0];
    NSLog(@"Profile name %@",profile.name);
    return profile;
}*/

-(IBAction)editProfilePicture:(id)sender
{
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:nil] autorelease];
    [actionSheet addButtonWithTitle:@"Take Photo"];
    [actionSheet addButtonWithTitle:@"Choose Photo"];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
    [_profileName resignFirstResponder];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.previousImage = self.profileImage.imageView.image;
    imagePicker = [[[UIImagePickerController alloc] init] autorelease];
    imagePicker.delegate = self;
    
    if(buttonIndex == 0) {
        NSLog(@"Take Photo");
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera ;
            [self presentModalViewController:imagePicker animated:YES];
        }
        else
        {
            NSLog(@"Error to take photo");
        }
    } else if(buttonIndex == 1) {
        NSLog(@"Choose Photo");
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:imagePicker animated:YES];
        }
        else
        {
            NSLog(@"Error to choose photo");
        }
    }
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_profileName resignFirstResponder];
    
    if([_profileName.text isEqualToString:@""])
        self.profileName.text = _name;
 
    return YES;
}


#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.profileImage setImage:self.previousImage forState:UIControlStateNormal];
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage* originalImage = nil;
    originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(originalImage==nil)
    {
        originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if(originalImage==nil)
    {
        originalImage = [info objectForKey:UIImagePickerControllerCropRect];
    }
    
    UIImage *fixedOrientationImage = originalImage;
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        fixedOrientationImage = [originalImage fixOrientation];
    }
    
    UIImage *finalImage = [[PCImageDirectorySaver directorySaver] scaleImage:fixedOrientationImage withScaleToSize:CGSizeMake(100.0f,100.0f)];
    //At this point you have the selected image in originalImage
    [self.profileImage setImage:finalImage forState:UIControlStateNormal];
    
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


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    NSLog(@"Num of rows %d", [sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [[_fetchedResultsController sections] count];
     NSLog(@"Sections %d",count);
     return count;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSString *CellIdentifier = @"MTMedicineCell";
    
    MTMedicineCell *tbCell = (MTMedicineCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tbCell == nil) {
        
        tbCell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
        
    }
    
    Medicine *medicine = [_fetchedResultsController objectAtIndexPath:indexPath];
  
    tbCell.medicineName.text = medicine.medicineName;
    tbCell.quantity.text = [medicine.quantity stringValue];
    tbCell.unit.text = medicine.unit;
    tbCell.medicineImageView.image = [[PCImageDirectorySaver directorySaver]imageFilePath:medicine.medicineImagePath];//medicine.image;
    tbCell.frequency.text = medicine.frequency;;
    //[tbCell.medicineImage loadImageFromURL:[NSURL URLWithString:medicine.medicineImagePath]];
    
    NSArray *timeSet = [medicine.times allObjects];
    if(timeSet.count) {

        NSMutableString *string = [NSMutableString string];
        for(Time *t in timeSet) {
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[t.time doubleValue]]; //<- retrieve the date
            NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
            dateFormat.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            [dateFormat setDateFormat:@"hh:mm aa"];
            NSString *strTime = [dateFormat stringFromDate:date];
            
            if(![t isEqual:timeSet.lastObject]) {
                [string appendFormat:@"%@, ",strTime];
            } else {
                [string appendFormat:@"%@ ",strTime];
            }
            
        }
        tbCell.scheduleTime.text = string;
    }
    
    return tbCell;
}
/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 return  tableView;
 }*/


#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Medicine *medicine = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *nibName = [[XCDeviceManager manager] xibNameForDevice:@"MTMedicineInfoViewController"];
        MTMedicineInfoViewController *medicineInfoController = [[[MTMedicineInfoViewController alloc] initWithNibName:nibName bundle:nil] autorelease];
    
    medicineInfoController.medicine = medicine;
    [self.navigationController pushViewController:medicineInfoController animated:YES];
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
    Medicine *medicine = [_fetchedResultsController objectAtIndexPath:indexPath];
    NSManagedObject *manageObject = medicine;
    [[ManageObjectModel objectManager] deleteObject:manageObject];
    [[ManageObjectModel objectManager] saveContext];
    [[MTLocalNotification sharedInstance] deleteNotificationWithMedicine:medicine fromNotification:nil];
}

- (void) onButtonDoneClicked
{
    if([_profileName.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning:" message:@"Please fill out profile name!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];

    } else {
        
        Profile *profile = [[MTProfileManager profileManager] profile];
        profile.name = self.profileName.text;
        NSLog(@"image %@",self.profileImage.imageView.image);
        profile.profileImagePath = [[PCImageDirectorySaver directorySaver] saveImageInDocumentFileWithImage:self.profileImage.imageView.image andAppendingImageName:[NSString stringWithFormat:@"Profile_%@",self.profileName.text]];

        [[ManageObjectModel objectManager] saveContext];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSFetchedResultsController *)fetchedResultsControllerwithEntityName:(NSString *)entityName andSortDescriptorName:(NSString *)sortDescriptorName andCacheName:(NSString *)cacheName {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSLog(@"EntityName and sortDescriptorName = %@, %@",self.name,sortDescriptorName);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Medicine" inManagedObjectContext:[[ManageObjectModel objectManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(medicineTaker.name like %@)",self.name];
 
    NSLog(@"Name %@",predicate);
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"meal" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:3];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[[ManageObjectModel objectManager] managedObjectContext] sectionNameKeyPath:nil
                                                   cacheName:nil];
    _fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

-(IBAction)addMedicine:(id)sender
{
    NSString *nibName = [[XCDeviceManager manager] xibNameForDevice:@"MTMedicineInfoViewController"];
    MTMedicineInfoViewController *medicineInfoController = [[MTMedicineInfoViewController alloc] initWithNibName:nibName bundle:nil];
    Medicine *medicine = [Medicine medicine];
    medicine.medicineTaker = [MTProfileManager profileManager].currentProfile;
    medicineInfoController.medicine = medicine;
    [self.navigationController pushViewController:medicineInfoController animated:YES];
    [medicineInfoController release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self populateData];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated
{
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
