//
//  Medicine.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/16/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Profile, Schedule;

@interface Medicine : NSManagedObject

@property (nonatomic, retain) NSString * meal;
@property (nonatomic, retain) NSData * medicineImage;
@property (nonatomic, retain) NSString * medicineName;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSNumber * willRemind;
@property (nonatomic, retain) Profile *medicineTaker;
@property (nonatomic, retain) NSSet *schedules;
@property (nonatomic, readonly) UIImage *image;

@end

@interface Medicine (CoreDataGeneratedAccessors)

- (void)addSchedulesObject:(Schedule *)value;
- (void)removeSchedulesObject:(Schedule *)value;
- (void)addSchedules:(NSSet *)values;
- (void)removeSchedules:(NSSet *)values;
+ (Medicine *)medicine;
@end
