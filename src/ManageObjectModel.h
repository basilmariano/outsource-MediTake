//
//  ManageObjectModel.h
//  DMDataModel
//
//  Created by Panfilo Mariano Jr. on 4/6/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManageObjectModel : NSObject <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;
- (void)deleteObject:(NSManagedObject *)object;
- (void)rollback;
+ (ManageObjectModel *) objectManager;

@end
