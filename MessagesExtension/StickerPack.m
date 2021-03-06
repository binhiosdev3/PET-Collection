//
//  StickerPack.m
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/25/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "StickerPack.h"
#import "FileManager.h"

@implementation StickerPack

- (instancetype)initWithproductID:(NSString*)productID
                  numberOfStickers:(int)numOfSticker
                        isAnimated:(BOOL)isGif
                            title:(NSString*)title
                            group:(NSString*)group
                            price:(NSString *)price
{
    self = [super init];
    if(self) {
        self.productID = productID;
        self.isAnimated = isGif;
        self.numberOfStickers = numOfSticker;
        self.arrStickerPath = [[NSMutableArray alloc] init];
        NSString* ext = isGif ? @".gif" : @".png";
        self.iconPath = [NSString stringWithFormat:@"%@/icon.png",productID];
        for(int i = 1; i <= numOfSticker; i++) {
            NSString* strStickerPath = [NSString stringWithFormat:@"%@/%@_%d%@",productID,productID,i,ext];
            [self.arrStickerPath addObject:strStickerPath];
        }
        self.title = title;
        self.group = group;
        self.price = price;
    }
    return self;
}

- (NSDictionary*)toDictionary {
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setObject:@(self.numberOfStickers) forKey:numOfSticker_key];
    [dict setObject:self.arrStickerPath forKey:arr_sticker_path_key];
    [dict setObject:self.iconPath forKey:icon_path_key];
    [dict setObject:@(self.isAnimated) forKey:is_animated_key];
    if(_title) {
        [dict setObject:self.title forKey:title_key];
    }
    if(_group) {
        [dict setObject:self.group forKey:group_key];
    }
    [dict setObject:self.productID forKey:productID_key];
    [dict setObject:self.price forKey:price_key];
    return dict;
}

- (instancetype)initWithDictionary:(NSDictionary*)dict {
    self = [super init];
    if(self) {
        self.numberOfStickers = (int)[dict objectForKey:numOfSticker_key];
        self.arrStickerPath = [dict objectForKey:arr_sticker_path_key];
        self.iconPath = [dict objectForKey:icon_path_key];;
        self.isAnimated = [[dict objectForKey:is_animated_key] boolValue];
        self.title = [dict objectForKey:title_key];
        self.group = [dict objectForKey:group_key];
        self.productID = [dict objectForKey:productID_key];
        self.price = [dict objectForKey:price_key];
    }
    return self;
}


@end
