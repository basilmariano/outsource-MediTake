//
//  Profile.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/16/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "Profile.h"
#import "Medicine.h"


@implementation Profile

@dynamic name;
@dynamic profileImage;
@dynamic medicines;

@synthesize image = _image;

+(NSInteger)profileCount
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init]autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profile" inManagedObjectContext:[[ManageObjectModel objectManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects =[[[ManageObjectModel objectManager] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects.count;
}

+ (Profile *)profile
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Profile" inManagedObjectContext:[ManageObjectModel objectManager].managedObjectContext];
    return [[[Profile alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:[ManageObjectModel objectManager].managedObjectContext] autorelease];
}

+ (NSArray *)profileList
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init]autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profile" inManagedObjectContext:[[ManageObjectModel objectManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [[[ManageObjectModel objectManager] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    return  fetchedObjects;
}

- (UIImage *)image
{
    if (!_image) {
        _image = [[UIImage imageWithData:self.profileImage] retain];
    }
    return _image;
}

@end
