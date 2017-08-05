//
//  FooterCollectionReusableView.m
//  PET Sticker Collection
//
//  Created by Vietthaibinh on 8/5/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "FooterCollectionReusableView.h"

@implementation FooterCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)handlePurchase:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_click_purchase object:nil];
}
@end
