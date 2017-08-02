//
//  ShoppingTableViewCell.h
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/27/17.
//  Copyright © 2017 Pham. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "KBRoundedButton.h"

@interface ShoppingTableViewCell : UITableViewCell

- (void)loadCellWithDict:(NSDictionary*)dict;
- (void)loadCellWithPackage:(StickerPack*)pack;
- (IBAction)handleDownload:(id)sender;
@end
