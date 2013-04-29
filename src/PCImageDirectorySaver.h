//
//  PCImageDirectorySaver.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/29/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCImageDirectorySaver : NSObject

+(PCImageDirectorySaver *)directorySaver;
-(NSString *)saveImageInDocumentFileWithImageData:(NSData *)pngData andAppendingImageName:(NSString *)imageName;
-(UIImage *)imageFilePath:(NSString *)path;

@end
