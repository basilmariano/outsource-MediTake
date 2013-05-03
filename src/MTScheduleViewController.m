//
//  MTScheduleViewController.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/18/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MTScheduleViewController.h"
#import "Time.h"
#import "MTFrequencyDatesViewController.h"
#import "Date.h"
#import "MTMedicineInfoViewController.h"
#import "MTTimeCell.h"
#import "MTLocalNotification.h"
#import "MTMedicineInfoViewController.h"

typedef enum
{
    ListPicker,
    TimePicker,
    DatePicker
}
PickerType;

@interface MTScheduleViewController ()<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic, retain) UIActionSheet *actionSheet;
@property(nonatomic, retain) UIDatePicker *datePicker;
@property(nonatomic, retain) UIPickerView *pickerView;
@property(nonatomic) PickerType pickerType;
@property(nonatomic, retain) NSMutableArray *timeList;
@property(nonatomic, retain) NSMutableArray *specificDays;
@property (nonatomic,retain) NSMutableArray *times;

-(IBAction)frequencyButtonClicked:(id)sender;
-(IBAction)frequencyDayButtonClicked:(id)sender;
-(IBAction)buttonAddTimeClicked:(id)sender;

- (void)onButtonCancelClicked;
- (void)onButtonDoneClicked;
- (void)showPickerActionSheet:(NSString *)title andRow:(NSUInteger)row andDate:(NSDate *)date;
- (void)okTapped:(NSObject *)sender;
- (UIDatePicker *)datePickerForActionSheet;
- (UIPickerView *)listPickerForActionSheet;

@end

static MTScheduleViewController *_instance;

@implementation MTScheduleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _instance = self;
        
        self.navigationItem.title = @"Schedule";
        _timeList = [[NSMutableArray alloc] init];
        _dayList = [[NSMutableArray alloc] init];
        
        UIImage *backImageInActive = [UIImage imageNamed:@"Back-blue_btn-ss.png"];
        UIImage *backImageActive = [UIImage imageNamed:@"Back-blue_btn-s.png"];
        
        UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonBack.frame = CGRectMake(0.0f, 0.0f, 61.0f, 33.5f);
        [buttonBack setImage:backImageInActive forState:UIControlStateNormal];
        [buttonBack setImage:backImageActive forState:UIControlStateHighlighted];
        [buttonBack addTarget:self action:@selector(onButtonBackClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButtonBack = [[[UIBarButtonItem alloc] initWithCustomView:buttonBack]autorelease];
        self.navigationItem.leftBarButtonItem = barButtonBack;
        
        UIImage *doneImageInActive = [UIImage imageNamed:@"Done_btn-ss.png"];
        UIImage *doneImageActive = [UIImage imageNamed:@"Done_btn-s.png"];
        
        UIButton *buttonDone = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonDone.frame = CGRectMake(0, 0, 62.5, 33.5);
        [buttonDone setImage:doneImageInActive forState:UIControlStateNormal];
        [buttonDone setImage:doneImageActive forState:UIControlStateHighlighted];
        [buttonDone addTarget:self action:@selector(onButtonDoneClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButtonDone= [[[UIBarButtonItem alloc] initWithCustomView:buttonDone]autorelease];
        self.navigationItem.rightBarButtonItem = barButtonDone;
        
        _times = [[NSMutableArray alloc] init];
        _specificDays = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [_buttonFrequency release];
    [_buttonFrequencyDay release];
    [_buttonAddTime release];
    [_tableView release];
    [_labelFrequencyValue release];
    [_labelFrequencyDayValue release];
    [_labelFrequencyDayTitle release];
    [_actionSheet release];
    [_datePicker release];
    [_timeList release];
    [_times release];
    [_specificDays release];
    [_medicine release];
    [super dealloc];
}

+(MTScheduleViewController *) scheduleController
{
    return _instance;
}

-(IBAction)frequencyButtonClicked:(id)sender
{
    self.pickerType = ListPicker;
    NSUInteger row = 0;
    if ([_medicine.frequency isEqualToString:@"Weekly"]) {
        row = 0;
    } else if([_medicine.frequency isEqualToString:@"Monthly"]) {
        row = 1;
    } else {
        row = 2;
    }
    [self showPickerActionSheet:@"Frequency" andRow:row andDate:nil];
}

-(IBAction)frequencyDayButtonClicked:(id)sender
{
    NSLog(@"%@", _medicine.frequency);
    if([_medicine.frequency isEqualToString:@"Specific Date"]) {
        self.pickerType = DatePicker;
        Date *date = nil;
        for (Date *d in _medicine.days) {
            if ([d.type intValue] == 2) {
                date = d;
                break;
            }
        }
        NSDate *date2 = [NSDate date];
        if (date) {
            
            NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormat setDateFormat:@"MMM:dd:yyyy"];
            NSDate *d = [dateFormat dateFromString:date.date];
            
            //NSDate *secsDate = [NSDate dateWithTimeIntervalSince1970:[date.date doubleValue]];
            date2 = d;
            //NSLog(@"date %@",date);
            NSLog(@"date2 %@",date2);
        }
        [self showPickerActionSheet:@"Date" andRow:0 andDate:date2];
    } else {
        MTFrequencyDatesViewController *fequencyDatesViewController = [[MTFrequencyDatesViewController alloc] initWithFrequencyDayName:self.labelFrequencyValue.text];
        fequencyDatesViewController.medicine = self.medicine;
        [self presentModalViewController:fequencyDatesViewController animated:YES];
    }
}

-(IBAction)buttonAddTimeClicked:(id)sender
{
    self.pickerType = TimePicker;
    [self showPickerActionSheet:@"Time" andRow:0 andDate:nil];
    NSLog(@"Add Time");
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _times.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"MTTimeCell";
    
    MTTimeCell *tbCell = (MTTimeCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tbCell == nil) {
        
        tbCell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil]objectAtIndex:0];
    }
    
    Time *time = (Time *) [self.times objectAtIndex:indexPath.row];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time.time doubleValue]]; //<- retrieve the date
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    dateFormat.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormat setDateFormat:@"hh:mm aa"];
    NSString *strTime = [dateFormat stringFromDate:date]; //<- format the time*/
    
    tbCell.textLabel.text = strTime;
    
    return tbCell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Time *time = [self.times objectAtIndex:indexPath.row];
    [[MTMedicineInfoViewController sharedInstance].medicineTimeList removeObject:time];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time.time doubleValue]];
    [[MTLocalNotification sharedInstance] cancelNotificationWithMedicine:_medicine andFireDate:date];
    NSManagedObject *manageObject = time;
    [[ManageObjectModel objectManager] deleteObject:manageObject];
    [self.times removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
}

