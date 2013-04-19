//
//  MTProfileManager.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/18/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"
#import "Medicine.h"
#import "Schedule.h"

@interface MTProfileManager : NSObject

@property(nonatomic, retain) Profile *profile;
@property(nonatomic, retain) Medicine *medicine;
@property(nonatomic, retain) Schedule *tempSched;
@property(nonatomic, retain) NSMutableArray *schedList;
@property(nonatomic, retain) NSMutableArray *medicineList;
@property(nonatomic, retain) NSMutableArray *dateList;
@property(nonatomic, retain) NSMutableArray *timeList;

+(MTProfileManager *) profileManager;
-(Profile *)profileWithName:(NSString *)profileName;
-(void)addMedicine:(Medicine *)medicine;
-(Medicine *)value;
@end
