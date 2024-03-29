//
//  MTAppDelegate.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/3/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MTAppDelegate.h"
#import "MTTableViewController.h"
#import "MTNavigationViewController.h"
#import "MTTabBarItem.h"
#import "MTTabBarController.h"
#import "Profile.h"
#import "MTProfileViewController.h"
#import "MTReminderViewController.h"
#import "MTLocalNotification.h"

@implementation MTAppDelegate 

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    MTTableViewController *profile = [[[MTTableViewController alloc] initWithTableViewName:@"Profile" andEntityName:@"Profile" andSectionNumber:1] autorelease];
    
    MTReminderViewController *reminder =[[[MTReminderViewController alloc] initWithNibName:@"MTReminderViewController" bundle:nil]autorelease];
    
    MTTableViewController *profiles = [[[MTTableViewController alloc] initWithTableViewName:@"Profile" andEntityName:@"Profile" andSectionNumber:1] autorelease];
    
    MTReminderViewController *reminders =[[[MTReminderViewController alloc] initWithNibName:@"MTReminderViewController" bundle:nil]autorelease];
    
    UIImage *buttonRemindersNormal = [UIImage imageNamed:@"Reminder-s.png"];
    UIImage *buttonReminderPressed = [UIImage imageNamed:@"Reminder-ss.png"];
    UIImage *buttonProfileNormal = [UIImage imageNamed:@"Profile-s.png"];
    UIImage *buttonProfilePressed = [UIImage imageNamed:@"Profile-ss.png"];
    UIImage *splashImage = nil;
    
    UIButton *btnReminders = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnReminders setImage:buttonRemindersNormal forState:UIControlStateNormal];
    [btnReminders setImage:buttonReminderPressed forState:UIControlStateSelected];
    
    UIButton *btnRemindersz = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRemindersz setImage:buttonRemindersNormal forState:UIControlStateNormal];
    [btnRemindersz setImage:buttonReminderPressed forState:UIControlStateSelected];
    UIButton *btnProfilez = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnProfilez setImage:buttonProfileNormal forState:UIControlStateNormal];
    [btnProfilez setImage:buttonProfilePressed forState:UIControlStateSelected];
    
    UIButton *btnProfile = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnProfile setImage:buttonProfileNormal forState:UIControlStateNormal];
    [btnProfile setImage:buttonProfilePressed forState:UIControlStateSelected];
    
    if([[XCDeviceManager manager] deviceType] == iPhone4_Device ) { //IPHONE4
        btnRemindersz.frame = CGRectMake(0, 0, 160, 49);
        btnProfilez.frame = CGRectMake(160, 0, 160, 49);
        btnProfile.frame = CGRectMake(320, 0, 160, 49);
        btnReminders.frame = CGRectMake(480, 0, 160, 49);
        splashImage = [UIImage imageNamed:@"Default.png"];
    } else if([[XCDeviceManager manager] deviceType] == iPhone5_Device) {//IPHONE5
        btnReminders.frame = CGRectMake(0, 518, 160, 49);
        btnProfile.frame = CGRectMake(160, 518, 160, 49);
        btnProfile.frame = CGRectMake(320, 518, 160, 49);
        btnProfile.frame = CGRectMake(480, 518, 160, 49);
        splashImage = [UIImage imageNamed:@"Default-568h.png"];
    }
    

    MTNavigationViewController *reminderNavigation = [[[MTNavigationViewController alloc] initWithRootViewController:reminder] autorelease];
    reminderNavigation.tabBarItem = [MTTabBarItem itemButton:btnReminders];
    
    MTNavigationViewController *profileNavigation = [[[MTNavigationViewController alloc] initWithRootViewController:profile] autorelease];
    profileNavigation.tabBarItem = [MTTabBarItem itemButton:btnProfile];
    
    MTNavigationViewController *reminderNavigations = [[[MTNavigationViewController alloc] initWithRootViewController:reminders] autorelease];
    reminderNavigations.tabBarItem = [MTTabBarItem itemButton:btnRemindersz];
    
    MTNavigationViewController *profileNavigations = [[[MTNavigationViewController alloc] initWithRootViewController:profiles] autorelease];
    profileNavigations.tabBarItem = [MTTabBarItem itemButton:btnProfilez];
    
    MTTabBarController *tabBarController = [[[MTTabBarController alloc] initWithScrollViewTabImage:nil withScrollViewContentSize:CGSizeMake(160.0f + 160.0f + 160.0f + 160.0f, 49.0f) andScrollViewPositionY:431.0f andScrollViewHeight:49.0f] autorelease];
    tabBarController.delegate = self;
    tabBarController.viewControllers = [NSArray arrayWithObjects:reminderNavigation, profileNavigation, reminderNavigations, profileNavigations, nil];
    tabBarController.selectedIndex = 0;
   
    UIImageView *splashImageView = [[[UIImageView alloc] initWithImage:splashImage] autorelease];
    splashImageView.userInteractionEnabled = FALSE;
    
    [tabBarController.view addSubview:splashImageView];
    [self performSelector:@selector(removeSplashImageView:) withObject:splashImageView afterDelay:3];
    
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
	application.applicationIconBadgeNumber = 0;
    if (localNotification)
	{
		[[MTLocalNotification sharedInstance] handleReceivedNotification:localNotification];
    }
    
    return YES;
}

- (void) removeSplashImageView: (UIImageView *) imageView
{
    [imageView removeFromSuperview];
    //[imageView release];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSString *imageName = nil;
    MTNavigationViewController *nav = (MTNavigationViewController *) viewController;
    if (tabBarController.selectedIndex == 0) {
        
        imageName = @"PinkNavigationBar.png";
    }
    else
    {
        imageName = @"BlueNavigationBar.png";
    }
    nav.backgroundImageVIew.image =[UIImage imageNamed:imageName];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    application.applicationIconBadgeNumber = 0;
    [[MTLocalNotification sharedInstance] handleReceivedNotification:notification];

    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"NotifSound" ofType:@"wav"];
    AVAudioPlayer* theAudio=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path2] error:NULL];
    //theAudio.delegate = self;
    [theAudio play];

}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
