//
//  UIView+ExLayout.m
//  Zippie
//
//  Created by Manh Nguyen on 5/13/14.
//  Copyright (c) 2014 Lunex Telecom. All rights reserved.
//

#import "UIView+ExtLayout.h"


@implementation UIView (ExtLayoutFrame)

#pragma mark -
#pragma mark get left,right,top,bottom
- (float)left {
    return self.frame.origin.x;
}

- (float)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (float)top {
    return self.frame.origin.y;
}

- (float)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (float)height {
    return self.frame.size.height;
}

- (float)width {
    return self.frame.size.width;
}

#pragma mark -
#pragma mark set left,right,top,bottom
- (void)setLeft:(float)left {
    self.frame = CGRectMake(left, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setLeft:(float)left top:(float)top {
    self.frame = CGRectMake(left, top, self.frame.size.width, self.frame.size.height);
}

- (void)setLeft:(float)left right:(float)right {
    self.frame = CGRectMake(left, self.frame.origin.y, right-left, self.frame.size.height);
}

- (void)setRight:(float)right {
    self.frame = CGRectMake(right - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setRight:(float)right top:(float)top {
    self.frame = CGRectMake(right - self.frame.size.width, top, self.frame.size.width, self.frame.size.height);
}

- (void)setRight:(float)right bottom:(float)bottom {
    self.frame = CGRectMake(right - self.frame.size.width, bottom - self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

- (void)setTop:(float)top {
    self.frame = CGRectMake(self.frame.origin.x, top, self.frame.size.width, self.frame.size.height);
}

- (void)setBottom:(float)bottom {
    self.frame = CGRectMake(self.frame.origin.x, bottom - self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

- (void)setOrigin:(CGPoint)origin {
    self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
}

#pragma mark -
#pragma mark move left,right,top,bottom
- (void)moveToLeftOfView:(UIView*)vw offset:(float)offset {
    self.center = CGPointMake(vw.frame.origin.x - offset - self.frame.size.width/2, vw.center.y);
}

- (void)moveToRightOfView:(UIView*)vw offset:(float)offset {
    self.center = CGPointMake(vw.frame.origin.x + vw.frame.size.width + offset + self.frame.size.width/2, vw.center.y);
}

- (void)moveToTopOfView:(UIView*)vw offset:(float)offset {
    self.center = CGPointMake(vw.center.x, vw.frame.origin.y - offset - self.frame.size.height/2);
}

- (void)moveToBottomOfView:(UIView*)vw offset:(float)offset {
    self.center = CGPointMake(vw.center.x, vw.frame.origin.y + vw.frame.size.height + offset + self.frame.size.height/2);
}

- (void)moveToHorizontalCenterOfSuperView {
    self.center = CGPointMake(self.superview.frame.size.width/2,self.center.y);
}

#pragma mark -
#pragma mark get rect at left,right,top,bottom
- (CGRect)rectAtLeft:(float)offset width:(float)width {
    return CGRectMake(self.frame.origin.x - offset - width, self.frame.origin.y, width, self.frame.size.height);
}

- (CGRect)rectAtLeft:(float)offset width:(float)width height:(float)height {
    return CGRectMake(self.frame.origin.x - offset - width, self.center.y - height/2, width, height);
}

- (CGRect)rectAtRightOfLeftSide:(float)offsetLeftTopBottom width:(float)width {
    return CGRectMake(self.frame.origin.x + offsetLeftTopBottom, self.frame.origin.y + offsetLeftTopBottom, width, self.frame.size.height - 2 * offsetLeftTopBottom);
}

- (CGRect)rectAtRight:(float)offset width:(float)width {
    return CGRectMake(self.frame.origin.x + self.frame.size.width + offset, self.frame.origin.y, width, self.frame.size.height);
}

- (CGRect)rectAtRight:(float)offset width:(float)width height:(float)height {
    return CGRectMake(self.frame.origin.x + self.frame.size.width + offset, self.center.y - height/2, width, height);
}

- (CGRect)rectAtLeftOfRightSide:(float)offset width:(float)width height:(float)height {
    return CGRectMake(self.frame.origin.x + self.frame.size.width - offset - width, self.center.y - height/2, width, height);
}

- (CGRect)innerRectAtRight:(float)offset width:(float)width {
    return CGRectMake(self.frame.origin.x + self.frame.size.width - offset - width, self.frame.origin.y, width, self.frame.size.height);
}

- (CGRect)innerRectAtRight:(float)offset width:(float)width height:(float)height {
    return CGRectMake(self.frame.origin.x + self.frame.size.width - offset - width, self.center.y - height/2, width, height);
}

- (CGRect)rectAtTop:(float)offset height:(float)height {
    return CGRectMake(self.frame.origin.x, self.frame.origin.y - offset - height, self.frame.size.width, height);
}

- (CGRect)rectAtBottom:(float)offset height:(float)height {
    return CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height + offset, self.frame.size.width, height);
}

- (CGRect)rectAtBottom:(float)offset width:(float)width height:(float)height {
    return CGRectMake(0, self.frame.origin.y + self.frame.size.height + offset, width, height);
}

- (CGRect)rectAtMiddleOffsetLeft:(float)offsetLeft offsetRight:(float)offsetRight offsetTop:(float)offsetTop offsetBottom:(float)offsetBottom {
    return CGRectMake(self.frame.origin.x + offsetLeft, self.frame.origin.y + offsetTop, self.frame.size.width - offsetLeft - offsetRight, self.frame.size.height - offsetTop - offsetBottom);
}

- (CGRect)innerRectOffsetLeft:(float)offsetLeft offsetRight:(float)offsetRight offsetTop:(float)offsetTop offsetBottom:(float)offsetBottom {
    return CGRectMake(offsetLeft, offsetTop, self.frame.size.width - offsetLeft - offsetRight, self.frame.size.height - offsetTop - offsetBottom);
}

- (CGRect)innerRectOffsetLeft:(float)offsetLeft offsetTop:(float)offsetTop offsetBottom:(float)offsetBottom width:(float)width {
    return CGRectMake(offsetLeft, offsetTop, width, self.frame.size.height - offsetTop - offsetBottom);
}

- (CGRect)innerRectOffsetRight:(float)offsetRight offsetTop:(float)offsetTop offsetBottom:(float)offsetBottom width:(float)width {
    return CGRectMake(self.frame.size.width - offsetRight - width, offsetTop, width, self.frame.size.height - offsetTop - offsetBottom);
}

- (CGPoint)bottomRightPoint {
    return CGPointMake([self right],[self bottom]);
}

#pragma mark -
#pragma mark resize
- (void)setWidth:(float)newWidth {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newWidth, self.frame.size.height);
}

- (void)setHeight:(float)newHeight {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newHeight);
}

- (void)setWidth:(float)newWidth height:(float)newHeight {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newWidth, newHeight);
}

- (float)autoWidthAlignAtRight {
    float w = [self sizeThatFits:CGSizeZero].width;
    self.frame = CGRectMake(self.frame.origin.x+self.frame.size.width-w,self.frame.origin.y,w,self.frame.size.height);
    return w;
}

- (void)autoHeight {
    [self setHeight:[self sizeThatFits:CGSizeZero].height];
}

- (BOOL)fitWidth:(float)maxWidth {
    float fitWidth = [self sizeThatFits:CGSizeZero].width;
    if (fitWidth < maxWidth) {
        [self setWidth:fitWidth];
        return YES;
    } else {
        [self setWidth:maxWidth];
        return NO;
    }
}

#pragma mark -
#pragma mark SubViews

- (void)removeAllSubViews {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

#pragma mark - Autolayout

- (void)addConstraintFullLayoutToView:(UIView *)parrentView {
    [self addConstraintFullLayoutToView:parrentView withPadding:0];
}

- (void)addConstraintFullLayoutToView:(UIView *)parrentView withPadding:(CGFloat)padding {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:parrentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:padding]];
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:parrentView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-padding]];
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parrentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:padding]];
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parrentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-padding]];
}

- (void)addConstraintFullLayoutToView:(UIView *)parrentView withXpadding:(CGFloat)Xpadding withYpadding:(CGFloat)Ypadding {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:parrentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:Xpadding]];
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:parrentView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-Xpadding]];
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parrentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:Ypadding]];
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parrentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-Ypadding]];
}

- (void)addConstraintFixHeightToTopView:(UIView *)parrentView widthHeight:(CGFloat)height {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:parrentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0]];
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:parrentView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0]];
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parrentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0]];
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:height]];
}

- (void)addConstraintFixHeightToTopView:(UIView *)parrentView widthHeight:(CGFloat)height andPaddingTop:(CGFloat)paddingTop {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:parrentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0]];
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:parrentView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0]];
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parrentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:paddingTop]];
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:height]];
}

- (void)addConstraintFixHeightToBottomView:(UIView *)parrentView widthHeight:(CGFloat)height {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:parrentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0]];
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:parrentView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0]];
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parrentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0]];
    [parrentView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:height]];
}

@end
