//
//  Util.h
//  PET Sticker Collection
//
//  Created by vietthaibinh on 8/4/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
extern void da_main(dispatch_block_t block);
extern void da_syncMain(dispatch_block_t block);
extern void da_default(dispatch_block_t block);
extern void da_background(dispatch_block_t block);
extern void da_high(dispatch_block_t block);
extern void da_low(dispatch_block_t block);
extern void delayOnMain(int64_t time, dispatch_block_t block);
extern void delayOnQueue(dispatch_queue_t queue, int64_t time, dispatch_block_t block);
extern void da_mainSafeWithBlock(dispatch_block_t block);
extern void da_syncMainSafeWithBlock(dispatch_block_t block);
extern void dp_performBlockOnMainThreadAndWait(dispatch_block_t block, BOOL waitUntilDone);

@interface NSObject (Blocks)

- (void)safeThreadWithBlock:(void (^)())block;
- (void)performSelectorWithBlock:(void (^)())block;
- (void)performSelectorWithBlock:(void (^)())block afterDelay:(NSTimeInterval)delay;

@end

typedef void(^ResponseObjectCompleteBlock)(NSString *responseObject);


@interface Util : NSObject
+ (BOOL)isInternetActived;
+ (void)getDataFromSerVer:(NSString *)url completeBlock:(ResponseObjectCompleteBlock)completeBlock;
+ (void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)mesages;
@end
