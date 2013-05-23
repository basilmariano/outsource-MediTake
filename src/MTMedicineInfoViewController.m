//
//  MTMedicineInfoViewController.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/16/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MTMedicineInfoViewController.h"
#import "MTMedicineInfoCell.h"
#import "MTTextFieldCell.h"
#import "MTScheduleViewController.h"
#import "Medicine.h"
#import "Time.h"
#import "Date.h"
#import "MTLocalNotification.h"
#import "PCImageDirectorySaver.h"

@interface MTMedicineInfoViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,MTTextFieldCellDelegate>
{
    UIImagePickerController *imagePicker;
    int selectedIndex;
}

@property(nonatomic, retain) UIImage *originalImage;
@property(nonatomic, retain) UIActionSheet *actionSheet;
@property(nonatomic, retain) UIPickerView *pickerView;
@property(nonatomic, retain) NSArray *pickerList;
@property(nonatomic, retain) NSArray *quantityList;
@property(nonatomic, retain) NSArray *mealList;
@property(nonatomic, retain) NSMutableArray *previousTimeList;
@property(nonatomic, retain) NSMutableArray *previousDayList;
@property(nonatomic, retain) NSString *proviousMedicineName;

- (IBAction)addMedicineImage:(id)sender;
- (UIPickerView *)pickerViewInit;
- (void)onButtonCancelClicked;
- (void)onButtonDoneClicked;
- (void)okTapped:(NSObject *)sender;
- (void)showPickerActionSheet:(NSString *)title;

@end

@implementation MTMedicineInfoViewController
static MTMedicineInfoViewController *_instance;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"New Medicine";
        _originalImage = [[UIImage alloc] init];
        _previousTimeList = [[NSMutableArray alloc] init];
        _previousDayList = [[NSMutableArray alloc] init];

        self.quantityList = [[[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5", nil] autorelease];
        self.mealList = [[[NSArray alloc] initWithObjects:@"Before Meal",@"After Meal",@"None", nil] autorelease];
        
        UIImage *cancelImageInactive = [UIImage imageNamed:@"Cancel_btn-ss.png"];
        UIImage *cancelImageActive = [UIImage imageNamed:@"Cancel_btn-s.png"];
    
        UIButton *buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonCancel.frame = CGRectMake(0.0f, 0.0f, 65.5f, 33.5f);
        [buttonCancel setImage:cancelImageInactive forState:UIControlStateNormal];
        [buttonCancel setImage:cancelImageActive forState:UIControlStateHighlighted];
        [buttonCancel addTarget:self action:@selector(onButtonCancelClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButtonAllprofile = [[[UIBarButtonItem alloc] initWithCustomView:buttonCancel]autorelease];
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
        _instance = self;
    }
    
    return self;
}
+(MTMedicineInfoViewController *)sharedInstance
{
    return _instance;
}

- (void) dealloc
{
    [_tableView release];
    [_medicineImage release];
    [_medicineName release];
    [_originalImage release];
    [_actionSheet release];
    [_pickerView release];
    [_pickerList release];
    [_quantityList release];
    [_medicine release];
    [_previousDayList release];
    [_previousTimeList release];
    [super dealloc];
}

#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 3;
    else
        return  1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellWithTableView:tableView andIndexPath:indexPath];
}

- (UITableViewCell *)cellWithTableView: (UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Medicine %@ %@",_medicine,self.medicine);
    NSString *CellIdentifier = @"MTMedicineInfoCell";
    
    MTMedicineInfoCell *tbCell = (MTMedicineInfoCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tbCell == nil) {
        
        tbCell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
        
    }
    
    NSString *cellName = @"";
    NSString *cellValue = @"";
    if(indexPath.section == 1) {
        cellName = @"Time";
        cellValue = self.medicine.frequency;
    } else {
        switch (indexPath.row) {
            case 0: {
                NSString *CellIdentifier = @"MTTextFieldCell";
                
                MTTextFieldCell *tbCell = (MTTextFieldCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (tbCell == nil) {
                    
                    tbCell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
                    
                }
                tbCell.delegate = self;
                tbCell.title.text = @"Quantity";
                tbCell.textFieldRange = 100;
                tbCell.textField.text = [self.medicine.quantity stringValue];
                tbCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                tbCell.textField.placeholder = @"1";
                tbCell.viewParam = self.view;
                tbCell.textId = 1;
                return tbCell;
                break;
            }
            case 1: {
                
                NSString *CellIdentifier = @"MTTextFieldCell";
                
                MTTextFieldCell *tbCell = (MTTextFieldCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (tbCell == nil) {
                    
                    tbCell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
                    
                }
                tbCell.delegate = self;
                tbCell.title.text = @"Unit";
                tbCell.textFieldRange = 100;
                tbCell.textField.text = self.medicine.unit;
                tbCell.textField.placeholder = @"ml, tbsp, tablet etc";
                tbCell.viewParam = self.view;
                tbCell.textId = 0;
                return tbCell;
                break;
            }
            case 2: {
                cellName = @"Meal";
                cellValue = self.medicine.meal;
                break;
            }
        }
    }
    
    tbCell.cellName.text = cellName;
    tbCell.cellValue.text = cellValue;
    
    return tbCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"  Dosage";
    else if (section == 1)
        return @"  Schedule";
    return @"Unknown";
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1) {
        
        NSString *nibName = [[XCDeviceManager manager] xibNameForDevice:@"MTScheduleViewController"];
        MTScheduleViewController *scheduleViewController = [[MTScheduleViewController alloc] initWithNibName:nibName bundle:nil];
        scheduleViewController.medicine = _medicine;
        [self.navigationController pushViewController:scheduleViewController animated:YES];
        [scheduleViewController release];
        selectedIndex = indexPath.row;
        return;
        
    } else {
        switch (indexPath.row) {
            case 0: {
                break;
            }
            case 1: {
                break;
            }
            case 2: {
                self.pickerList = _mealList;
                [self showPickerActionSheet:@"Meal"];
                break;
                break;
            }
        }
    }
    
    selectedIndex = indexPath.row;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  indexPath;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 32)] autorelease];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0,119, 32)] autorelease];
    label.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    [label setTextColor:[UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1.0]];
    
    UIImage *background = [UIImage imageNamed:@"SectionBackground.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:background];
    bgImageView.frame = CGRectMake(0, 0, 320, 32);
    
    [headerView addSubview:bgImageView];
    [headerView addSubview:label];
    
    return headerView;
}
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.medicineImage setImage:_originalImage forState:UIControlStateNormal];
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage* originalImage = nil;
    originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
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
    [self.medicineImage setImage:finalImage forState:UIControlStateNormal];
}

