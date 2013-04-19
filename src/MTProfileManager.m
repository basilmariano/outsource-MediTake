//
//  MTProfileManager.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/18/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MTProfileManager.h"
#import "Medicine.h"
@interface MTProfileManager ()

@end

static MTProfileManager *_instance;

@implementation MTProfileManager

+(MTProfileManager *)profileManager
{
    if(!_instance)
        _instance = [[MTProfileManager alloc] init];
    return _instance;
}

-(void) dealloc
{
    [_medicineList release];
    [_schedList release];
    [_dateList release];
    [_timeList release];
    [_profile dealloc];
    [super dealloc];
}


-(Profile *)profileWithName:(NSString *)profileName;
{
    if(_profile)
        if([_profile.name isEqualToString:profileName])
            return _profile;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profile" inManagedObjectContext:[[ManageObjectModel objectManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(name like %@)",profileName];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects =[[[ManageObjectModel objectManager] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
  
    _profile = (Profile *) [fetchedObjects objectAtIndex:0];
    
    NSLog(@"Profile name %@",_profile);
    return _profile;
}

-(void)addMedicine:(Medicine *)medicine
{
    NSLog(@"adding Medicine to taker name: %@",_profile.name);
    [_profile addMedicinesObject:medicine];
    [[ManageObjectModel objectManager] saveContext];
}

-(Medicine *)value
{
   return self.medicine;
}

@end
