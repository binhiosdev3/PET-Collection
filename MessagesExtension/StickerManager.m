//
//  StickerManager.m
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/25/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "StickerManager.h"
#import "StickerPack.h"


@implementation StickerManager

+ (StickerManager *)getInstance {
    static StickerManager *instance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[StickerManager alloc] init];
    });
    
    return instance;
}


- (instancetype)init {
    self = [super init];
    if(self) {
        self.arrDownloadingPack = [NSMutableArray new];
        NSArray* arr = [userDefaults objectForKey:StickerPackageArr_key];
        if(arr.count) {
            self.numberOfPackages = (int)arr.count;
            self.arrPackages = [NSMutableArray new];
            for(NSDictionary* dict in arr) {
                StickerPack* stickerPack = [[StickerPack alloc] initWithDictionary:dict];
                [self.arrPackages addObject:stickerPack];
            }
        }
        else {
            self.numberOfPackages = 0;
            self.arrPackages = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)addNewProductID:(NSString*)productID
            numOfSticker:(int)numOfSticker
              isAnimated:(BOOL)isGif
                   title:(NSString*)title
                   group:(NSString*)group
{
    self.numberOfPackages += 1;
    StickerPack* stickerPackage = [[StickerPack alloc] initWithproductID:productID
                                                        numberOfStickers:numOfSticker
                                                              isAnimated:isGif
                                                                   title:title
                                                                   group:group];
    [self.arrPackages insertObject:stickerPackage atIndex:0];
    NSMutableArray* arr = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:StickerPackageArr_key]];
    NSDictionary* dict = [stickerPackage toDictionary];
    [arr insertObject:dict atIndex:0];
    [userDefaults setObject:@(self.numberOfPackages) forKey:numberOfPackage_key];
    [userDefaults setObject:arr forKey:StickerPackageArr_key];
    [userDefaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_add_package_download_complete object:nil userInfo:dict];
}

- (void)saveArrPackage {
    NSMutableArray* arr = [[NSMutableArray alloc] initWithCapacity:self.arrPackages.count];
    for(int i= 0; i < self.arrPackages.count; i++) {
        @autoreleasepool {
            StickerPack* stickerPackage = self.arrPackages[i];
            [arr addObject:[stickerPackage toDictionary]];
        }
    }
    [userDefaults setObject:arr forKey:StickerPackageArr_key];
    [userDefaults synchronize];
}

- (BOOL)isDownloadedPack:(NSDictionary*)dict {
    for(StickerPack* pack in self.arrPackages) {
        if([pack.productID isEqualToString:[dict objectForKey:@"product_id"]]) {
            return YES;
        }
    }
    return NO;
}
@end