#pragma mark - UIPickerViewDataSource and UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)picker numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (row) {
        case 0:
            return @"Weekly";
            break;
        case 1:
            return @"Monthly";
            break;
        case 2:
            return @"Specific Date";
            break;
    }
    return @"Nothing";
}

- (void)showPickerActionSheet:(NSString *)title andRow:(NSUInteger)row andDate:(NSDate *)date
{
    CGRect okRect = CGRectMake(21.0f, 250.0f, 278.0f, 45.0f);
    
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
    
    switch (self.pickerType) {
        case ListPicker: {
            self.pickerView = [self listPickerForActionSheet];
            [self.pickerView selectRow:row inComponent:0 animated:NO];
            [actionSheet addSubview:self.pickerView ];
         
            break;
        }
        case TimePicker: {
            self.datePicker = [self timePickerForActionSheet];
            [actionSheet addSubview:self.datePicker];
           
            break;
        }
        case DatePicker: {
            self.datePicker = [self datePickerForActionSheet];
            self.datePicker.date = date;
            [actionSheet addSubview:self.datePicker];
            
            /*UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
            [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
            //[okButton setBackgroundImage:[UIImage imageNamed:@"ButtonBg.png"] forState:UIControlStateNormal];
            deleteButton.frame = CGRectMake(177.0f, 250.0f, 73.0f, 45.0f);
            [deleteButton addTarget:self action:@selector(deleteTapped:) forControlEvents:UIControlEventTouchUpInside];
            //[actionSheet addSubview:self.pickerView];
            [actionSheet addSubview:deleteButton];*/
            
           // okRect = CGRectMake(68.0f, 250.0f,73.0f, 45.0f);
            
            break;
        }
    }
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [okButton setTitle:@"OK" forState:UIControlStateNormal];
    //[okButton setBackgroundImage:[UIImage imageNamed:@"ButtonBg.png"] forState:UIControlStateNormal];
    okButton.frame = okRect;
    [okButton addTarget:self action:@selector(okTapped:) forControlEvents:UIControlEventTouchUpInside];
    //[actionSheet addSubview:self.pickerView];
    [actionSheet addSubview:okButton];
    
    [actionSheet release];
}

/*- (void) deleteTapped: (NSObject *)sender
{
    [_actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information:" message:@"Nothing to delete"
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}*/

