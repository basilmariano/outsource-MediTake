//
//  Time.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/20/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Time : NSManagedObject

@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSManagedObject *medicine;

+ (Time *)time;

@end
