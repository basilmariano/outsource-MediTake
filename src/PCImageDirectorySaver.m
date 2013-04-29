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

-(NSString *)saveImageInDocumentFileWithImageData:(NSData *)pngData andAppendingImageName:(NSString *)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:imageName]; //Add the file name
    [pngData writeToFile:filePath atomically:YES]; //Write the file
    return filePath;
}

-(UIImage *)imageFilePath:(NSString *)path
{
    NSData *pngData = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage imageWithData:pngData];
    return image;
}

@end
