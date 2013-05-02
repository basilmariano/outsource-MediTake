//
//  Medicine.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/20/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Date, Profile, Time, RegisteredNotification;

@interface Medicine : NSManagedObject

@property (nonatomic, retain) NSString * frequency;
@property (nonatomic, retain) NSString * meal;
@property (nonatomic, retain) NSString * medicineImagePath;
@property (nonatomic, retain) NSString * medicineName;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSNumber * willRemind;

@property (nonatomic, retain) Profile *medicineTaker;
@property (nonatomic, retain) NSSet *days;
@property (nonatomic, retain) NSSet *times;
@property (nonatomic, retain) NSSet *notifications;

@end

@interface Medicine (CoreDataGeneratedAccessors)

- (void)addDaysObject:(Date *)value;
- (void)removeDaysObject:(Date *)value;
- (void)addDays:(NSSet *)values;
- (void)removeDays:(NSSet *)values;
- (void)addTimesObject:(Time *)value;
- (void)removeTimesObject:(Time *)value;
- (void)addTimes:(NSSet *)values;
- (void)removeTimes:(NSSet *)values;
- (void)addNotifications:(NSSet *)values;
- (void)removeNotifications:(NSSet *)values;

- (Medicine *)medicineWithId:(NSNumber *)medId;
- (Medicine *)medicineWithName:(NSString *)medicineNamel;
+ (Medicine *)medicine;
+ (NSArray *)medicineList;

@end
