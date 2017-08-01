//
//  StickerBrowserViewController.h
//  PET Sticker Collection
//
//  Created by vietthaibinh on 8/1/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import <Messages/Messages.h>

@interface StickerBrowserViewController : MSStickerBrowserViewController

- (instancetype)initWithStickerSize:(MSStickerSize)stickerSize withPackInfo:(NSDictionary *)packInfo;

- (void)loadStickerPackAtIndex:(NSInteger)index;


@end