- (void)okTapped:(NSObject *)sender
{
    if(self.pickerType == ListPicker) {
        switch ([_pickerView selectedRowInComponent:0]) {
            case 0: {
                self.labelFrequencyDayTitle.text = @"Day of Week";
                self.labelFrequencyValue.text = @"Weekly";
                break;
            }
            case 1: {
                self.labelFrequencyDayTitle.text = @"Day of Month";
                self.labelFrequencyValue.text = @"Monthly";
                break;
            }
            case 2: {
                self.labelFrequencyDayTitle.text = @"Date";
                self.labelFrequencyValue.text = @"Specific Date";
                break;
            }
        }
        _medicine.frequency = self.labelFrequencyValue.text;
       
        
    } else if(self.pickerType == DatePicker) {
        
        NSDate *date = _datePicker.date;
        NSLog(@"Date %@",date);
        NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
        
        dateFormat.timeZone = _datePicker.timeZone;
        [dateFormat setDateFormat:@"MMM:dd:yyyy"];
        NSString *strDate = [dateFormat stringFromDate:date]; //<- format the time
         NSLog(@"Date %@",strDate);
        if(self.specificDays.count) {
            for(Date *spesDate in _medicine.days) {
                if([strDate isEqualToString:spesDate.date] && [spesDate.type integerValue] == 2) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning:" message:@"Date selected already exist"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    break;
                } else if ([spesDate.type integerValue] == 2) {
                    NSManagedObject *objectToRemove = spesDate;
                    [[ManageObjectModel objectManager] deleteObject:objectToRemove];
                    
                    Date *newDate= [Date date];
                    [newDate setDate:strDate];
                    [newDate setType:[NSNumber numberWithInt:2]];
                    [_medicine addDaysObject:newDate];
                    [self.specificDays addObject:newDate];
                    break;
                }
            }
        } else {
            Date *newDate= [Date date];
            [newDate setDate:strDate];
            [newDate setType:[NSNumber numberWithInt:2]];
            [_medicine addDaysObject:newDate];
            [self.specificDays addObject:newDate];
        }
     
    } else if(self.pickerType == TimePicker){
        
        NSDate *date = _datePicker.date;
        NSNumber *secs = [NSNumber numberWithDouble:[date timeIntervalSince1970]]; //<- convert date to double
        /*NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
        dateFormat.timeZone = _datePicker.timeZone;
        [dateFormat setDateFormat:@"hh:mm aa"];
        NSString *strTime = [dateFormat stringFromDate:date]; //<- format the time*/
        
        Time *time = [Time time];
        time.time = secs;
        time.status = _medicine.meal;
        
        BOOL canAdd = YES;
        for(Time *t in self.times) {
            if([t.time isEqual:time.time]) {
                NSManagedObject *objectTime = time;
                [[ManageObjectModel objectManager] deleteObject:objectTime];
                canAdd = NO;
            }
        }
        
        if(canAdd) {
            [_medicine addTimesObject:time];
            [self.times addObject:time];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning:" message:@"Time selected already exist"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
        NSLog(@"Time is %@ and %d count", time,[MTProfileManager profileManager].timeList.count);
        
        [_tableView reloadData];
    }

    
    [_actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    self.actionSheet = nil;
    self.datePicker = nil;
    
}

- (UIDatePicker *)datePickerForActionSheet
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 0.0f, 0.0f)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.date = [NSDate dateWithTimeIntervalSince1970:0];
    return [datePicker autorelease];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (UIDatePicker *)timePickerForActionSheet
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 0.0f, 0.0f)];
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    datePicker.date = [NSDate dateWithTimeIntervalSince1970:0];
    return [datePicker autorelease];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (UIPickerView *)listPickerForActionSheet
{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 0.0f, 0.0f)];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    return [pickerView autorelease];
}
    
- (void)onButtonBackClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onButtonDoneClicked
{
    if(!(_medicine.days.count && _medicine.times.count)) {
        NSString *message = @"Have atleast single Date and Time!";
        
        if(!_medicine.days.count)
            message = @"Have atleast single Date!";
        else if(!_medicine.times.count)
            message = @"Please enter a time for this schedule";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning:" message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];

    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
     self.labelFrequencyValue.text = _medicine.frequency;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_specificDays addObjectsFromArray:[_medicine.days allObjects]];
    [_times addObjectsFromArray:[_medicine.times allObjects]];
    
    [_tableView reloadData];
    self.labelFrequencyValue.text = _medicine.frequency;
    
    if([_medicine.frequency isEqualToString:@"Weekly"] || [_medicine.frequency isEqualToString:@"Daily"]){
        self.labelFrequencyDayTitle.text = @"Day of Week";
    }
     else if([_medicine.frequency isEqualToString:@"Monthly"]) {
        self.labelFrequencyDayTitle.text = @"Day of Month";
    }
    else {
        self.labelFrequencyValue.text = @"Specific Date";
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
