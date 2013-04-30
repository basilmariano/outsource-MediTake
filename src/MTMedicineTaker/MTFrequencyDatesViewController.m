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
        if([frequencyName isEqualToString:@"Weekly"] || [frequencyName isEqualToString:@"Daily"]) {
            for (int i = 1; i < 8; i++)  {
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
    
    NSString *value = [[_dayList objectAtIndex:indexPath.row] valueForKey:[[NSNumber numberWithInt: indexPath.row] stringValue]];
    
    BOOL exist = NO;
    if(self.selectedFrequencyDay) {
        for(Date *d in self.selectedFrequencyDay) {
            
            if([d.date isEqualToString:value]) {
                [_medicine removeDaysObject:d];
                [self.selectedFrequencyDay removeObject:d];
                [[ManageObjectModel objectManager] deleteObject:d];
                NSLog(@"DATE REMOVED : %@",d.date);
                exist = YES;
                break;
            }
        }
    }
    if(!exist) {
        Date *date = [Date date];
        if ([_frequencyName isEqualToString:@"Weekly"] || [self.frequencyName isEqualToString:@"Daily"]) {
            date.type = [NSNumber numberWithInt:0];
        } else { // Monthly
            date.type = [NSNumber numberWithInt:1];
        }
        date.date = value;
        
        [_medicine addDaysObject:date];
        [self.selectedFrequencyDay addObject:date];
        NSLog(@"DATE ADDED : %@",date.date);
    }
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
    if(self.switcher.on) {
        for(int i = 0; i < _dayList.count ; i++) {
            BOOL exist = NO;
            NSString *strValue = [[_dayList objectAtIndex:i] valueForKey:[[NSNumber numberWithInt:i] stringValue]];
            if(self.selectedFrequencyDay) {
                
                for(Date *date in self.selectedFrequencyDay) {
                    if([date.date isEqualToString:strValue]) {
                        exist = YES;
                        break;
                    }
                }
            }
            
            if(!exist) {
                Date *date = [Date date];
                date.date = strValue;
                date.type = [NSNumber numberWithInt:0];
                [_medicine addDaysObject:date];
                [self.selectedFrequencyDay addObject:date];
            }
        }
    } else {
        for(int i = 0; i < _dayList.count ; i++) {
            NSString *strValue = [[_dayList objectAtIndex:i] valueForKey:[[NSNumber numberWithInt:i] stringValue]];
            if(self.selectedFrequencyDay) {
                
                for(Date *date in self.selectedFrequencyDay) {
                    
                    if([date.date isEqualToString:strValue]) {
                        NSManagedObject *object = date;
                        [[ManageObjectModel objectManager] deleteObject:object];
                        break;
                    }
                }
            }
        }
        
        [self.selectedFrequencyDay removeAllObjects];
    }

    [_tableView reloadData];
}

- (IBAction)onButtonDoneClicked:(id)sender
{
    if([self.frequencyName isEqualToString:@"Weekly"] || [self.frequencyName isEqualToString:@"Daily"]) {

        if(self.switcher.on || self.selectedFrequencyDay.count == 7) {
            _medicine.frequency = @"Daily";
        }
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.selectedFrequencyDay addObjectsFromArray:[_medicine.days allObjects]];
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.switcher.on = NO;
    if([self.frequencyName isEqualToString:@"Weekly"] || [self.frequencyName isEqualToString:@"Daily"]) {
      [self.frequencyWeekView setHidden:NO];
        self.monthIndicator.text = @"Day of the Week";
    }
    else {
        //[self.monthIndicator setHidden:NO];
        self.monthIndicator.text = @"Day of the Month";
        self.tableView.frame = CGRectMake(0.0, 43.0, 320.0f, 393.0f);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