#pragma mark - UIPickerViewDataSource and UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)picker numberOfRowsInComponent:(NSInteger)component
{
    return _pickerList.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_pickerList objectAtIndex:row];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_medicineName resignFirstResponder];
    
    if(![_medicineName.text isEqualToString:@""])
    {
        //self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    return YES;
}

#pragma UIImagePickerControllerDelegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.originalImage = self.medicineImage.imageView.image;
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


-(void) textFieldFinishedTyping:(UITextField *)textField andTextFieldId:(NSNumber *)textFieldId
{
    if([textFieldId integerValue] == 0) {
        self.medicine.unit = textField.text;
    } else if ([textFieldId integerValue] == 1) {
        self.medicine.quantity = [NSNumber numberWithInt: [textField.text integerValue]];
    }
}

- (void) onButtonCancelClicked
{
    [[ManageObjectModel objectManager] rollback];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) removeNotificationWithDeletedDays
{
    NSMutableArray *notificationListWithMedicine = [[MTLocalNotification sharedInstance] medicineNotificationList:self.medicine];
    NSArray *dayList = [NSArray arrayWithArray:[_medicine.days allObjects]];
    for(Date *date in dayList) {
        Date *dateHandler = nil;
        Date *prevDateStr = nil;
        for(Date *prevDate in self.previousDayList) {
            NSLog(@"day %@",prevDate);
//NSLog(@"day2 %@",prevDate.date);
            
            prevDateStr = prevDate;//<- on  tuesday :)
            if([date isEqual:prevDate]) {
                dateHandler = date;
            }
        }
        if(!dateHandler) {
            //check if in localNotif
            for(UILocalNotification *localNotif in notificationListWithMedicine) {
                NSDictionary *dict    = localNotif.userInfo;
                NSArray *dayList      = (NSArray *) [dict objectForKey:@"day"];
                NSLog(@"dayLIstCouhnt %@",dayList);
                
                for(NSString *strDay in dayList) {
                    
                    NSManagedObject *objectD = prevDateStr;
                    NSString *strPKDay = [[[objectD objectID] URIRepresentation] absoluteString];
                    NSLog(@"%@ ==  %@", strDay, strPKDay);
                    if([strPKDay isEqualToString:strDay]) {
                        [self.previousDayList removeObject:prevDateStr];
                        [[MTLocalNotification sharedInstance] cancelNotificationWithMedicine:self.medicine withDay:prevDateStr];
                    }
                }
            }
        }
    }
    
    for(Date *prevDate in self.previousDayList) {
        NSLog(@"day %@",prevDate);

        for(UILocalNotification *localNotif in notificationListWithMedicine) {
            NSDictionary *dict    = localNotif.userInfo;
            NSArray *dayList      = (NSArray *) [dict objectForKey:@"day"];
            NSLog(@"dayLIstCouhnt %@",dayList);
            
            for(NSString *strDay in dayList) {
                
                NSManagedObject *objectD = prevDate;
                NSString *strPKDay = [[[objectD objectID] URIRepresentation] absoluteString];
                NSLog(@"%@ ==  %@", strDay, strPKDay);
                if([strPKDay isEqualToString:strDay]) {
                   
                    [[MTLocalNotification sharedInstance] cancelNotificationWithMedicine:self.medicine withDay:prevDate];
                }
            }
        }
    }
}

