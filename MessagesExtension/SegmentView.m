//
//  SegmentView.m
//  PET Sticker Collection
//
//  Created by vietthaibinh on 8/8/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "SegmentView.h"


@implementation SegmentView

-(void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)addSegment {
    // Segmented control with scrolling
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"All", @"Tag"]];
    _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    _segmentedControl.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.verticalDividerEnabled = YES;
    _segmentedControl.verticalDividerColor = [UIColor lightGrayColor];
    _segmentedControl.verticalDividerWidth = 1.0f;
    _segmentedControl.selectionIndicatorColor = self.backgroundColor;
    BlockWeakSelf weakSelf = self;
    [_segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName : weakSelf.font,NSForegroundColorAttributeName :[UIColor lightGrayColor]}];
        return attString;
    }];
    _segmentedControl.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:_segmentedControl];
}

@end
