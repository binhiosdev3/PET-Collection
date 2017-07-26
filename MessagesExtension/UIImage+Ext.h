//
//  UIImage+Taglist.h
//  Zippie
//
//  Created by Manh Nguyen on 10/14/14.
//  Copyright (c) 2012 Lunex Telecom. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JpegType @"jpeg"
#define GifType @"Gif"
#define PngType @"png"
#define BmpType @"Bmp"
#define TiffType @"Tiff"

@interface UIImage (Ext)

- (UIImage *)imageMaskedWithColor:(UIColor *)maskColor;

@end