- (void)setFireDate
{
    NSArray *timeList = [NSArray arrayWithArray:[_medicine.times allObjects]];
    NSArray *dayList = [NSArray arrayWithArray:[_medicine.days allObjects]];
    
    [self removeNotificationWithDeletedDays];
    
    NSDate *finalDate = nil;
    NSDate *time = nil;
    NSDate *dayDate = nil;
    NSDateComponents *dateComponents = [[[NSDateComponents alloc] init] autorelease];
    NSDateComponents *timeComponents = [[[NSDateComponents alloc] init] autorelease];
    NSNumber *type = nil;
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
   
    for(Time *t in timeList) {
        Time *t1 = nil;
        for(Time *t3 in self.previousTimeList) {
         
            if(t3.time == t.time) {
                NSDate *time = [NSDate dateWithTimeIntervalSince1970:[t3.time doubleValue]];
                BOOL isNotificationExist = [[MTLocalNotification sharedInstance] isNotificationExistWithMedicine:self.medicine andFireTime:time];
                if(isNotificationExist) {
                    t1 = t3;
                }
            }
            
        }
        
        if(!t1) {
        for(Date *d in dayList) {
       
            switch ([d.type integerValue]) {
                case 0: {
                    
                    NSString *dateStr = d.date;
                
                    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];// <- Convert string to date object
                    [dateFormat setDateFormat:@"EEEE"];
                    
                    NSDate *day = [dateFormat dateFromString:dateStr];
                    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:day];

                    NSDate *now = [NSDate date];
                    NSDateComponents *compsThisMonth = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:now];
                    compsThisMonth.day = 1;
                    NSDate *firstDayOfThisMonth = [calendar dateFromComponents:compsThisMonth];

                    NSDateComponents *compsFirstDayOfThisMonth = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:firstDayOfThisMonth];
                    
                    if (comps.weekday == compsFirstDayOfThisMonth.weekday) {
                        
                        dateComponents = compsFirstDayOfThisMonth;
                        
                    } else if (comps.weekday > compsFirstDayOfThisMonth.weekday) {
                        
                        NSUInteger daysNeed2Add = comps.weekday - compsFirstDayOfThisMonth.weekday;
                        NSDate *dayOfWeek       = [firstDayOfThisMonth dateByAddingTimeInterval:60.0*60.0*24 * daysNeed2Add];
                        dateComponents          = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:dayOfWeek];
                        
                    } else { // comps.weekday < compsFirstDayOfThisMonth.weekday
                        NSUInteger daysNeed2Add = comps.weekday + 7 - compsFirstDayOfThisMonth.weekday;
                        NSDate *dayOfWeek       = [firstDayOfThisMonth dateByAddingTimeInterval:60.0*60.0*24 * daysNeed2Add];
                        dateComponents          = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:dayOfWeek];
                    }

                    dayDate = [calendar dateFromComponents:dateComponents];
                    type    =  [NSNumber numberWithInt:0];
                 
                    break;
                }
                case 1: {
                    
                    NSDate *now = [NSDate date];
                    NSDateComponents *compsThisMonth = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:now];
                    
                    NSDate *d1 = [NSDate date];
                    NSDateComponents *components = [calendar components:(NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:d1];
                    [components setDay:[d.date integerValue]];
                    NSLog(@"%d and %d",compsThisMonth.day,components.day);
                    if(compsThisMonth.day > components.day) {
                        [components setMonth:compsThisMonth.month + 1];
                        dateComponents = components;
                    }
                    
                    dateComponents = components;
                    
                    dayDate = [calendar dateFromComponents:dateComponents];
                
                    type =  [NSNumber numberWithInt:1];
                    
                    break;
                }
                case 2: {
                    
                    NSString *dateStr = d.date;
                    // Convert string to date object
                    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
                    [dateFormat setDateFormat:@"MMM dd, yyyy"];
                    
                    dayDate = [dateFormat dateFromString:dateStr];
                    dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit )
                                                 fromDate:dayDate];
                    type =  [NSNumber numberWithInt:2];
                    
                    break;
                }
            }
            
            NSTimeInterval timeInterval = dayDate.timeIntervalSince1970;
            timeInterval = timeInterval + [t.time doubleValue];
            
            NSDate *dateForNotif = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            
            time = dateForNotif;
            
            timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit )
                                         fromDate:time];
            
            NSDateComponents *finalDateComp = [[[NSDateComponents alloc] init] autorelease];
            [finalDateComp setMonth:[dateComponents month]];
            [finalDateComp setDay:[dateComponents day]];
            [finalDateComp setYear:[dateComponents year]];
            [finalDateComp setWeekday:[dateComponents weekday]];
            // Notification will fire in one minute
            [finalDateComp setHour:[timeComponents hour]];
            [finalDateComp setMinute:[timeComponents minute]];
            
            NSDate *itemDate = [calendar dateFromComponents:finalDateComp];
        
            finalDate = itemDate;
            
            NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormat setDateFormat:@"MMM:dd:yyyy hh:mm aa EEEE"];
            
            NSString *strTime = [dateFormat stringFromDate:finalDate];
            NSLog(@"Final Date %@",strTime );
            NSLog(@"day %@",d.date );
            [[MTLocalNotification sharedInstance] scheduleNotificationWithFireDate:itemDate frequencyType:type andDayValue:d andMedicine:_medicine];
            //[[MTLocalNotification sharedInstance] scheduleNotificationWithFireDate:itemDate frequencyType:type andDayValue: (NSString *)day andMedicine:_medicine];
        }
        }
    }
        
}

