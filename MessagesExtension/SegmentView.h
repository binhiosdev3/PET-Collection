//
//  SegmentView.h
//  PET Sticker Collection
//
//  Created by vietthaibinh on 8/8/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "BaseView.h"
#import "HMSegmentedControl.h"

@interface SegmentView : BaseView
@property (nonatomic,strong) UIFont *font;
@property (nonatomic,strong) HMSegmentedControl *segmentedControl;

- (void)addSegment ;
@end
