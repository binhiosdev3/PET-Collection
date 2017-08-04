//
//  HeaderSectionView.m
//  PET Sticker Collection
//
//  Created by vietthaibinh on 8/1/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "HeaderSectionView.h"

@implementation HeaderSectionView

- (void)checkExpireDate {
    /*
    if([[userDefaults objectForKey:IS_PURCHASE_KEY] intValue] == 1) {
        _heigtForExpireDatalb.constant = 15.f;
    }
    else {
        _heigtForExpireDatalb.constant = 0.f;
    }*/
}

- (void)showMySticker:(BOOL)show{
    float alpha1;
    float alpha2;
    if(show) {
        alpha1 = 1.0;
        alpha2 = 0;
        [self.btnMySticker setTitle:@"Done" forState:UIControlStateNormal];
        [_leadingLbMyStickerToTraillingTF setPriority:UILayoutPriorityDefaultLow];
        [_leadingLbMyStickerToLeadingTF setPriority:UILayoutPriorityDefaultHigh];
    }
    else {
        alpha1 = 0.0;
        alpha2 = 1.0;
        [self.btnMySticker setTitle:@"My Sticker" forState:UIControlStateNormal];
        [_leadingLbMyStickerToTraillingTF setPriority:UILayoutPriorityDefaultHigh];
        [_leadingLbMyStickerToLeadingTF setPriority:UILayoutPriorityDefaultLow];
    }
    BlockWeakSelf weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.lbMySticker.alpha = alpha1;
        weakSelf.tfSearch.alpha = alpha2;
        [weakSelf updateConstraintsIfNeeded];
        [weakSelf layoutIfNeeded];
    }];
}

@end
