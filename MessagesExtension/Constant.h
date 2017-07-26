//
//  Constant.h
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/25/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "UIImage+Ext.h"

#ifndef Constant_h
#define Constant_h

#define userDefaults [NSUserDefaults standardUserDefaults]


#define stickerdf_1 @"1"
#define stickerdf_2 @"2"
#define stickerdf_3 @"3"
#define stickerdf_4 @"4"
#define stickerdf_5 @"5"

#define numOfSticker_1 @"24"
#define numOfSticker_2 @"24"
#define numOfSticker_3 @"24"
#define numOfSticker_4 @"24"
#define numOfSticker_5 @"40"


#define DEFAULT_STICKER_PACKAGE @[stickerdf_1, stickerdf_2, stickerdf_3, stickerdf_4,stickerdf_5]
#define DEFAULT_STICKER_PACKAGE_NumOfSticker @[numOfSticker_1,numOfSticker_2,numOfSticker_3,numOfSticker_4]
#define DEFAULT_NUM_OF_STICKER_PACKAGE @[@(24),@(24),@(24),@(24),@(40)]
#define DEFAULT_IS_GIF_STICKER_PACKAGE @[@(1),@(1),@(1),@(1),@(0)]

#define numberOfPackage_key @"PET_NUM_OFF_PACK"
#define StickerPackageArr_key @"PET_STICKER_PACKAGE_ARR"
#define numOfSticker_key @"PET_numOfSticker_key"
#define packageId_key @"PET_package_id_key"
#define arr_sticker_path_key @"PET_array_sticker_path_key"
#define icon_path_key @"PET_icon_sticker_path_key"
#define is_animated_key @"PET_is_sticker_animated"

#endif /* Constant_h */
