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
	
	Class cls = NSClassFromString(@"UILocalNotification");
	if (cls != nil) {
        
        //<- loop all the notification to check if incomming notification data already exist (e.g) date and time notification get medicine id and add to the dictionary on current user info
        //[UIApplication sharedApplication].scheduledLocalNotifications
		
		UILocalNotification *notif = [[cls alloc] init];
		notif.fireDate = fireDate;
		notif.timeZone = [NSTimeZone defaultTimeZone];
		
		notif.alertBody = [NSString stringWithFormat:@"Time to take %@!", medicine.medicineName];
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
        
        [NSDictionary dictionaryWithObjectsAndKeys:
        [NSArray arrayWithObjects:@"1", @"2", nil], @"Medicines",
                                    notif.alertBody, notif,
                                    nil];
		
		NSDictionary *userDict = [NSDictionary dictionaryWithObject:notif.alertBody
                                                             forKey:notif];
		notif.userInfo = userDict;
		
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

@end
