//
//  XCDeviceManager.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/18/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "XCDeviceManager.h"

@interface XCDeviceManager ()

@end

static XCDeviceManager *_instance;

@implementation XCDeviceManager

BOOL isiPhone5Device = NO;

+(XCDeviceManager *) manager
{
    if(!_instance) {
        _instance = [[XCDeviceManager alloc] init];
    }
    
    return  _instance;
}

- (id)init
{
    if (self = [super init]) {
        if(isiPhone5Device) {
            NSLog(@"isIphone = %d",isiPhone5Device);
            _deviceType = iPhone5_Device;
        }
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480) {
                _deviceType = iPhone4_Device;
            } else if(result.height == 568) {
                _deviceType = iPhone5_Device;
            }
        } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _deviceType = iPad_Device;
        }
    }
    return self;
}

-(NSString *)xibNameForDevice:(NSString *)xibName
{
    if(_deviceType == iPhone5_Device) {
        NSString *filename = [xibName stringByDeletingPathExtension];
        NSString *extension = [xibName pathExtension];
        NSString *dot = @"";
        if (extension && [extension length]) {
            dot = @".";
        }
        return [NSString stringWithFormat:@"%@-h568%@%@", filename, dot, extension];
    }
    return xibName;
}

@end
