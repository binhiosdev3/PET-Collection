//
//  ShoppingView.h
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/24/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderSectionView.h"
#import "ShoppingDetailView.h"
#import "ShoppingTableViewCell.h"

@interface ShoppingView : BaseView
@property (nonatomic, weak) IBOutlet UIView* bottomPurchaseView;
@property (nonatomic, weak) IBOutlet UIView* viewButton;

- (void)setUpView;
- (void)show:(BOOL)show;
- (void)handleEditMySticker;
- (void)showBottomAlertView:(BOOL)show;
@end
