//
//  MTTabBarItem.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/3/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTTabBarItem : UITabBarItem

@property(nonatomic,retain) UIButton *tabItemButton;

//<-Global Static function
//(e.g) public static MTTabBarItem itemButton(UIButton button)
+(MTTabBarItem *)itemButton: (UIButton *)itemButton;

@end