- (BOOL) isMedicineExist
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medicine" inManagedObjectContext:[[ManageObjectModel objectManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(medicineName like %@)",_medicineName.text];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects =[[[ManageObjectModel objectManager] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if(fetchedObjects.count ==0)
        return NO;
    else
        return YES;
    
    return NO;
}

- (void) onButtonDoneClicked
{
    if(![self.medicineName.text isEqual:@""]) {
        
        // if(![self.medicineName.text isEqualToString:self.proviousMedicineName]) {
        
        NSString *imagePath = [NSString stringWithFormat:@"Medicine_%@%@",_medicineName.text,_medicine.medicineTaker.name];
        
        self.medicine.medicineName      = _medicineName.text;
        self.medicine.medicineImagePath = [[PCImageDirectorySaver directorySaver] saveImageInDocumentFileWithImage:self.medicineImage.imageView.image andAppendingImageName:imagePath];
        self.medicine.willRemind        = [NSNumber numberWithBool:self.switcher.on];
        self.medicine.status            = self.medicine.meal;
        
        [[ManageObjectModel objectManager] saveContext];
        
        NSManagedObject *object = [Medicine medicineWithImagePath:self.medicine.medicineImagePath];
        int primaryKey = [[[[[[object objectID] URIRepresentation] absoluteString] lastPathComponent] substringFromIndex:1] intValue];
        NSString *strPK = [[NSNumber numberWithInt:primaryKey] stringValue];
        
        NSLog(@"PK %@",strPK);
        Medicine *updateMedicine = (Medicine *) object;
        updateMedicine.medicineName      = _medicineName.text;
        updateMedicine.medicineImagePath = [[PCImageDirectorySaver directorySaver] replaceFile:imagePath withImage:self.medicineImage.imageView.image withNewFile:strPK];
        updateMedicine.willRemind        = [NSNumber numberWithBool:self.switcher.on];
        updateMedicine.status            = self.medicine.meal;
        
        [[ManageObjectModel objectManager] saveContext];
        
        if(self.switcher.on) {
            [self setFireDate];
        } else {
            [[MTLocalNotification sharedInstance] deleteNotificationWithMedicine:self.medicine fromNotification:nil];
        }
        
        
        
        [self.navigationController popViewControllerAnimated:YES];//<-return to predecessor controller
        /*NSArray *notificationList = [UIApplication sharedApplication].scheduledLocalNotifications;
         NSLog(@"%d", notificationList.count);*/
        
        //} else {
        
        /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information:" message:@"Medicine already exist!!"
         delegate:nil
         cancelButtonTitle:@"Ok"
         otherButtonTitles:nil];
         [alert show];
         [alert release];*/
        
        //}
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error:" message:@"Please fill out Medicine name!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)showPickerActionSheet:(NSString *)title
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
    actionSheet.frame = CGRectMake(0.0f, self.view.bounds.size.height - 300.0f, actionSheet.frame.size.width, 300.0f);
    self.actionSheet = actionSheet;
    
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 30.0f)]autorelease];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    [actionSheet addSubview:titleLabel];
    
    self.pickerView = [self pickerViewInit];
    [actionSheet addSubview:self.pickerView];
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [okButton setTitle:@"OK" forState:UIControlStateNormal];
    //[okButton setBackgroundImage:[UIImage imageNamed:@"ButtonBg.png"] forState:UIControlStateNormal];
    okButton.frame = CGRectMake(21.0f, 250.0f, 278.0f, 45.0f);
    [okButton addTarget:self action:@selector(okTapped:) forControlEvents:UIControlEventTouchUpInside];
    //[actionSheet addSubview:self.pickerView];
    [actionSheet addSubview:okButton];
    
    [actionSheet release];
}

