//
//  RegisteredNotification.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/25/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Medicine;

@interface RegisteredNotification : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Medicine *medicine;

@end
