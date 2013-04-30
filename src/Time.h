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

@property (nonatomic, retain) NSNumber *time;
@property (nonatomic, retain) NSManagedObject *medicine;
@property (nonatomic, retain) NSString *status;

+ (Time *)time;
/* NSdate *date;
 
 NSNumber *num = [NSNumber numberWithDouble:[date timeIntervalSince1970]];
 
 NSDate *date = [NSDate dateWithTimeIntervalSince1970:[num doubleValue]];
 
 [NSDateFormatter]
 
 
 [NSNumber numberWithDouble:[[NSDate dateWithTimeIntervalSince1970:0.0] timeoutInterval]];
 */
@end
