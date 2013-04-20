//
//  Time.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/20/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "Time.h"


@implementation Time

@dynamic time;
@dynamic medicine;

+ (Time *)time
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Time" inManagedObjectContext:[ManageObjectModel objectManager].managedObjectContext];
    return [[[Time alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:[ManageObjectModel objectManager].managedObjectContext] autorelease];
}

@end
