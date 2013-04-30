//
//  UIImage+NSData.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/10/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "UIImage+NSData.h"

@implementation UIImage(NSData)

- (NSData *)data {
    return UIImagePNGRepresentation(self);
}
@end
