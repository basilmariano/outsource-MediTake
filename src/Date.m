//
//  Date.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/18/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "Date.h"
#import "Schedule.h"


@implementation Date

@dynamic date;
@dynamic schedule;

+(Date *)date
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Date" inManagedObjectContext:[ManageObjectModel objectManager].managedObjectContext];
    return [[[Date alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:[ManageObjectModel objectManager].managedObjectContext] autorelease];
}

@end
