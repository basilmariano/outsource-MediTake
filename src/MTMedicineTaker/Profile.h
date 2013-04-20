//
//  Profile.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/16/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Medicine;

@interface Profile : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * profileImage;
@property (nonatomic, retain) NSSet *medicines;
@property (nonatomic, readonly) UIImage *image;

@end

@interface Profile (CoreDataGeneratedAccessors)

- (void)addMedicinesObject:(Medicine *)value;
- (void)removeMedicinesObject:(Medicine *)value;
- (void)addMedicines:(NSSet *)values;
- (void)removeMedicines:(NSSet *)values;

+ (NSInteger)profileCount;
+ (NSArray *)profileList;
+ (Profile *)profile;
@end