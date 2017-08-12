//
//  HeaderSectionView.m
//  PET Sticker Collection
//
//  Created by vietthaibinh on 8/1/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "HeaderSectionView.h"

@implementation HeaderSectionView


- (void)showMySticker:(BOOL)show{
    float alpha1;
    float alpha2;
    [self.btnRestore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    if(show) {
        alpha1 = 1.0;
        alpha2 = 0;
        [self.btnMySticker setTitle:@"Done" forState:UIControlStateNormal];
        [_leadingLbMyStickerBtnMySticker setPriority:UILayoutPriorityDefaultLow];
        [_leadingLbMyStickerToSupperView setPriority:UILayoutPriorityDefaultHigh];
        [self.btnRestore setTitle:@"Delete" forState:UIControlStateNormal];
        [self.btnRestore setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        self.btnRestore.enabled = NO;
    }
    else {
        alpha1 = 0.0;
        alpha2 = 1.0;
        [self.btnMySticker setTitle:@"My Sticker" forState:UIControlStateNormal];
        [_leadingLbMyStickerBtnMySticker setPriority:UILayoutPriorityDefaultHigh];
        [_leadingLbMyStickerToSupperView setPriority:UILayoutPriorityDefaultLow];
        [self.btnRestore setTitle:@"Restore" forState:UIControlStateNormal];
        [self.btnRestore setTitleColor:self.btnMySticker.currentTitleColor forState:UIControlStateNormal];
        self.btnRestore.enabled = YES;
    }
    BlockWeakSelf weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.lbMySticker.alpha = alpha1;
        weakSelf.tfSearch.alpha = alpha2;
        weakSelf.imgLine1.alpha = alpha2;
        weakSelf.imgLine2.alpha = alpha2;
        weakSelf.segmentView.alpha = alpha2;
        [weakSelf updateConstraintsIfNeeded];
        [weakSelf layoutIfNeeded];
    }];
}

- (void)showfullTextFieldSearch:(BOOL)show {
    if(show) {
        [_traillingFullTfSearch setPriority:900];
    }
    else {
         [_traillingFullTfSearch setPriority:250];
    }
    BlockWeakSelf weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        [weakSelf updateConstraintsIfNeeded];
        [weakSelf layoutIfNeeded];
    }];
}


@end
