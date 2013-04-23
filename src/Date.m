//
//  Date.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/20/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "Date.h"


@implementation Date

@dynamic date;
@dynamic type;
@dynamic medicine;

+(Date *)date
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Date" inManagedObjectContext:[ManageObjectModel objectManager].managedObjectContext];
    return [[[Date alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:[ManageObjectModel objectManager].managedObjectContext] autorelease];
}

@end
