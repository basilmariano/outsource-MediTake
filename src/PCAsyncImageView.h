//
//  PCAsyncImageView.h
//  PICClinic
//
//  Created by Wong Johnson on 2/7/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PCAsyncImageView;

@protocol PCAsyncImageViewDelegate<NSObject>
@optional
- (UIImage *)asyncImageView:(PCAsyncImageView *)asyncImageView didLoadData:(NSData *)data;
- (void)didLoadAsyncImageView:(PCAsyncImageView *)asyncImageView;
- (void)clickedAsyncImageView:(PCAsyncImageView *)asyncImageView;

@end

@interface PCAsyncImageView : UIView
{
    NSURLConnection* _connection;
    NSMutableData* _data;
    NSURL *_url;
    
    UIImageView *_imageView;
    NSObject *_userData;
    id<PCAsyncImageViewDelegate> _delegate;
    
    UIImage *_spinnerImage;
    UIActivityIndicatorView *_indicator;
    UIActivityIndicatorViewStyle _indicatorStyle;
}

@property (nonatomic, retain) NSObject *userData;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, assign) IBOutlet id<PCAsyncImageViewDelegate> delegate;
@property (nonatomic) UIActivityIndicatorViewStyle indicatorStyle;
@property (nonatomic, copy) NSString *prefix;

- (void)setSpinnerImage:(UIImage*)image;
- (void)loadImageFromURL:(NSURL*)url;
- (void)clearImage;

@end
