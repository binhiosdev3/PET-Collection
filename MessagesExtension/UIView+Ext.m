//
//  UIView+Ext.m
//  Zippie
//
//  Created by Hung Tran on 1/30/15.
//  Copyright (c) 2015 Lunex. All rights reserved.
//

#import "UIView+Ext.h"

@implementation UIView  (Ext)

+ (id)createViewWithNib {
    return [self viewWithOwner:nil];
}

+ (instancetype)viewWithOwner:(id)owner{
    NSString *key = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:key bundle:nil];
    return [nib instantiateWithOwner:owner options:nil].lastObject;
}

- (void)addRoundedCorners:(UIRectCorner)corners radius:(float)radius {
    CALayer *tMaskLayer = [self maskForRoundedCorners:corners withRadii:CGSizeMake(radius, radius)];
    self.layer.mask = tMaskLayer;
}

- (CALayer*)maskForRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    
    UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:
                                 maskLayer.bounds byRoundingCorners:corners cornerRadii:radii];
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    maskLayer.backgroundColor = [UIColor clearColor].CGColor;
    maskLayer.path = roundedPath.CGPath;
    
    return maskLayer;
}

- (UIImage *)captureImage{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)screenshot{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        NSInvocation* invoc = [NSInvocation invocationWithMethodSignature:
                               [self methodSignatureForSelector:
                                @selector(drawViewHierarchyInRect:afterScreenUpdates:)]];
        invoc.target = self;
        invoc.selector = @selector(drawViewHierarchyInRect:afterScreenUpdates:);
        CGRect arg2 = self.bounds;
        BOOL arg3 = YES;
        [invoc setArgument:&arg2 atIndex:2];
        [invoc setArgument:&arg3 atIndex:3];
        [invoc invoke];
    }
    else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)highlightedView {
    self.alpha = 0.7;
}

- (void)unHighlightedView {
    if (self.alpha != 1) {
        BlockWeakSelf wSelf = self;
        [UIView animateWithDuration:0.25 animations:^{
            wSelf.alpha = 1.0;
        }];
    }
}

@end

@implementation UIView (Shake)

- (void)shakeTime:(NSInteger)time interval:(double)interval length:(CGFloat)length {
    [self shakeTime:time interval:interval length:length completion:nil];
}

- (void)shakeTime:(NSInteger)time interval:(double)interval length:(CGFloat)length completion:(void (^)())completion {
    [self shakeIndex:0 total:time interval:interval length:length completion:completion];
}

- (void)shakeIndex:(NSInteger)index total:(NSInteger)total interval:(double)interval length:(CGFloat)length completion:(void (^)())completion {
    if (index < total) {
        double duration = interval;
        if (index == 0 || index == total - 1) {
            duration = duration / 2;
        }
        [UIView animateWithDuration:duration animations:^{
            if (index == total - 1) {
                self.transform = CGAffineTransformIdentity;
            }
            else {
                if (index % 2 == 0) {
                    self.transform = CGAffineTransformMakeTranslation(-length, 0);
                }
                else {
                    self.transform = CGAffineTransformMakeTranslation(length, 0);
                }
            }
        }completion:^(BOOL finished) {
            [self shakeIndex:index + 1 total:total interval:interval length:length completion:completion];
        }];
    }
    else {
        if (completion) {
            completion();
        }
    }
}

@end
