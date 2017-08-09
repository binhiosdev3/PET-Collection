//
//  OverlayView.m
//  PET Sticker Collection
//
//  Created by vietthaibinh on 8/7/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "OverlayView.h"

@implementation OverlayView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.alertView.layer setMasksToBounds:YES];
    [self.alertView.layer setCornerRadius:5.f];
    self.alertView.alpha = 0;
    self.loadingView.alpha = 0;
    _imgView.alpha = 0.0;
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOK:)];
    [self addGestureRecognizer:_tapGesture];
    _tapGesture.enabled = NO;
}

- (void)showLoadingViewWithText:(NSString*)text {
    self.lbLoadingText.text = text;
    [self showLoadingView:YES];
}

- (void)showLoadingView:(BOOL)show {
    self.imgBgView.backgroundColor = [UIColor blackColor];
    float alpha = show ? 1.0 : 0.f;
    self.alertView.alpha = 0.f;
    _imgView.alpha = 0.0;
    BlockWeakSelf weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.loadingView.alpha = alpha;
        weakSelf.alpha = alpha;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideLoadingView {
   [self showLoadingView:NO];
}

- (void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message {
    self.imgBgView.backgroundColor = [UIColor blackColor];
    self.loadingView.alpha = 0;
    self.lbAlertMessage.text = message;
    self.lbAlertTitle.text = title;
    BlockWeakSelf weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.alertView.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (IBAction)handleOK:(id)sender {
    BlockWeakSelf weakSelf = self;
    if(!_isThankYou) {
        self.alertView.alpha = 0.0;
        _tapGesture.enabled = NO;
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.alpha = 0.0;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        _isThankYou = NO;
        _tapGesture.enabled = YES;
        self.imgBgView.backgroundColor = [UIColor whiteColor];
        self.loadingView.alpha = 0;
        self.alertView.alpha = 0;
        NSString *filePath = [[NSBundle mainBundle].resourcePath stringByAppendingFormat:@"/Stickers/Gif/thank.gif"];
        NSURL *imageURL = [NSURL fileURLWithPath:filePath];
        [_imgView sd_setImageWithURL:imageURL];
        BlockWeakSelf weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.alpha = 1.0;
            weakSelf.imgView.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)showThankView {
    self.isThankYou = YES;
    [self showAlertWithTitle:@"" andMessage:@"Purchase Completed!"];
}

@end
