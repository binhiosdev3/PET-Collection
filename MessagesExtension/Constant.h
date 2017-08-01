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

#define APP_STORE 1

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define IS_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)

#define userDefaults [NSUserDefaults standardUserDefaults]

#define BlockWeakObject(o) __typeof__(o) __weak
#define BlockWeakSelf BlockWeakObject(self)

#define JSON_URL @"https://gist.githubusercontent.com/binhiosdev3/2443f758e248b1697bc3289feb97f927/raw/"

#define IS_PURCHASE_KEY @"Willattempttorecover_key"

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


#define DEFAULT_STICKER_PACKAGE @[stickerdf_1, stickerdf_2, stickerdf_3]
#define DEFAULT_STICKER_PACKAGE_NumOfSticker @[numOfSticker_1,numOfSticker_2,numOfSticker_3]
#define DEFAULT_NUM_OF_STICKER_PACKAGE @[@(24),@(24),@(24)]
#define DEFAULT_IS_GIF_STICKER_PACKAGE @[@(1),@(1),@(1)]

#define numberOfPackage_key @"PET_NUM_OFF_PACK"
#define StickerPackageArr_key @"PET_STICKER_PACKAGE_ARR"
#define numOfSticker_key @"PET_numOfSticker_key"
#define packageId_key @"PET_package_id_key"
#define arr_sticker_path_key @"PET_array_sticker_path_key"
#define icon_path_key @"PET_icon_sticker_path_key"
#define is_animated_key @"PET_is_sticker_animated"

#define notification_add_package_download_complete @"completed_add_package_download"
#endif /* Constant_h */
