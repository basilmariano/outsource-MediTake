//
//  Schedule.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/18/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "Schedule.h"
#import "Date.h"
#import "Medicine.h"
#import "Time.h"


@implementation Schedule

@dynamic frequency;
@dynamic days;
@dynamic medicine;
@dynamic time;

+(Schedule *)schedule
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:[ManageObjectModel objectManager].managedObjectContext];
    return [[[Schedule alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:[ManageObjectModel objectManager].managedObjectContext] autorelease];
}

@end
