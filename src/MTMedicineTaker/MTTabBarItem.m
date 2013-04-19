//
//  MTTabBarItem.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/3/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MTTabBarItem.h"

@implementation MTTabBarItem

+ (MTTabBarItem *)itemButton: (UIButton *) itemButton
{
    MTTabBarItem *tabBarItem = [[MTTabBarItem alloc] init];
    tabBarItem.tabItemButton = itemButton;
    return [tabBarItem autorelease];
}

- (void) dealloc
{
    [_tabItemButton release];
    
    [super dealloc];
}

@end
