//
//  HeaderSectionView.h
//  PET Sticker Collection
//
//  Created by vietthaibinh on 8/1/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderSectionView : BaseView
@property (nonatomic,weak) IBOutlet UITextField* tfSearch;
@property (nonatomic,weak) IBOutlet UIButton* btnMySticker;
@property (nonatomic,weak) IBOutlet UILabel* lbMySticker;
@property (nonatomic,weak) IBOutlet UILabel* lbExpireDate;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint* leadingLbMyStickerToTraillingTF;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint* heigtForExpireDatalb;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint* leadingLbMyStickerToLeadingTF;
- (void)showMySticker:(BOOL)show;
- (void)checkExpireDate;
@end
