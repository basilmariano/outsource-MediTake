//
//  ManageObjectModel.m
//  DMDataModel
//
//  Created by Panfilo Mariano Jr. on 4/6/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "ManageObjectModel.h"

@implementation ManageObjectModel
{
    
@private
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

static ManageObjectModel *_object;

+ (id)objectManager {
    if (!_object) {
        _object = [[ManageObjectModel alloc] init];
    }
    return _object;
}

- (void)saveContext
{
    
    NSError *error = nil;
    NSManagedObjectContext *objectContext = self.managedObjectContext;
    if (objectContext != nil)
    {
        if ([objectContext hasChanges] && ![objectContext save:&error])
        {
            // add error handling here
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

/*-(void) howToFetch:(NSObject *) object andEntityName: (NSString *) entityNam
{
    // **** log objects currently in database ****
    // create fetch object, this object fetch's the objects out of the database
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Fruit" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *info in fetchedObjects)
    {
        NSLog(@"Fruit name: %@", [info valueForKey:@"fruitName"]);
        Source *tempSource = [info valueForKey:@"fruitSource"];
        NSLog(@"Source name: %@", tempSource.sourceName);
        
    }
    [fetchRequest release];
}
   


- (void) howCreateObject : (NSObject *) object andEntityName: (NSString *) entityName
{
    object *fruit = (NSObject *) [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:_man]
    fruit.fruitName = fruitNameString;
    Source *source = (Source *)[NSEntityDescription insertNewObjectForEntityForName:@"Source" inManagedObjectContext:managedObjectContext];
    source.sourceName = fruitSourceString;
    
    // Because we set the relationship fruitSource as not optional we must set the source here
    fruit.fruitSource = source;
    
}
*/


/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
-(NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil)
    {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    
    if (persistentStoreCoordinator != nil)
    {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataTabBarTutorial.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}

- (void)dealloc
{
    [managedObjectContext release];
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    [super dealloc];
}
@end
