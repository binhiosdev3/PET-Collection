//
//  FileManager.m
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/25/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "FileManager.h"
#import "StickerManager.h"
#import "SDWebImageDecoder.h"
#import "ZipArchive.h"

@implementation FileManager

static NSString *_rootLibraryPath = nil;
+ (NSString *)rootPath{
    if (_rootLibraryPath == nil) {
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *__autoreleasing error = nil;
        NSURL *applicationSupportDirectory = [fm URLForDirectory:NSApplicationSupportDirectory
                                                        inDomain:NSUserDomainMask
                                               appropriateForURL:nil
                                                          create:YES
                                                           error:&error];
        if (error) {
            NSLog(@"Could not create application support directory. %@", error);
            return nil;
        }
        
        NSURL *vodiFolder = [applicationSupportDirectory URLByAppendingPathComponent:@"PETCOLLECTION" isDirectory:YES];
        if(![fm fileExistsAtPath:vodiFolder.path]) {
            if (![fm createDirectoryAtPath:vodiFolder.path
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error]) {
                NSLog(@"Error creating Vodi folder %@", error);
                return nil;
            }
            
            BOOL success = [vodiFolder setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:&error];
            if(!success){
                NSLog(@"Error excluding %@ from backup %@", vodiFolder, error);
            }

        }
        
        NSURL *contentFolder = [vodiFolder URLByAppendingPathComponent:@"Content" isDirectory:YES];
        _rootLibraryPath = contentFolder.path;
        
        if(![fm fileExistsAtPath:_rootLibraryPath]) {
            if (![fm createDirectoryAtPath:_rootLibraryPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error]) {
                NSLog(@"Error creating content folder %@", error);
                return nil;
            }
        }
        
    }
    return _rootLibraryPath;
}

+ (NSURL *)stickerFileURL{
    NSURL *documentURL = [NSURL fileURLWithPath:[FileManager rootPath]];
    NSURL *stickerURL = [documentURL URLByAppendingPathComponent:[FileManager folderStickerName]];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:stickerURL.path]) {
        [fm createDirectoryAtPath:stickerURL.path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return stickerURL;
}

+ (void)copyDefaultStickerToResourceIfNeeded {
    for(NSString* packageId in DEFAULT_STICKER_PACKAGE) {
        [FileManager copyDefaultStickerIfNeedWithPackageId:packageId];
    }
}


+ (void)copyDefaultStickerIfNeedWithPackageId:(NSString*)packageId {
    NSURL *stickerURL = [[FileManager stickerFileURL] URLByAppendingPathComponent:packageId];
    NSFileManager *fm = [NSFileManager defaultManager];
    // copy file if need
    if (![fm fileExistsAtPath:stickerURL.path]) {
        // copy resource to stickers folder
        NSString *bundleStickersPath = [[NSBundle mainBundle].resourcePath stringByAppendingFormat:@"/%@/%@",[FileManager folderStickerName], packageId];
        NSError* err;
        BOOL success = [fm copyItemAtPath:bundleStickersPath toPath:stickerURL.path error:&err];
        if (!success) {
            NSLog(@"cannot copy default sticker %@ to cache...",packageId);
        }
        else {
            NSArray* arrNumOfSticker = DEFAULT_NUM_OF_STICKER_PACKAGE;
            NSArray* arrIsGif = DEFAULT_IS_GIF_STICKER_PACKAGE;
            int numOfSticker =  [[arrNumOfSticker objectAtIndex:packageId.intValue-1] intValue];
            BOOL isGif = [[arrIsGif objectAtIndex:packageId.intValue-1] intValue] == 1 ? YES : NO;
            [[StickerManager getInstance] addNewPackWithId:packageId numOfSticker:numOfSticker isAnimated:isGif];
            
        }
    }
}

+ (void)createStickerWithDictionary:(NSDictionary*)dict andData:(NSData*)data {
    NSString* packageId = [dict objectForKey:@"id"];
    int numOfStickers = [[dict objectForKey:@"numOfStick"] intValue];
    BOOL isGif = [[dict objectForKey:@"isGif"] intValue] == 1 ? YES : NO;
    NSURL *stickerURL = [[FileManager stickerFileURL] URLByAppendingPathComponent:packageId];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:stickerURL.path]) {
        //write and unzip data
        NSString* pathZipFile = [[FileManager stickerFileURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",packageId]].path;
        [data writeToFile:pathZipFile atomically:YES];
        // unzip file
        NSString *pathToExtract = [FileManager stickerFileURL].path;
        BOOL unzipError = NO;
        ZipArchive *zip	= [[ZipArchive alloc] init];
        
        if (![zip UnzipOpenFile:pathZipFile]) {
            // remove this archive file
            [fm removeItemAtPath:pathZipFile error:nil];
            unzipError = YES;
        }
        
        if (![zip UnzipFileTo:pathToExtract overWrite:YES]) {
            [fm removeItemAtPath:pathZipFile error:nil];
            unzipError = YES;
        }
        
        if (unzipError) {
            NSLog(@"Unzip error");
        }

        // close file
        [zip UnzipCloseFile];
        // remove archive file
        [fm removeItemAtPath:pathZipFile error:nil];
        if (!unzipError) {
            [[StickerManager getInstance] addNewPackWithId:packageId numOfSticker:numOfStickers isAnimated:isGif];
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_add_package_download_complete object:nil userInfo:nil];
        }
    }
}

+ (NSString*)folderStickerName {
    return @"Stickers";
}


+ (UIImage *)imageImmediateLoadWithContentsOfFile:(NSString *)path{
    NSURL* stickerUrl = [[FileManager stickerFileURL] URLByAppendingPathComponent:path];
    path = stickerUrl.path;
    if (!path) {
        return nil;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        return nil;
    }
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return [UIImage decodedAndScaledDownImageWithImage:image];
}
@end
