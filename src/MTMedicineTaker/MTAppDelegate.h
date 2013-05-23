//
//  MTAppDelegate.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/3/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AVFoundation/AVFoundation.h>

@class MTViewController;

@interface MTAppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
