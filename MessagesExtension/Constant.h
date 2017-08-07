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

#define APP_STORE 0

#define PASS_FIRST_LOAD_KEY @"First_load_key"
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define IS_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)

#define userDefaults [NSUserDefaults standardUserDefaults]

#define BlockWeakObject(o) __typeof__(o) __weak
#define BlockWeakSelf BlockWeakObject(self)

#define JSON_DATA_ARR @"JSON_DATA_ARR_KEY"

#define KEYSERECT @"fb375a41a19f456f969d82a4028158a5"
#define CONFIG_URL  @"https://gist.githubusercontent.com/binhiosdev3/cef1f8e8c5ae986a74a5ee96af0911b7/raw/"
#define JSON_URL_KEY @"JSON_URL_KEY"
#define IS_PRODUCTION  @"IS_PRODUCTION"
#define IS_PURCHASE_KEY @"Willattempttorecover_key"

#define NUM_DEFAULT_PACK_DEMO 1
#define NUM_DEFAULT_PACK_PRO 5
#define NUM_STICKER_FREE_GIF 6
#define NUM_STICKER_FREE_NOT_GIF 8

#define stickerdf_1 @"Sticker1"
#define stickerdf_2 @"Sticker2"
#define stickerdf_3 @"Sticker3"
#define stickerdf_4 @"Sticker4"
#define stickerdf_5 @"Sticker5"

#define numOfSticker_1 @"24"
#define numOfSticker_2 @"24"
#define numOfSticker_3 @"40"
#define numOfSticker_4 @"24"
#define numOfSticker_5 @"40"

#define productId_1 @"Sticker1"
#define productId_2 @"Sticker2"
#define productId_3 @"Sticker3"
#define productId_4 @"Sticker4"
#define productId_5 @"Sticker5"

#define nameOfSticker_1 @"Cool Meow Animated"
#define nameOfSticker_2 @"Mimi Summer Animated"
#define nameOfSticker_3 @"Cool Rabbit Emotion"
#define nameOfSticker_4 @"Panda Emoji Animated"
#define nameOfSticker_5 @"Puffy Bear and Rabbit"

#define DEFAULT_STICKER_PACKAGE_PRODUCTID @[productId_1,productId_2,productId_3,productId_4,productId_5]
#define DEFAULT_STICKER_PACKAGE @[stickerdf_1, stickerdf_2, stickerdf_3,stickerdf_4,stickerdf_5]
#define DEFAULT_STICKER_PACKAGE_NAME @[nameOfSticker_1,nameOfSticker_2,nameOfSticker_3,nameOfSticker_4,nameOfSticker_5]
#define DEFAULT_STICKER_PACKAGE_NumOfSticker @[numOfSticker_1,numOfSticker_2,numOfSticker_3,numOfSticker_4,numOfSticker_5]
#define DEFAULT_NUM_OF_STICKER_PACKAGE @[@(24),@(24),@(40),@(24),@(40)]
#define DEFAULT_IS_GIF_STICKER_PACKAGE @[@(1),@(1),@(0),@(1),@(0)]

#define numberOfPackage_key @"PET_NUM_OFF_PACK"
#define StickerPackageArr_key @"PET_STICKER_PACKAGE_ARR"
#define numOfSticker_key @"PET_numOfSticker_key"
#define packageId_key @"PET_package_id_key"
#define arr_sticker_path_key @"PET_array_sticker_path_key"
#define icon_path_key @"PET_icon_sticker_path_key"
#define is_animated_key @"PET_is_sticker_animated"
#define title_key @"title_sticker"
#define group_key @"group_sticker"
#define productID_key @"productID_sticker"

#define notification_add_package_download_complete @"completed_add_package_download"
#define notification_click_purchase @"notification_click_purchase"
#define notification_click_restore @"notification_click_restore"
#define notification_mysticker_did_endEditin @"notification_mysticker_did_endEditin"
#define notification_show_alert @"notification_show_alert"
#endif /* Constant_h */
