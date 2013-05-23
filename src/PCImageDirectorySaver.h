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
-(NSString *)saveImageInDocumentFileWithImage:(UIImage *)image andAppendingImageName:(NSString *)imageName;
-(UIImage *)imageFilePath:(NSString *)path;
-(UIImage *)scaleImage:(UIImage *)image  withScaleToSize: (CGSize)size;
- (NSString *) replaceFile: (NSString *)oldPath withImage: (UIImage *)image withNewFile: (NSString *)newFilePath;

@end
