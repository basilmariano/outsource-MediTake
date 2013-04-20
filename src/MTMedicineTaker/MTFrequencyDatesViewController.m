//
//  MTFrequencyDatesViewController.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/19/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MTFrequencyDatesViewController.h"
#import "MTFrequencyCell.h"
#import "Date.h"
#import "MTScheduleViewController.h"

@interface MTFrequencyDatesViewController ()

@property(nonatomic,retain) NSString *frequencyName;
@property(nonatomic,retain) NSMutableArray *dayList;
@property(nonatomic,retain) NSMutableArray *selectedFrequencyDay;
@property(nonatomic,retain) NSArray *previousData;
@property(nonatomic,retain) NSMutableArray *activeDayList;
@end

@implementation MTFrequencyDatesViewController


- (id)initWithFrequencyDayName:(NSString *)frequencyName
{
    NSLog(@"frequency: %@",frequencyName);
    NSString *nibName = [[XCDeviceManager manager] xibNameForDevice:@"MTFrequencyDatesViewController"];
    self = [super initWithNibName:nibName bundle:nil];
    if (self) {
        // Custom initialization
        _selectedFrequencyDay = [[NSMutableArray alloc] init];
        _dayList = [[NSMutableArray alloc] init];
        self.frequencyName = frequencyName;
        NSString *value = [[[NSString alloc] init] autorelease];
        if([frequencyName isEqualToString:@"Weekly"]) {
            for (int i = 1; i<8; i++)  {
                int keyInt = i - 1;
                NSNumber *numberKey = [NSNumber numberWithInt:keyInt];
                switch (i) {
                    case 1:{
                        value = @"Monday";
                        break;
                    }
                    case 2: {
                        value = @"Tuesday";
                        break;
                    }
                    case 3: {
                        value = @"Wednesday";
                        break;
                    }
                    case 4: {
                        value = @"Thursday";
                        break;
                    }
                    case 5: {
                        value = @"Friday";
                        break;
                    }
                    case 6: {
                        value = @"Saturday";
                        break;
                    }
                    case 7: {
                        value = @"Sunday";
                        break;
                    }
                }
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:value,[numberKey stringValue], nil];
                [_dayList addObject:dic];
            }
            NSLog(@"_dayList %@",_dayList);
        } else if ([frequencyName isEqualToString:@"Monthly"]){
            for (int i = 1; i<32; i++)  {
         
                NSNumber *number = [NSNumber numberWithInt:i];
                int keyInt = i - 1;
                 NSNumber *numberKey = [NSNumber numberWithInt:keyInt];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[number stringValue],[numberKey stringValue], nil];
                [_dayList addObject:dic];
            }
            NSLog(@"_dayList %@",_dayList);
        }
    }
    return self;
}

- (void) dealloc
{
    [_frequencyName release];
    [_tableView release];
    [_selectedFrequencyDay release];
    [_medicine release];
    [_frequencyWeekView release];
    [_buttonDone release];
    [_switcher release];
    [_monthIndicator release];
    [_activeDayList release];
    [super dealloc];
}

#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _dayList.count;
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
    MTFrequencyCell *tbCell = (MTFrequencyCell *) [tableView dequeueReusableCellWithIdentifier:@"MTFrequencyCell"];
   
    if (tbCell == nil) {
        
        tbCell = [[[NSBundle mainBundle] loadNibNamed:@"MTFrequencyCell" owner:self options:nil]objectAtIndex:0];
        
    }
    
    NSLog(@"VAlue %@",[[_dayList objectAtIndex:indexPath.row] valueForKey:[[NSNumber numberWithInt: indexPath.row] stringValue]]);
    tbCell.textLabel.text = [[_dayList objectAtIndex:indexPath.row] valueForKey:[[NSNumber numberWithInt: indexPath.row] stringValue]];
    
    BOOL exist = NO;
   /* for (NSString *str in self.selectedFrequencyDay) {
        if([str isEqualToString:tbCell.textLabel.text])
            exist = YES;
    }*/
    
    for(Date *date in self.selectedFrequencyDay) {
        if([date.date isEqualToString:tbCell.textLabel.text]) {
            exist = YES;
        }
    }
    
    if(!exist)
        [tbCell setAccessoryType:UITableViewCellAccessoryNone];
    else
        [tbCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    return tbCell;
   
}


