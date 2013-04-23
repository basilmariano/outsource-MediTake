//
//  Medicine.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/20/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "Medicine.h"
#import "Date.h"
#import "Profile.h"
#import "Time.h"


@implementation Medicine

@dynamic frequency;
@dynamic meal;
@dynamic medicineImage;
@dynamic medicineName;
@dynamic quantity;
@dynamic status;
@dynamic unit;
@dynamic willRemind;
@dynamic medicineTaker;
@dynamic days;
@dynamic times;

@synthesize image = _image;

+ (Medicine *)medicine
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Medicine" inManagedObjectContext:[ManageObjectModel objectManager].managedObjectContext];
    Medicine *m = [[[Medicine alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:[ManageObjectModel objectManager].managedObjectContext] autorelease];
    m.frequency = @"Weekly";
    return m;
}

- (UIImage *)image
{
    if (!_image) {
        _image = [[UIImage imageWithData:self.medicineImage] retain];
    }
    return _image;
}

@end
