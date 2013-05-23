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

- (void)scheduleNotificationWithFireDate: (NSDate *)fireDate frequencyType:(NSNumber *)frequencyType andDayValue: (Date *)day andMedicine:(Medicine *)medicine {
	NSLog(@"day %@",day);
    Class cls = NSClassFromString(@"UILocalNotification");
	if (cls != nil) {
        
        NSArray *notificationList = [UIApplication sharedApplication].scheduledLocalNotifications;
        
        for(UILocalNotification *localNotif in notificationList) {
            if([localNotif.fireDate isEqualToDate:fireDate]) {
                NSManagedObject *object = medicine;
                NSString *strPK         = [[[object objectID] URIRepresentation] absoluteString];
                NSString *tempPK        = strPK;
                
                NSManagedObject *object2 = day;
                NSString *strPK2         = [[[object2 objectID] URIRepresentation] absoluteString];
                
                NSDictionary *dict      = localNotif.userInfo;
                NSMutableArray *tempPkHolderList = [[[NSMutableArray alloc] init]autorelease];
                NSMutableArray *tempDayHolderList = [[[NSMutableArray alloc] init]autorelease];
                NSArray *medPKList      = (NSArray *) [dict objectForKey:@"Medicines"]; //<- add medicinePK in list
                
                NSString *medicine_PK  = nil;
                for(NSString *primaryKey in medPKList) {
                    if([primaryKey isEqualToString:tempPK]) {
                       /* medicine_PK = primaryKey;
                        [tempPkHolderList addObject:primaryKey];*/
                        return;
                    } else {
                        [tempPkHolderList addObject:primaryKey];
                        [tempDayHolderList addObject:strPK2];
                    }
                }
                
                if(!medicine_PK) {
                    [tempPkHolderList addObject:tempPK];
                    [tempDayHolderList addObject:day];
                }
                
                NSString *alertBody = (NSString *) [dict objectForKey:@"Alert"];
                alertBody = [alertBody stringByAppendingFormat:@" and %@",medicine.medicineName];//<- update the body
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
        
        NSManagedObject *objectD = day;
        NSString *strPKDay = [[[objectD objectID] URIRepresentation] absoluteString];
        
        NSMutableDictionary *dictObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        [NSArray arrayWithObject:strPK], @"Medicines",
        [NSArray arrayWithObject:strPKDay], @"day",
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

- (void)deleteNotificationWithMedicine:(Medicine *)medicine fromNotification:(UILocalNotification *)notification
{
    if(notification) {
        NSString *alertBody = @"";
        NSDictionary *dict  = notification.userInfo;
        NSArray *medPKList  = (NSArray *) [dict objectForKey:@"Medicines"];
        NSMutableArray *tempPkHolderList = [[[NSMutableArray alloc] init]autorelease];
        
        if(medPKList.count > 1) {
            for(NSString *pk in medPKList) {
                NSManagedObject *object = medicine;
                NSString *medicinePK    = [[[object objectID] URIRepresentation] absoluteString];
                
                if(![medicinePK isEqualToString:pk]){
                    [tempPkHolderList addObject:pk];
                    NSManagedObject *managedObject = [[[ManageObjectModel objectManager] managedObjectContext] objectWithID: [[[ManageObjectModel objectManager] persistentStoreCoordinator] managedObjectIDForURIRepresentation:[NSURL URLWithString:pk]]];
                    
                    Medicine *med = (Medicine *) managedObject;
                    alertBody     = [alertBody stringByAppendingFormat:@"Time to take Medicine! %@, ",med.medicineName];//<- update the body
                }
            }
        } else{
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            return;
        }
        
        NSArray *finalPKList = [NSArray arrayWithArray:tempPkHolderList];
        NSDictionary *userInfoDictObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            finalPKList, @"Medicines",
                                            alertBody,@"Alert",
                                            nil];
        
        Class cls = NSClassFromString(@"UILocalNotification");
        
        UILocalNotification *notif = [[cls alloc] init];
        notif.fireDate = notification.fireDate;
        notif.timeZone = [NSTimeZone defaultTimeZone];
        
        notif.alertBody      = notification.alertBody;
        notif.alertAction    = @"Show me";
        notif.soundName      = UILocalNotificationDefaultSoundName;
        notif.applicationIconBadgeNumber = 1;
        notif.repeatInterval = notification.repeatInterval;
        notif.userInfo       = userInfoDictObject;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
        [notif release];
        NSLog(@"dictObject %@",notif.userInfo);
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    } else {
        NSArray *notificationList = [UIApplication sharedApplication].scheduledLocalNotifications;
        for(UILocalNotification *localNotif in notificationList) {
            NSDictionary *dict      = localNotif.userInfo;
            NSManagedObject *object = medicine;
            NSString *medicinePK    = [[[object objectID] URIRepresentation] absoluteString];
            NSArray *medPKList      = (NSArray *) [dict objectForKey:@"Medicines"];
            
            for(NSString *strPK in medPKList) {
                if([strPK isEqualToString:medicinePK]) {
                    [self deleteNotificationWithMedicine:medicine fromNotification:localNotif];//<-do recursion
                }
            }
        }
    }
}

- (void)cancelNotificationWithMedicine: (Medicine *)medicine withDay:(Date *)day
{
    NSArray *notificationList = [UIApplication sharedApplication].scheduledLocalNotifications;
    for(UILocalNotification *localNotif in notificationList) {
        //check if in localNotif
        NSArray *notificationList = [UIApplication sharedApplication].scheduledLocalNotifications;
        for(UILocalNotification *localNotif in notificationList) {
           /* NSDictionary *dict    = localNotif.userInfo;
            NSArray *dayList      = (NSArray *) [dict objectForKey:@"day"];
            
            NSManagedObject *objectD = day;
            NSString *strPKDay = [[[objectD objectID] URIRepresentation] absoluteString];
            
            for(NSString *specificDay in dayList) {
                
                if([specificDay isEqualToString:strPKDay]) {
                    
                    [self deleteNotificationWithMedicine:medicine fromNotification:localNotif];//<-do recursion

                }
            }*/
            
            NSDictionary *dict    = localNotif.userInfo;
            NSArray *dayList      = (NSArray *) [dict objectForKey:@"day"];
            NSLog(@"dayLIstCouhnt %@",dayList);
            
            for(NSString *strDay in dayList) {
                
                NSManagedObject *objectD = day;
                NSString *strPKDay = [[[objectD objectID] URIRepresentation] absoluteString];
                NSLog(@"%@ ==  %@", strDay, strPKDay);
                if([strPKDay isEqualToString:strDay]) {
                    //[[MTLocalNotification sharedInstance] cancelNotificationWithMedicine:self.medicine withDay:date];
                    [self deleteNotificationWithMedicine:medicine fromNotification:localNotif];//<-do recursion
                }
            }
        }

    }

}

- (void)cancelNotificationWithMedicine: (Medicine *)medicine andFireDate:(NSDate *)fireTime
{
    NSArray *notificationList = [UIApplication sharedApplication].scheduledLocalNotifications;
    for(UILocalNotification *localNotif in notificationList) {
        
        NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormat setDateFormat:@"hh:mm aa"];
        NSString *strNotifFTime = [dateFormat stringFromDate:localNotif.fireDate];
        
        NSDateFormatter *dateFormat2 = [[[NSDateFormatter alloc] init] autorelease];
        dateFormat2.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormat2 setDateFormat:@"hh:mm aa"];
        NSString *strFTime = [dateFormat2 stringFromDate:fireTime];
        
        if([strFTime isEqualToString:strNotifFTime]) {
            NSDictionary *dict      = localNotif.userInfo;
            NSManagedObject *object = medicine;
            NSString *medicinePK    = [[[object objectID] URIRepresentation] absoluteString];
            NSArray *medPKList      = (NSArray *) [dict objectForKey:@"Medicines"];
            
            for(NSString *strPK in medPKList) {
                if([strPK isEqualToString:medicinePK]) {
                    [self deleteNotificationWithMedicine:medicine fromNotification:localNotif];//<-do recursion
                }
            }
        }
    }
}

- (BOOL)isNotificationExistWithMedicine: (Medicine *)medicine andFireTime:(NSDate *)fireTime
{
    BOOL exist = NO;
    NSArray *notificationList = [UIApplication sharedApplication].scheduledLocalNotifications;
    for(UILocalNotification *localNotif in notificationList) {
        
        NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormat setDateFormat:@"hh:mm aa"];
        NSString *strNotifFTime = [dateFormat stringFromDate:localNotif.fireDate];
        
        NSDateFormatter *dateFormat2 = [[[NSDateFormatter alloc] init] autorelease];
        dateFormat2.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormat2 setDateFormat:@"hh:mm aa"];
        NSString *strFTime = [dateFormat2 stringFromDate:fireTime];
        
        if([strFTime isEqualToString:strNotifFTime]) {
            NSDictionary *dict      = localNotif.userInfo;
            NSManagedObject *object = medicine;
            NSString *medicinePK    = [[[object objectID] URIRepresentation] absoluteString];
            NSArray *medPKList      = (NSArray *) [dict objectForKey:@"Medicines"];
            
            for(NSString *strPK in medPKList) {
                if([strPK isEqualToString:medicinePK]) {
                    exist = YES;
                }
            }
        }
    }
    NSLog(@"Exits %d",exist);
    return  exist;
}

- (NSMutableArray *) medicineNotificationList:(Medicine *)medicine
{
    NSMutableArray *medicineInLocalNotificationList = [NSMutableArray array];
    
    NSArray *localNotificationList = [UIApplication sharedApplication].scheduledLocalNotifications;
    for(UILocalNotification *localNotif in localNotificationList) {
        NSDictionary *dict      = localNotif.userInfo;
        NSArray *medPKList      = (NSArray *) [dict objectForKey:@"Medicines"];
        
        NSManagedObject *object = medicine;
        NSString *medicinePK    = [[[object objectID] URIRepresentation] absoluteString];
        
        for(NSString *strPK in medPKList) {
            if([strPK isEqualToString:medicinePK]) {
                [medicineInLocalNotificationList addObject:localNotif];
            }
        }
    }
    
    return medicineInLocalNotificationList;
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