#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.switcher.on)
        return;
    
    BOOL exist = NO;
    NSString *value = [[_dayList objectAtIndex:indexPath.row] valueForKey:[[NSNumber numberWithInt: indexPath.row] stringValue]];
    if(self.selectedFrequencyDay) {

       /* for (NSString *str in self.selectedFrequencyDay) {
            
            if([str isEqualToString:value]){
                [self.selectedFrequencyDay removeObject:str];
                exist = YES;
                break;
            }
        }*/
        for(Date *date in self.selectedFrequencyDay) {
            if([date.date isEqualToString:value]) {
                NSManagedObject *object = date;
                [[ManageObjectModel objectManager] deleteObject:object];
                [self.selectedFrequencyDay removeObject:date];
                NSLog(@"DATE REMOVED : %@",date.date);
                exist = YES;
                break;
            }
        }
    }
    MTFrequencyCell *cell = (MTFrequencyCell *) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    if(!exist) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        Date *date = [Date date];
        date.date = value;
        [_medicine addDaysObject:date];
        [self.selectedFrequencyDay addObject:date];
        NSLog(@"DATE ADDED : %@",date.date);
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell layoutSubviews];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  indexPath;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)weekFrequencySwitcher:(id)sender
{
    if(!self.previousData)
        _previousData = [[NSArray alloc] init];
    
    if(self.switcher.on) {
        self.previousData  = self.selectedFrequencyDay;
        
        [self.selectedFrequencyDay removeAllObjects];
        for(int i = 0; i < _dayList.count ; i++)
        {
            BOOL exist = NO;
            NSString *strValue = [[_dayList objectAtIndex:i] valueForKey:[[NSNumber numberWithInt:i] stringValue]];
            if(self.selectedFrequencyDay) {
                
                for(Date *date in self.selectedFrequencyDay) {
                    if([date.date isEqualToString:strValue]) {
                        NSManagedObject *object = date;
                        [[ManageObjectModel objectManager] deleteObject:object];
                        [self.selectedFrequencyDay removeObject:date];
                        exist = YES;
                        break;
                    }
                }
            }
            
            if(!exist) {
                Date *date = [Date date];
                date.date = strValue;
                [_medicine addDaysObject:date];
                [self.selectedFrequencyDay addObject:date];
            }
        }
    }

    [_tableView reloadData];
}

- (IBAction)onButtonDoneClicked:(id)sender
{
    /* BOOL exist = NO;
    for(NSString *str in _selectedFrequencyDay) {
        exist = NO;
        for(Date *d in self.activeDayList) {
            if([d.date isEqualToString:str]) {
                exist = YES;
              
            }
        }
        
        if(!exist) {
            Date *date = [Date date];
            date.date = str;
            [_medicine addDaysObject: date];
        }
    }*/
    
    /*if(self.selectedFrequencyDay) {
        for(Date *date in self.selectedFrequencyDay) {
            [_medicine addDaysObject:date];
        }
    }*/
    [self dismissModalViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    /*self.activeDayList = [NSMutableArray array];
    [_activeDayList addObjectsFromArray:[_medicine.days allObjects]];
    for(NSObject *obj in _activeDayList) {
        Date *date = (Date *) obj;
        [self.selectedFrequencyDay addObject:date.date];
    }*/
    
    [self.selectedFrequencyDay addObjectsFromArray:[_medicine.days allObjects]];
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.switcher.on = NO;
    if([self.frequencyName isEqualToString:@"Weekly"]) {
      [self.frequencyWeekView setHidden:NO];
    }
    else {
        [self.monthIndicator setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
