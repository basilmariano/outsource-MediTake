//
//  MTTabBarController.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/4/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MTTabBarController.h"
#import "MTTabBarItem.h"
#import "MTNavigationViewController.h"
#import "Profile.h"

@interface MTTabBarController ()

@property (nonatomic, retain) UINavigationItem *navItem;
@property (nonatomic, retain) UIScrollView *scrollView;

@end

@implementation MTTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return (self);
}

- (id)initWithBackgroundImage: (UIImage *)backgroundImage
{
    self = [super init];
    
    if(self)
    {
        self.background.image = backgroundImage;
    }
    
    return (self);
}

- (id)initWithScrollViewTabImage: (UIImage *) backgroundImage withScrollViewContentSize: (CGSize)scrollContentSize
          andScrollViewPositionY: (float) scrollPositionY
andScrollViewHeight: (float) scrollViewHeight
{
    self = [super init];
    
    if(self)
    {
        self.scrollView = [[[UIScrollView alloc] init] autorelease];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        [_scrollView setFrame:CGRectMake(0.0f, scrollPositionY, self.view.frame.size.width, scrollViewHeight)];
        [_scrollView setContentSize:scrollContentSize];
        [_scrollView setShowsHorizontalScrollIndicator:YES];
        [_scrollView setPagingEnabled:YES];
        
        [self.view addSubview:self.scrollView];
        self.background.image = backgroundImage;
    }
    
    return (self);
}

- (void)viewDidLoad
{
    [_navItem release];
    [_scrollView release];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (UINavigationItem *)navigationItem {
    if (!_navItem) {
        _navItem = [[UINavigationItem alloc] init];
    }
    return _navItem;
}

- (void)setNavController:(UINavigationController *)navController {
    _navController = navController;
    if (navController) {
        if (self.navController && [self.navController isKindOfClass:[MTNavigationViewController class]]) {
            MTNavigationViewController *navController = (MTNavigationViewController *)self.navController;
            navController.navigationTitle.text = self.selectedViewController.navigationItem.title;
        }
    }
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
   
    for ( UIViewController *controller in self.viewControllers ) {
        
        MTTabBarItem *item = (MTTabBarItem *) controller.tabBarItem;
        NSAssert([item isKindOfClass:[MTTabBarItem class]], @"must use MTTabBarItem for tabBarItem");
        MTTabBarItem *tabBarItem = (MTTabBarItem *) item;
        [tabBarItem.tabItemButton addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.scrollView) {
            [self.scrollView addSubview:tabBarItem.tabItemButton];
        } else {
            [self.view addSubview:tabBarItem.tabItemButton];
        }
        
    }
}

- (void)tabButtonClicked: (UIButton *) itemButton
{
    for(int selectedIndex = 0; selectedIndex < [self.viewControllers count]; selectedIndex++) {
        
        UIViewController *controller = [self.viewControllers objectAtIndex:selectedIndex];
        UITabBarItem *item = controller.tabBarItem;
        NSAssert([item isKindOfClass:[MTTabBarItem class]], @"must use MTTabBarItem for tabBarItem");
        MTTabBarItem *tabBarItem = (MTTabBarItem *) item;
        if(itemButton == tabBarItem.tabItemButton){
            
            tabBarItem.tabItemButton.selected = YES;
            self.selectedIndex = selectedIndex;
            break;
        }
        else{
            
            tabBarItem.tabItemButton.selected = NO;
        }
    }
}

- (void) setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    if (selectedIndex < [self.viewControllers count]) {
        
     for (int index = 0; index < [self.viewControllers count]; index++) {
        
         UIViewController *controller = (UIViewController *) [self.viewControllers objectAtIndex: index];
         UITabBarItem *item = (UITabBarItem *) controller.tabBarItem;
         NSAssert([item isKindOfClass: [MTTabBarItem class]], @"must use MTTabBarItem for tabBarItem");
         MTTabBarItem *tabBarItem = (MTTabBarItem *) item;
         if(selectedIndex == index)
         {
             self.navItem.title = controller.navigationItem.title;
             if(self.navController && [self.navController isKindOfClass:[MTNavigationViewController class]]) {
            
                 MTNavigationViewController *navViewController = (MTNavigationViewController *) self.navController;
                 navViewController.navigationTitle.text = controller.navigationItem.title;
             }
            
             tabBarItem.tabItemButton.selected = YES;
         }
         else
         {
             tabBarItem.tabItemButton.selected = NO;
         }
        
         if(self.delegate && [self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        
             [self.delegate performSelector:@selector(tabBarController:didSelectViewController:) withObject:self withObject:[self.viewControllers objectAtIndex:selectedIndex]];
         }
     }
        
    }
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if([Profile profileCount] == 0){
    
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [_background release];
    //[self.navigationItem release];
    [super dealloc];
}
@end
