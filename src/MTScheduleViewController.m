//
//  MTScheduleViewController.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/18/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MTScheduleViewController.h"
#import "Time.h"
#import "Schedule.h"
#import "MTFrequencyDatesViewController.h"
#import "Date.h"
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
@property(nonatomic, assign) Schedule *schedule;

-(IBAction)frequencyButtonClicked:(id)sender;
-(IBAction)frequencyDayButtonClicked:(id)sender;
-(IBAction)buttonAddTimeClicked:(id)sender;

- (void)onButtonCancelClicked;
- (void)onButtonDoneClicked;
- (void)showPickerActionSheet:(NSString *)title;
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
        Schedule *sched = [Schedule schedule];
        self.schedule = sched;
        
        self.navigationItem.title = @"Schedule";
        _timeList = [[NSMutableArray alloc] init];
        _dayList = [[NSMutableArray alloc] init];
        
        UIImage *backImage = [UIImage imageNamed:@"ButtonBack.png"];
        
        UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonBack.frame = CGRectMake(0.0f, 0.0f, 50.0f, 27.0f);
        [buttonBack setImage:backImage forState:UIControlStateNormal];
        [buttonBack addTarget:self action:@selector(onButtonCancelClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButtonBack = [[[UIBarButtonItem alloc] initWithCustomView:buttonBack]autorelease];
        self.navigationItem.leftBarButtonItem = barButtonBack;
        
        UIImage *doneImage = [UIImage imageNamed:@"ButtonDone.png"];
        UIButton *buttonDone = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonDone.frame = CGRectMake(0, 0, 50, 26);
        [buttonDone setImage:doneImage forState:UIControlStateNormal];
        [buttonDone addTarget:self action:@selector(onButtonDoneClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButtonCancel = [[[UIBarButtonItem alloc] initWithCustomView:buttonDone]autorelease];
        self.navigationItem.rightBarButtonItem = barButtonCancel;
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
    [super dealloc];
}

+(MTScheduleViewController *) scheduleController
{
    return _instance;
}

-(IBAction)frequencyButtonClicked:(id)sender
{
    self.pickerType = ListPicker;
    [self showPickerActionSheet:@"Frequency"];
}

-(IBAction)frequencyDayButtonClicked:(id)sender
{
    if([self.labelFrequencyDayTitle.text isEqual:@"Date"]) {
        self.pickerType = DatePicker;
        [self showPickerActionSheet:@"Date"];
    } else {
        MTFrequencyDatesViewController *fequencyDatesViewController = [[MTFrequencyDatesViewController alloc] initWithFrequencyDayName:self.labelFrequencyValue.text];
        [self presentModalViewController:fequencyDatesViewController animated:YES];
    }
}

-(IBAction)buttonAddTimeClicked:(id)sender
{
    self.pickerType = TimePicker;
    [self showPickerActionSheet:@"Time"];
    NSLog(@"Add Time");
}

#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;//<- temp
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
    /*int selecteRow = (int) indexPath.row;
     
     if([_name isEqualToString:@"Reminders"])
     return  [self reminder:tableView andRow:selecteRow];
     else
     return  [self profile:tableView andRow:indexPath];
     */
    return  [[UITableViewCell alloc] init];
}

#pragma UITableViewDelegate

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

#pragma mark - UIPickerViewDataSource and UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)picker numberOfRowsInComponent:(NSInteger)component
{
    return 3;//_pickerList.count;
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
    
    switch (self.pickerType) {
        case ListPicker: {
            self.pickerView = [self listPickerForActionSheet];
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
            [actionSheet addSubview:self.datePicker];
            
            break;
        }
    }
    
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

        [MTMedicineInfoViewController stringInfo:self.labelFrequencyValue.text];
        
    } else if(self.pickerType == DatePicker) {
        
        NSDate *date = _datePicker.date;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        
        if([self.labelFrequencyDayTitle.text isEqual:@"Date"]) {
            
            dateFormat.timeZone = _datePicker.timeZone;
            [dateFormat setDateFormat:@"MMM:dd:yyyy"];
            NSString *strDate = [dateFormat stringFromDate:date]; //<- format the time
            
            if(![MTProfileManager profileManager].dateList)
                [MTProfileManager profileManager].dateList = [[[NSMutableArray alloc] init] autorelease];
           
                NSLog(@"str %@",strDate);
                Date *date = [Date date];
                [date setDate:strDate];
             
                [[MTProfileManager profileManager].dateList addObject:date];
                
                NSLog(@"Date is %@ and DateCounts are %d",date.date,[MTProfileManager profileManager].dateList.count);
            
        } else if(self.pickerType == TimePicker){
            
            dateFormat.timeZone = _datePicker.timeZone;
            [dateFormat setDateFormat:@"HH:mm: aa"];
            NSString *strTime = [dateFormat stringFromDate:date]; //<- format the time
            
            Time *time = [Time time];
            time.time = strTime;
            
            if(![[MTProfileManager profileManager] timeList])
                [MTProfileManager profileManager].timeList = [[[NSMutableArray alloc] init] autorelease];
            [[MTProfileManager profileManager].timeList addObject:time]; //<- add in the model array
            
            NSLog(@"Time is %@ and %d count", time,[MTProfileManager profileManager].timeList.count);

        }
    }
    
    [_actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    self.actionSheet = nil;
    self.datePicker = nil;
}

- (UIDatePicker *)datePickerForActionSheet
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 0.0f, 0.0f)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
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
    
- (void)onButtonCancelClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onButtonDoneClicked
{
    Schedule *schedule = [Schedule schedule];
    schedule.frequency = self.labelFrequencyValue.text;
    
    if([MTProfileManager profileManager].timeList) {
        for(Time *time in [MTProfileManager profileManager].timeList)
        {
            time.schedule = schedule;
            [schedule addTimeObject:time];
        }
    }
    if([MTProfileManager profileManager].dateList) {
        for(Date *date in [MTProfileManager profileManager].dateList){
            date.schedule = schedule;
            [schedule addDaysObject:date];
        }
    }
    
    if(![MTProfileManager profileManager].schedList)
        [MTProfileManager profileManager].schedList = [[[NSMutableArray alloc] init]autorelease];
        
    [[MTProfileManager profileManager].schedList addObject:schedule]; //<- added schedules to be saved soon as part of medicine
    NSLog(@"schedule %@, sched Count %d",schedule, [MTProfileManager profileManager].schedList.count);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Days k%@",self.dayList);
    NSLog(@"Time k%@",self.timeList);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.labelFrequencyValue.text = @"Weekly";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
