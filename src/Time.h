//
//  Time.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/18/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Schedule;

@interface Time : NSManagedObject

@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) Schedule *schedule;

+ (Time *)time;
@end
