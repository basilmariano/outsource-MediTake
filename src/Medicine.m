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
#import "RegisteredNotification.h"

@implementation Medicine

@dynamic frequency;
@dynamic meal;
@dynamic medicineImagePath;
@dynamic medicineName;
@dynamic quantity;
@dynamic status;
@dynamic unit;
@dynamic willRemind;
@dynamic medicineTaker;
@dynamic days;
@dynamic times;
@dynamic notifications;
//@dynamic idKey;

//@synthesize image = _image;

+ (Medicine *)medicine
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Medicine" inManagedObjectContext:[ManageObjectModel objectManager].managedObjectContext];
    Medicine *m = [[[Medicine alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:[ManageObjectModel objectManager].managedObjectContext] autorelease];
    m.frequency = @"Weekly";
    return m;
}

/*- (UIImage *)image
{
    if (!_image) {
        _image = [[UIImage imageWithData:self.medicineImage] retain];
    }
    return _image;
}*/

-(Medicine *)medicineWithId:(NSNumber *)medId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medicine" inManagedObjectContext:[[ManageObjectModel objectManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(_PK = %d)",medId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects =[[[ManageObjectModel objectManager] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    Medicine *med = (Medicine *) [fetchedObjects objectAtIndex:0];
    NSLog(@"Profile name %@",med);
    return med;
    
}

-(Medicine *)medicineWithName:(NSString *)medicineName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medicine" inManagedObjectContext:[[ManageObjectModel objectManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(medicineName like %@)",medicineName];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects =[[[ManageObjectModel objectManager] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    Medicine *med = (Medicine *) [fetchedObjects objectAtIndex:0];
    NSLog(@"Profile name %@",med);
    return med;
}

+ (NSArray *)medicineList
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init]autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medicine" inManagedObjectContext:[[ManageObjectModel objectManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [[[ManageObjectModel objectManager] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    return  fetchedObjects;
}

@end
