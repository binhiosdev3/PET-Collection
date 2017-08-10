//
//  ShoppingDetailView.h
//  PET Sticker Collection
//
//  Created by vietthaibinh on 8/2/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "BaseView.h"

@protocol ShoppingDetailDelegate <NSObject>

@optional
- (void)didClose;
- (void)didTouchDownload;
- (void)didChangeX:(CGFloat)x;
@end

@interface ShoppingDetailView : BaseView

@property (nonatomic, weak) id<ShoppingDetailDelegate> delegate;
@property (nonatomic,assign) NSDictionary* dictSticker;
@property (nonatomic,assign) NSLayoutConstraint* leadingShopingViewContraint;
@property (nonatomic,weak) IBOutlet UIImageView* imgPlay;
- (void)loadDetail;
@end
