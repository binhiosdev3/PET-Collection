//
//  FileManager.m
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/25/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "FileManager.h"
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
    BOOL isProduct = [[userDefaults objectForKey:IS_PRODUCTION] boolValue];
    int num = isProduct ? NUM_DEFAULT_PACK_PRO : NUM_DEFAULT_PACK_DEMO;
    for(int i = 0; i < num; i++) {
        [FileManager copyDefaultStickerIfNeedAtIndex:i];
    }
}


+ (void)copyDefaultStickerIfNeedAtIndex:(int)index {
    NSString* packageId = [DEFAULT_STICKER_PACKAGE objectAtIndex:index];
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
            int numOfSticker =  [[DEFAULT_NUM_OF_STICKER_PACKAGE objectAtIndex:index] intValue];
            BOOL isGif = [[DEFAULT_IS_GIF_STICKER_PACKAGE objectAtIndex:index] intValue] == 1 ? YES : NO;
            NSString* title = [DEFAULT_STICKER_PACKAGE_NAME objectAtIndex:index];
            NSString* productID = [DEFAULT_STICKER_PACKAGE_PRODUCTID objectAtIndex:index];
            [[StickerManager getInstance] addNewProductID:(NSString*)productID
                                              numOfSticker:numOfSticker
                                                isAnimated:isGif
                                                     title:title
                                                     group:@""
                                                    price:@"0.99"];
            
        }
    }
}

+ (void)createStickerWithDictionary:(NSDictionary*)dict andData:(NSData*)data {
    NSString* productID = [dict objectForKey:@"product_id"];
    NSString* group = [dict objectForKey:@"group"];
    NSString* title = [dict objectForKey:@"title"];
    int numOfStickers = [[dict objectForKey:@"numOfStick"] intValue];
    BOOL isGif = [[dict objectForKey:@"isGif"] intValue] == 1 ? YES : NO;
    NSString* price = [dict objectForKey:@"price"];
    NSURL *stickerURL = [[FileManager stickerFileURL] URLByAppendingPathComponent:productID];
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:stickerURL.path]) {
        [fm removeItemAtPath:stickerURL.path error:nil];
    }
    if (![fm fileExistsAtPath:stickerURL.path]) {
        //write and unzip data
        NSString* pathZipFile = [[FileManager stickerFileURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",productID]].path;
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
            [[StickerManager getInstance] addNewProductID:(NSString*)productID
                                              numOfSticker:numOfStickers
                                                isAnimated:isGif
                                                     title:title
                                                     group:group
                                                    price:price];
            
        }
    }
}

+ (NSString*)folderStickerName {
    return @"Stickers";
}

+ (void)deleteStickerPackage:(StickerPack*)pack {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString* pathPack = [NSString stringWithFormat:@"%@/%@", [FileManager stickerFileURL].path,pack.productID];
    NSError* err;
    if ([fm fileExistsAtPath:pathPack]) {
        [fm removeItemAtPath:pathPack error:&err];
    }
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
