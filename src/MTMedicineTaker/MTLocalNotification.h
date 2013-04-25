//
//  MTLocalNotification.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/24/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTLocalNotification : NSObject

+(MTLocalNotification *)sharedInstance;

- (void)scheduleNotificationWithFireDate: (NSDate *)fireDate frequencyType:(NSNumber *)frequencyType andMedicine:(Medicine *)medicine;
- (void)showReminder:(NSString *)reminder;
- (void)clearNotification;

@end
