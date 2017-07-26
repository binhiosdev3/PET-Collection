//
//  FileManager.h
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/25/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"

@interface FileManager : NSObject

+ (NSString *)rootPath;
+ (NSURL *)stickerFileURL;
+ (void)copyDefaultStickerToResourceIfNeeded;
+ (UIImage *)imageImmediateLoadWithContentsOfFile:(NSString *)path;
@end
