//
//  PCAsyncImageView.m
//  PICClinic
//
//  Created by Wong Johnson on 2/7/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "PCAsyncImageView.h"

@implementation PCAsyncImageView

- (void)dealloc
{
	[_connection cancel];
	[_connection release];
	[_data release];
	[_userData release];
	[_url release];
    [_spinnerImage release];
    [super dealloc];
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	if (_imageView)
		_imageView.frame = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
	if (_indicator)
		_indicator.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        //self.contentMode = UIViewContentModeTopLeft;
        _imageView = [[[UIImageView alloc] init] autorelease];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _imageView.opaque = NO;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
       // self.opaque = YES;
        
        [self addSubview:_imageView];
       _imageView.frame = self.bounds;
        [_imageView setNeedsLayout];
        [self setNeedsLayout];
    }
    return _imageView;
}

- (void)setSpinnerImage:(UIImage*)image
{
    if (_spinnerImage) {
        [_spinnerImage release];
    }
    _spinnerImage = [image retain];
}

- (void)loadImageFromURL:(NSURL*)url
{
	[self clearImage];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *fileName = [[url absoluteString] lastPathComponent];
    if (_prefix) {
        fileName = [_prefix stringByAppendingString:fileName];
    }
	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		_data = [[NSMutableData alloc] initWithContentsOfMappedFile:filePath];
		if (_data) {
			[self createImage];
            
			return;
		}
	}
	_url = [url retain];
    if (_spinnerImage == nil) {
        if (_indicator == nil) {
            
            _indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
            _indicator.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
            [self addSubview:_indicator];
        }
        [_indicator startAnimating];
    } else {
        self.imageView.image = _spinnerImage;
    }
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[_connection start];
}

- (void)loadImageFromCoreData {
    
}

#pragma mark NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (_data == nil) {
		_data = [[NSMutableData alloc] initWithCapacity:2048];
	}
	[_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
	[_connection release];
	_connection = nil;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [[_url absoluteString] lastPathComponent];
    if (_prefix) {
        fileName = [_prefix stringByAppendingString:fileName];
    }
	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
	[_data writeToFile:filePath atomically:YES];
	[_url release];
	_url = nil;
	
	[self createImage];
	
	if (_indicator) {
		[_indicator stopAnimating];
		[_indicator removeFromSuperview];
		_indicator = nil;
	}
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (_delegate && [_delegate respondsToSelector:@selector(clickedAsyncImageView:)]) {
		UITouch *touch = [touches anyObject];
		if ([self pointInside:[touch locationInView:self] withEvent:event]) {
            [_delegate performSelector:@selector(clickedAsyncImageView:) withObject:self];
        }
	}
}

- (void)createImage
{
	UIImage *image = nil;
	if (_delegate && [_delegate respondsToSelector:@selector(asyncImageView:didLoadData:)]) {
		image = [_delegate performSelector:@selector(asyncImageView:didLoadData:) withObject:self withObject:_data];
    }
	if (image == nil) {
		image = [UIImage imageWithData:_data];
    }
    self.imageView.image = image;
	[_data release];
	_data = nil;
	
	if (_delegate && [_delegate respondsToSelector:@selector(didLoadAsyncImageView:)]) {
        [_delegate performSelector:@selector(didLoadAsyncImageView:) withObject:self];
    }
}

- (void)clearImage
{
	if (_connection != nil) {
		[_connection cancel];
		[_connection release];
		_connection = nil;
	}
	if (_data != nil) {
		[_data release];
		_data = nil;
	}
	if (_imageView) {
		[_imageView removeFromSuperview];
		_imageView = nil;
	}
	if (_indicator) {
		[_indicator removeFromSuperview];
		_indicator = nil;
	}
	if (_url) {
		[_url release];
		_url = nil;
	}
}

@end
