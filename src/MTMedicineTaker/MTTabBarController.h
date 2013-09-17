//
//  MTTabBarController.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/4/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTTabBarController : UITabBarController

@property (nonatomic,retain) UIImageView *background;
@property (nonatomic, assign) UINavigationController *navController;

-(id)initWithBackgroundImage: (UIImage *)backgroundImage;
- (id)initWithScrollViewTabImage: (UIImage *) backgroundImage
       withScrollViewContentSize: (CGSize)scrollContentSize
          andScrollViewPositionY: (float) scrollPositionY
             andScrollViewHeight: (float) scrollViewHeight;
@end
