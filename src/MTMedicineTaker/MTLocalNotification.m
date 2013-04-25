//
//  MTLocalNotification.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/24/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MTLocalNotification.h"

static MTLocalNotification *_instance;

@implementation MTLocalNotification

+(MTLocalNotification *)sharedInstance {
    if(_instance == nil) {
        _instance = [[MTLocalNotification alloc] init];
    }
    return  _instance;
}

- (void) dealloc
{
    [super dealloc];
}

- (void)scheduleNotificationWithFireDate: (NSDate *)fireDate frequencyType:(NSNumber *)frequencyType andMedicine:(Medicine *)medicine {
	
   /* NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *compsNow = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | kCFCalendarUnitHour | kCFCalendarUnitMinute fromDate:now];
    
    NSDateComponents *compsFire = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | kCFCalendarUnitHour | kCFCalendarUnitMinute fromDate:fireDate];
    
    NSDate *current = [calendar dateFromComponents:compsNow];
    NSDate *fDate = [calendar dateFromComponents:compsFire];
	if(current > fDate) {
        return;
    }
    */
    Class cls = NSClassFromString(@"UILocalNotification");
	if (cls != nil) {
        
        NSArray *notificationList = [UIApplication sharedApplication].scheduledLocalNotifications;
        
        for(UILocalNotification *localNotif in notificationList) {
            if([localNotif.fireDate isEqualToDate:fireDate]) {
                NSManagedObject *object = medicine;
                NSString *strPK = [[[object objectID] URIRepresentation] absoluteString];
                NSString *tempPK = strPK;
                NSLog(@"Temp key %@",tempPK);
                NSDictionary *dict = localNotif.userInfo;
            
                NSString *alertBody = (NSString *) [dict objectForKey:@"Alert"];
                alertBody = [alertBody stringByAppendingFormat:@" and %@",medicine.medicineName];//<- update the body
                
                NSArray *medPKList = (NSArray *) [dict objectForKey:@"Medicines"]; //<- add medicinePK in list
                NSLog(@"PKList %d",medPKList.count);
                NSMutableArray *tempPkHolderList = [[[NSMutableArray alloc] init]autorelease];
                
                NSString *medicine_PK  = nil;
                for(NSString *primaryKey in medPKList) {
                    if([primaryKey isEqualToString:tempPK]) {
                        medicine_PK = primaryKey;
                        [tempPkHolderList addObject:primaryKey];
                    } else {
                        [tempPkHolderList addObject:primaryKey];
                    }
                }
                
                if(!medicine_PK)
                    [tempPkHolderList addObject:tempPK];
                NSLog(@"tempPkHolderList %d", tempPkHolderList.count);
                NSArray *finalPKList = [NSArray arrayWithArray:tempPkHolderList];
                
                NSDictionary *userInfoDictObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                    finalPKList, @"Medicines",
                                                    alertBody,@"Alert",
                                                    nil];
                
                [[UIApplication sharedApplication] cancelLocalNotification:localNotif];
                
                UILocalNotification *notif = [[cls alloc] init];
                notif.fireDate = fireDate;
                notif.timeZone = [NSTimeZone defaultTimeZone];
                
                notif.alertBody = alertBody;
                notif.alertAction = @"Show me";
                notif.soundName = UILocalNotificationDefaultSoundName;
                notif.applicationIconBadgeNumber = 1;
                
                switch ([frequencyType integerValue]) {
                    case 0:
                        notif.repeatInterval = NSWeekCalendarUnit;//<-weekly
                        break;
                    case 1:
                        notif.repeatInterval = NSMonthCalendarUnit;//<-date
                        break;
                    case 2:
                        notif.repeatInterval = 0;//<-date
                        break;
                }
                notif.userInfo = userInfoDictObject;
                [[UIApplication sharedApplication] scheduleLocalNotification:notif];
                [notif release];
                
                NSLog(@"dictObject %@",notif.userInfo);
               
                return;
            }
        }
        
       
        
		UILocalNotification *notif = [[cls alloc] init];
		notif.fireDate = fireDate;
		notif.timeZone = [NSTimeZone defaultTimeZone];
		
		notif.alertBody = [NSString stringWithFormat:@"Time to take Medicine! %@ ", medicine.medicineName];
		notif.alertAction = @"Show me";
		notif.soundName = UILocalNotificationDefaultSoundName;
		notif.applicationIconBadgeNumber = 1;
		
		switch ([frequencyType integerValue]) {
			case 0:
                notif.repeatInterval = NSWeekCalendarUnit;//<-weekly
				break;
			case 1:
                notif.repeatInterval = NSMonthCalendarUnit;//<-date
				break;
			case 2:
				notif.repeatInterval = 0;//<-date
				break;
		}
        
        NSManagedObject *object = medicine;
        NSString *strPK = [[[object objectID] URIRepresentation] absoluteString];
        NSMutableDictionary *dictObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        [NSArray arrayWithObject:strPK], @"Medicines",
                                 notif.alertBody, @"Alert",
                                 nil];
		notif.userInfo = dictObject;
		
		[[UIApplication sharedApplication] scheduleLocalNotification:notif];
		[notif release];
	}
}

- (void)showReminder:(NSString *)text {
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:text delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)clearNotification {
	
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void) handleReceivedNotification:(UILocalNotification*) thisNotification
{
	//NSLog(@"Received: %@",[thisNotification description]);
    [self showReminder:thisNotification.alertBody];
}
@end