- (void)okTapped:(NSObject *)sender
{
    NSLog(@"%d",[_pickerView selectedRowInComponent:0] );
    
    if( selectedIndex == 0) {
        _medicine.quantity = [NSNumber numberWithInt:[[_pickerList objectAtIndex:[_pickerView selectedRowInComponent:0]] integerValue]];
        MTMedicineInfoCell *cell = (MTMedicineInfoCell *) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
        cell.cellValue.text = [_medicine.quantity stringValue];
        [cell layoutSubviews];
    }
    else {
        _medicine.meal = [_pickerList objectAtIndex:[_pickerView selectedRowInComponent:0]];
        MTMedicineInfoCell *cell = (MTMedicineInfoCell *) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
        cell.cellValue.text = self.medicine.meal;
        [cell layoutSubviews];
    }
    [_actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    self.actionSheet = nil;
    self.pickerView = nil;
}
    
- (UIPickerView *)pickerViewInit
{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 0.0f, 0.0f)];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    return [pickerView autorelease];
}

- (IBAction)addMedicineImage:(id)sender
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

    [_medicineName resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
   // self.previousTimeList = [NSArray arrayWithArray:[_medicine.times allObjects]];
   // self.previousDayList = [NSArray arrayWithArray:[_medicine.days allObjects]];
    if(![self.medicineName.text isEqual:@""])
        

    [_tableView reloadData];
}
-(NSMutableArray *)medicineTimeList
{
    return self.previousTimeList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(_medicine.medicineImagePath) {
        [self.medicineImage setImage:[[PCImageDirectorySaver directorySaver]imageFilePath:_medicine.medicineImagePath] forState:UIControlStateNormal];
    }
    
    if(_medicine.medicineName) {
        self.medicineName.text = _medicine.medicineName;
        self.navigationItem.title = _medicine.medicineName;
        self.proviousMedicineName = _medicine.medicineName;
    }
    
    if([_medicine.willRemind integerValue] == 1) {
        self.switcher.on = YES;
    } else {
         self.switcher.on = NO;
    }
    self.originalImage = self.medicineImage.imageView.image;
    
    NSArray *arrTimeList = [NSArray arrayWithArray:[_medicine.times allObjects]];
    for(Time *time in arrTimeList) {
        [self.previousTimeList addObject:time];
    }
    
    NSArray *arrDayList = [NSArray arrayWithArray:[_medicine.days allObjects]];
    for(Date *date in arrDayList) {
        [self.previousDayList addObject:date];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
