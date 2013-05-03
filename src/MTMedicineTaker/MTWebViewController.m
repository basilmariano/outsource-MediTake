//
//  MTWebViewController.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 5/2/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MTWebViewController.h"

@interface MTWebViewController ()
@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) NSString *searchValue;
@end

@implementation MTWebViewController

- (id) initWithSearchString:(NSString *)seachValue
{
    NSString *nibName =[[XCDeviceManager manager] xibNameForDevice:@"MTWebViewController"];
    
    self = [super initWithNibName:nibName bundle:nil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = seachValue;
        self.searchValue = seachValue;
        
        UIImage *backImageInActive = [UIImage imageNamed:@"Back-pink_btn-ss.png"];
        UIImage *backImageActive = [UIImage imageNamed:@"Back-pink_btn-s.png"];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backButton.frame = CGRectMake(0.0f, 0.0f, 61.0f, 33.5f);
        [_backButton setImage:backImageInActive forState:UIControlStateNormal];
        [_backButton setImage:backImageActive forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(onButtonBackClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButtonBack = [[[UIBarButtonItem alloc] initWithCustomView:_backButton]autorelease];
        self.navigationItem.leftBarButtonItem = barButtonBack;
    }
    return  self;
}

-(void) dealloc
{
    [_backButton release];
    [_webView release];
    [_loadingIndicatior release];
    [_searchValue release];
    [super dealloc];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // report the error inside the webview
    if ([error code] != NSURLErrorCancelled) {
        NSString* errorString = [NSString stringWithFormat:
                                 
                                 @"<html><center><font size=+1 color='black'><br><br><br>An error occurred:<br>%@</font></center></html>",
                                 
                                 error.localizedDescription];
        
        [webView loadHTMLString:errorString baseURL:nil];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.loadingIndicatior setHidden:NO];
    [self.loadingIndicatior startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadingIndicatior setHidden:YES];
    [self.loadingIndicatior stopAnimating];
    webView.scalesPageToFit = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) onButtonBackClicked
{
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        [self.loadingIndicatior stopAnimating];
        //[self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *stringTest = [NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@",_searchValue];
    NSURL *url = [NSURL URLWithString:stringTest];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestObj];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
