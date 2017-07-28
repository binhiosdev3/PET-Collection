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

- (void)loadCell:(NSDictionary*)dict;
- (CGFloat)heightWhenExpand;
- (void)expand:(BOOL)expand;
@end
