//
//  Date.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/20/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Date : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSManagedObject *medicine;

+(Date *)date;

@end
