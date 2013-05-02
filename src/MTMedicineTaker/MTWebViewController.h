//
//  MTWebViewController.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 5/2/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicatior;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
- (id) initWithSearchString:(NSString *)seachValue;

@end
