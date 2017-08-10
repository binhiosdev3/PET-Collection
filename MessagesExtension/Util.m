//
//  Util.m
//  PET Sticker Collection
//
//  Created by vietthaibinh on 8/4/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "Util.h"
#import "ZPReachability.h"


void da_main(dispatch_block_t block) {
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}

void da_syncMain(dispatch_block_t block) {
    dispatch_sync(dispatch_get_main_queue(), ^{
        block();
    });
}

void da_default(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        block();
    });
}

void da_background(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0), ^{
        block();
    });
}

void da_high(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
        block();
    });
}

void da_low(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{
        block();
    });
}

void delayOnMain(int64_t time, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

void delayOnQueue(dispatch_queue_t queue, int64_t time, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), queue, ^{
        block();
    });
}

void da_mainSafeWithBlock(dispatch_block_t block){
    if ([NSThread isMainThread]) {
        block();
    }
    else{
        da_main(block);
    }
}

void da_syncMainSafeWithBlock(dispatch_block_t block){
    if ([NSThread isMainThread]) {
        block();
    }
    else{
        da_syncMain(block);
    }
}

void dp_performBlockOnMainThreadAndWait(dispatch_block_t block, BOOL waitUntilDone){
    if (waitUntilDone) {
        if ([NSThread isMainThread]) {
            block();
        }
        else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                block();
            });
        }
    }
    else{
        da_main(block);
    }
}

@implementation NSObject (Blocks)

- (void)safeThreadWithBlock:(void (^)())block {
    da_mainSafeWithBlock(block);
}

- (void)performSelectorWithBlock:(void(^)())block{
    [self performSelectorWithBlock:block afterDelay:0];
}

- (void)performSelectorWithBlock:(void(^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        block();
    });
}

@end
@implementation Util

+ (void)getConfigIfNeededWithCompleteBlock:(ResponseObjectCompleteBlock)completeBlock {
    BOOL isProduction = [[userDefaults objectForKey:IS_PRODUCTION] boolValue];
    if(!isProduction) {
        [Util getDataFromSerVer:CONFIG_URL completeBlock:^(NSString *responseObject) {
            NSDictionary* dictJson  =  [NSJSONSerialization JSONObjectWithData:[responseObject dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
            BOOL pro =  [[dictJson objectForKey:@"product"] boolValue];
            NSString* jsonUrl = [dictJson objectForKey:@"json_url"];
            [userDefaults setObject:@(pro) forKey:IS_PRODUCTION];
            [userDefaults setObject:jsonUrl forKey:JSON_URL_KEY];
            [userDefaults synchronize];
            if(pro) {
                [FileManager copyDefaultStickerToResourceIfNeeded];
            }
            if(completeBlock) completeBlock(responseObject);
        }];
    }
}

+ (void)getDataFromSerVer:(NSString *)url completeBlock:(ResponseObjectCompleteBlock)completeBlock {
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:url]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                if(data) {
                    NSString* responeStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    if(completeBlock) completeBlock(responeStr);
                }
                if(error){
                    [Util showAlertWithTitle:@"Error" andMessage:@"Oopps! Can not connect to server. Please try again!"];
                }
            }] resume];
}

+ (BOOL)isInternetActived {
    BOOL isInternetActive = [ZPReachability getInstance].isInternetActived;
    return isInternetActive;
}

+ (void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)mesages {
        NSMutableDictionary* usrInfo = [NSMutableDictionary new];
        [usrInfo setObject:title forKey:@"title"];
        [usrInfo setObject:mesages forKey:@"message"];
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_show_alert object:nil userInfo:usrInfo];
}

+ (void)downloadPackage:(NSString*)stringURL andDict:(NSDictionary*)dict {
    [[StickerManager getInstance].arrDownloadingPack addObject:[dict objectForKey:@"product_id"]];
    dispatch_queue_t queue = dispatch_get_global_queue(0,0);
    dispatch_async(queue, ^{
        NSLog(@"Beginning download");
        NSURL  *url = [NSURL URLWithString:stringURL];
//        NSData *urlData = [NSData dataWithContentsOfURL:url];
        NSError* error = nil;
        NSData* urlData = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
        [[StickerManager getInstance].arrDownloadingPack removeObject:[dict objectForKey:@"product_id"]];
        if (error) {
            [Util showAlertWithTitle:@"Error" andMessage:@"Download error! Please check your connection and try again!"];
            [[NSNotificationCenter defaultCenter] postNotificationName:notification_add_package_download_complete object:nil userInfo:nil];
        } else {
            NSLog(@"Got the data!");
            //Save the data
            NSLog(@"Saving");
            [FileManager createStickerWithDictionary:dict andData:urlData];
        }
    });
}

@end
