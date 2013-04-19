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
    for (NSString *str in self.selectedFrequencyDay) {
        if([str isEqualToString:tbCell.textLabel.text])
            exist = YES;
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
        for (NSString *str in self.selectedFrequencyDay) {
            if([str isEqualToString:value])
                exist = YES;
        }
    }
     MTFrequencyCell *cell = (MTFrequencyCell *) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    if(!exist) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
       [ self.selectedFrequencyDay addObject:value];
    } else {
        [self.selectedFrequencyDay removeObject:value];
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
            NSString *strValue = [[_dayList objectAtIndex:i] valueForKey:[[NSNumber numberWithInt:i] stringValue]];
            [self.selectedFrequencyDay addObject: strValue];
        }
    }else {
       /* if(_previousData.count) {
            NSLog(@"asd %d",_previousData.count);
            [self.selectedFrequencyDay removeAllObjects];
             NSLog(@"asd %d",_previousData.count);
            for(NSString *str in self.previousData) {
                [self.selectedFrequencyDay addObject:str];
            }
        }
        else
        {
            NSLog(@"asd");
        }*/
    }
    
    [_tableView reloadData];
}

- (IBAction)onButtonDoneClicked:(id)sender
{
    if(![MTProfileManager profileManager].dateList)
        [MTProfileManager profileManager].dateList = [[[NSMutableArray alloc] init] autorelease];
    for(NSString *str in _selectedFrequencyDay) {
        NSLog(@"str %@",str);
        Date *date = [Date date];
        [date setDate:str];
        //[[MTScheduleViewController scheduleController].dayList addObject:date];
        
        [[MTProfileManager profileManager].dateList addObject:date];
        
        NSLog(@"Date is %@ and DateCounts are %d",date.date,[MTProfileManager profileManager].dateList.count);
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.switcher.on = NO;
    // Do any additional setup after loading the view from its nib.
    if([self.frequencyName isEqualToString:@"Weekly"])
      [self.frequencyWeekView setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
