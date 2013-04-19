//
//  Schedule.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/18/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Date, Medicine, Time;

@interface Schedule : NSManagedObject

@property (nonatomic, retain) NSString * frequency;
@property (nonatomic, retain) NSSet *days;
@property (nonatomic, retain) Medicine *medicine;
@property (nonatomic, retain) NSSet *time;
@end

@interface Schedule (CoreDataGeneratedAccessors)

- (void)addDaysObject:(Date *)value;
- (void)removeDaysObject:(Date *)value;
- (void)addDays:(NSSet *)values;
- (void)removeDays:(NSSet *)values;
- (void)addTimeObject:(Time *)value;
- (void)removeTimeObject:(Time *)value;
- (void)addTime:(NSSet *)values;
- (void)removeTime:(NSSet *)values;

+(Schedule *)schedule;

@end
