//
//  UIColor+Ext.h
//  Zippie
//
//  Created by Hung Tran on 1/18/15.
//  Copyright (c) 2015 Lunex. All rights reserved.
//

@interface UIColor(Ext)

+ (UIColor *)colorWith256Red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+ (UIColor *)colorFromString:(NSString *)string;
+ (UIColor *)colorWithRedInt:(int)red greenInt:(int)green blueInt:(int)blue;
+ (UIColor *)colorFromHexString:(NSString *)hexString;

+ (UIColor *)getContrastBlackWhiteWithColor:(UIColor *)color;

@end


@interface NSString(UIColorARIS)

+ (NSString *)stringFromColor:(UIColor *)color;

@end