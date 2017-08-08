//
//  UIColor+Ext.m
//  Zippie
//
//  Created by Hung Tran on 1/18/15.
//  Copyright (c) 2015 Lunex. All rights reserved.
//

#import "UIColor+Ext.h"

@implementation UIColor(Ext)

+ (UIColor *)colorWith256Red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red / 255.0f
                           green:green / 255.0f
                            blue:blue / 255.0f
                           alpha:alpha];
}

+ (UIColor *)colorFromString:(NSString *)string {
    
    NSArray *parts = [string componentsSeparatedByString:@" "];
    
    if (parts.count > 1) {
        NSString *colorSpaceName = parts[0];
        NSArray *components = [parts[1] componentsSeparatedByString:@";"];
        
        if ([colorSpaceName isEqualToString:@"Monochrome"]) {
            
            CGFloat white   = [components[0] floatValue];
            CGFloat alpha   = [components[1] floatValue];
            return [UIColor colorWithWhite:white alpha:alpha];
            
        } else if ([colorSpaceName isEqualToString:@"RGB"]) {
            
            CGFloat red     = [components[0] floatValue];
            CGFloat green   = [components[1] floatValue];
            CGFloat blue    = [components[2] floatValue];
            CGFloat alpha   = [components[3] floatValue];
            return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
            
        }
    }
    
    return [UIColor greenColor];
}

+ (UIColor *)colorWithRedInt:(int)red greenInt:(int)green blueInt:(int)blue {
    return [UIColor colorWithRed:(float)red/255.0 green:(float)green/255.0 blue:(float)blue/255.0 alpha:1.0];
}

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    scanner.scanLocation = 1; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (UIColor *)getContrastBlackWhiteWithColor:(UIColor *)color {
    CGFloat r=0,g=0,b=0,a=0;
    
    if ([color respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [color getRed:&r green:&g blue:&b alpha:&a];
    }
    else {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }

    NSArray *rgbaArray =  @[@(r),@(g),@(b),@(a)];

    double colorValue = 1 - ((0.299 * [rgbaArray[0] doubleValue]) + (0.587 * [rgbaArray[1] doubleValue]) + (0.114 * [rgbaArray[2] doubleValue]));
    return colorValue < 0.5 ? [[self class] blackColor] : [[self class] whiteColor];
}

@end


@implementation NSString(UIColorARIS)

+ (NSString *)stringFromColor:(UIColor *)color {
    
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));
    
    switch (colorSpaceModel) {
        case kCGColorSpaceModelMonochrome: {
            const CGFloat * components = CGColorGetComponents(color.CGColor);
            CGFloat white   = components[0];
            CGFloat alpha   = components[1];
            return [NSString stringWithFormat:@"Monochrome %f;%f", white, alpha];
        }
        case kCGColorSpaceModelRGB: {
            const CGFloat* components = CGColorGetComponents(color.CGColor);
            CGFloat red     = components[0];
            CGFloat green   = components[1];
            CGFloat blue    = components[2];
            CGFloat alpha   = components[3];
            return [NSString stringWithFormat:@"RGB %f;%f;%f;%f", red, green, blue, alpha];
        }
        case kCGColorSpaceModelCMYK: {
            const CGFloat* components = CGColorGetComponents(color.CGColor);
            CGFloat C       = components[0];
            CGFloat M       = components[1];
            CGFloat Y       = components[2];
            CGFloat K       = components[3];
            CGFloat alpha   = components[4];
            return [NSString stringWithFormat:@"CMYK %f;%f;%f;%f;%f", C, M, Y, K, alpha];
        }
        case kCGColorSpaceModelLab: {
            const CGFloat* components = CGColorGetComponents(color.CGColor);
            CGFloat L       = components[0];
            CGFloat a       = components[1];
            CGFloat b       = components[2];
            CGFloat alpha   = components[3];
            return [NSString stringWithFormat:@"Lab %f;%f;%f;%f", L, a, b, alpha];
        }
        case kCGColorSpaceModelDeviceN:
            return @"DeviceN";
        case kCGColorSpaceModelIndexed:
            return @"Indexed";
        case kCGColorSpaceModelPattern:
            return @"Pattern";
        case kCGColorSpaceModelUnknown:
            return @"Unknown";
        default:
            return @"Others";
    }
    
}

@end