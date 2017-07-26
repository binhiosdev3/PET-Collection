//
//  StickerManager.h
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/25/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StickerPack.h"
#import "Constant.h"

@interface StickerManager : NSObject

@property (nonatomic) int numberOfPackages;
@property (nonatomic, strong) NSMutableArray* arrPackages;

+ (StickerManager *)getInstance;
- (void)addNewPackWithId:(NSString*)packId numOfSticker:(int)numOfSticker isAnimated:(BOOL)isGif;

@end
