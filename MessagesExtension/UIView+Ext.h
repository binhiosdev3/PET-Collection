//
//  UIView+Ext.h
//  Zippie
//
//  Created by Hung Tran on 1/30/15.
//  Copyright (c) 2015 Lunex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Ext)

+ (id)createViewWithNib;
+ (instancetype)viewWithOwner:(id)owner;

- (UIImage *)captureImage;
- (void)addRoundedCorners:(UIRectCorner)corners radius:(float)radius;
- (CALayer*)maskForRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii;

- (UIImage *)screenshot;
- (void)highlightedView;
- (void)unHighlightedView;

@end

@interface UIView (Shake)

- (void)shakeTime:(NSInteger)time interval:(double)interval length:(CGFloat)length;
- (void)shakeTime:(NSInteger)time interval:(double)interval length:(CGFloat)length completion:(void (^)())completion;

@end
