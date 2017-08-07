//
//  OverlayView.h
//  PET Sticker Collection
//
//  Created by vietthaibinh on 8/7/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "BaseView.h"

@interface OverlayView : BaseView

@property (nonatomic,weak) IBOutlet UIImageView* imgBgView;
@property (nonatomic,weak) IBOutlet FLAnimatedImageView* imgView;
@property (nonatomic,weak) IBOutlet UIView* loadingView;
@property (nonatomic,weak) IBOutlet UIView* alertView;
@property (nonatomic,weak) IBOutlet UILabel* lbLoadingText;
@property (nonatomic,weak) IBOutlet UILabel* lbAlertMessage;
@property (nonatomic,weak) IBOutlet UILabel* lbAlertTitle;
@property (nonatomic,strong) UITapGestureRecognizer* tapGesture;
@property (nonatomic) BOOL isThankYou;
- (void)showLoadingViewWithText:(NSString*)text;
- (void)hideLoadingView;
- (void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message;
- (void)showThankView;
@end
