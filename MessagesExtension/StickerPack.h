//
//  StickerPack.h
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/25/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StickerPack : NSObject

@property (nonatomic,strong) NSString* packageID;
@property (nonatomic)        int numberOfStickers;
@property (nonatomic,strong) NSMutableArray* arrStickerPath;
@property (nonatomic,strong) NSString* iconPath;
@property (nonatomic) BOOL isAnimated;

- (instancetype)initWithPackageId:(NSString*)packageId
                 numberOfStickers:(int)numOfSticker
                       isAnimated:(BOOL)isGif;
- (instancetype)initWithDictionary:(NSDictionary*)dict;
- (NSDictionary*)toDictionary;
@end
