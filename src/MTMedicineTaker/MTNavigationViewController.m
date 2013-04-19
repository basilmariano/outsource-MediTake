//
//  MTNavigationViewController.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/3/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MTNavigationViewController.h"
#import "MTTabBarController.h"

@interface MTNavigationViewController ()
@property (nonatomic, retain) UIView *dummyView;
@end

@implementation MTNavigationViewController

@synthesize navigationTitle = _navigationTitle;

- (UINavigationBar *) navigationBar
{
    UINavigationBar *navigationbar = [super navigationBar];
    
    if(!_backgroundImageVIew) {
        
        if([navigationbar.subviews count]) 
            [[navigationbar.subviews objectAtIndex:0] removeFromSuperview];
        
        self.backgroundImageVIew = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BlueBackGround.png"]] autorelease]; //<- set the default background you like for navigation
        [navigationbar addSubview:_backgroundImageVIew];
    }
    
    [navigationbar addSubview:self.navigationTitle];
    [navigationbar sendSubviewToBack:self.navigationTitle];
    [navigationbar sendSubviewToBack:_backgroundImageVIew];
        
        _backgroundImageVIew.frame = CGRectMake(0.0f, 0.0f, 320.0f, 45.0f);
        
    return  navigationbar;
}

-(void) dealloc
{
    [_dummyView release];
    [_navigationTitle release];
    [_backgroundImageName release];
    [_backgroundImageVIew release];
    [super dealloc];
}

- (UILabel *) navigationTitle
{
   if(!_navigationTitle){
       
       _navigationTitle = [[UILabel alloc] init];
       _navigationTitle.textAlignment = UITextAlignmentCenter;
       _navigationTitle.textColor = [UIColor whiteColor];
       _navigationTitle.backgroundColor = [UIColor clearColor];
       _navigationTitle.frame = CGRectMake(30, 12, 250, 25);
       [_navigationTitle setFont:[UIFont fontWithName:@"Helvetica" size:20.0f]];
       _navigationTitle.font = [UIFont boldSystemFontOfSize:20.0f];
      
   }
     return _navigationTitle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([viewController isKindOfClass:[MTTabBarController class]]) {
        MTTabBarController *tabBarController = (MTTabBarController *)viewController;
        tabBarController.navController = self;
    }
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark UINavigationBarDelegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
    if (!_dummyView) {
        _dummyView = [[UIView alloc] init];
    }
    item.titleView = _dummyView;
    _navigationTitle.text = item.title;
    return TRUE;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    _navigationTitle.text = [[navigationBar.items objectAtIndex:navigationBar.items.count - 2] title];
    return TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
