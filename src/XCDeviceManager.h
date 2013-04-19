//
//  XCDeviceManager.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/18/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCDeviceManager : NSObject

typedef enum
{
    iPhone5_Device,
    iPhone4_Device,
    iPad_Device
}
iPhoneDevice;

@property (nonatomic) iPhoneDevice deviceType;
+(XCDeviceManager *) manager;

-(NSString *)xibNameForDevice:(NSString *)xibName;
extern BOOL isiPhone5Device;
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
@end
