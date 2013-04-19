//
//  Medicine.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/16/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "Medicine.h"
#import "Profile.h"
#import "Schedule.h"


@implementation Medicine

@dynamic meal;
@dynamic medicineImage;
@dynamic medicineName;
@dynamic quantity;
@dynamic status;
@dynamic unit;
@dynamic willRemind;
@dynamic medicineTaker;
@dynamic schedules;

@synthesize image = _image;

+ (Medicine *)medicine
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Medicine" inManagedObjectContext:[ManageObjectModel objectManager].managedObjectContext];
    return [[[Medicine alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:[ManageObjectModel objectManager].managedObjectContext] autorelease];
}

- (UIImage *)image
{
    if (!_image) {
        _image = [[UIImage imageWithData:self.medicineImage] retain];
    }
    return _image;
}

@end
