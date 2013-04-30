//
//  PCImageDirectorySaver.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/29/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "PCImageDirectorySaver.h"

@interface PCImageDirectorySaver ();

@end

static PCImageDirectorySaver *_instance;

@implementation PCImageDirectorySaver

+(PCImageDirectorySaver *)directorySaver
{
    if(!_instance)
        _instance = [[PCImageDirectorySaver alloc] init];
    return _instance;
}

-(NSString *)saveImageInDocumentFileWithImage:(UIImage *)image andAppendingImageName:(NSString *)imageName
{
    NSData *pngData = UIImagePNGRepresentation(image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:imageName]; //Add the file name
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        
        NSError *error = nil;
        if ([fileMgr removeItemAtPath:filePath error:&error] != YES)
            NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        
        filePath = [documentsPath stringByAppendingPathComponent:imageName]; //Add the file name
    }
    [pngData writeToFile:filePath atomically:YES]; //Write the file
    return filePath;
}

-(UIImage *)imageFilePath:(NSString *)path
{
    NSData *pngData = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage imageWithData:pngData];
    return image;
}

- (UIImage *)scaleImage:(UIImage *)image  withScaleToSize: (CGSize)size
{
    UIImage *cropedImage = [self cropImageWithImage:image];
    NSLog(@"CropedImage %f %f",cropedImage.size.width, cropedImage.size.height);
    // Scalling selected image to targeted size
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    
    if(cropedImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM(context, -M_PI_2);
        CGContextTranslateCTM(context, -size.height, 0.0f);
        CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), cropedImage.CGImage);
    }
    else
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), cropedImage.CGImage);
    
    CGImageRef scaledImage=CGBitmapContextCreateImage(context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    UIImage *finalImage = [UIImage imageWithCGImage: scaledImage];
    CGImageRelease(scaledImage);
    
    return finalImage;
}

- (UIImage *)cropImageWithImage:(UIImage *)image
{
    float imageWidth  = image.size.width;
    float imageHeight = image.size.height;
    float widthOffset = 0.0f;
    float heightOffset = 0.0f;
    float cropSize    = (imageWidth > imageHeight) ? imageHeight : imageWidth;
    
    widthOffset  = (imageWidth - cropSize)/2;
    heightOffset = (imageHeight - cropSize)/2;
    
    CGRect cropRect = CGRectMake(widthOffset, heightOffset, cropSize, cropSize);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    NSLog(@"CropedImage %f %f",finalImage.size.width, finalImage.size.height);
    return  finalImage;
}

@end
