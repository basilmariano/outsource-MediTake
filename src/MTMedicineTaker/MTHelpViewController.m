//
//  MTHelpViewController.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/8/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MTHelpViewController.h"

@interface MTHelpViewController ()<UIScrollViewDelegate>
{
    UIImagePickerController *imagePicker;
}
@property(nonatomic,retain) UIImage *previousImage;
@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *button2;

@end

@implementation MTHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Help";
        
        UIImage *cancelImageInactive = [UIImage imageNamed:@"Ok-helpbox-ss.png"];
        UIImage *cancelImageActive = [UIImage imageNamed:@"Ok-helpbox-s.png"];
        
        UIButton *buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonCancel.frame = CGRectMake(0, 0, 0, 0);
        [buttonCancel setImage:cancelImageInactive forState:UIControlStateNormal];
        [buttonCancel setImage:cancelImageActive forState:UIControlStateHighlighted];
        [buttonCancel addTarget:self action:@selector(onButtonCancelClicked) forControlEvents:UIControlEventTouchUpInside];
        [buttonCancel setHidden:YES];
        
        UIBarButtonItem *barButtonCancel = [[[UIBarButtonItem alloc] initWithCustomView:buttonCancel]autorelease];
    
        self.navigationItem.leftBarButtonItem = barButtonCancel;
  
    }
    return self;
}

- (void) dealloc
{
    [_previousImage release];
    [super dealloc];
}
- (void) onButtonCancelClicked
{
    NSLog(@"Cancel Clicked");
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)okbuttonpressed:(id)sender
{
    NSLog(@"Cancel Clicked");
    [self.navigationController popViewControllerAnimated:YES];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

#pragma mark UIImagePickerControllerDelegate

- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.button2.frame.origin.y + self.button2.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
