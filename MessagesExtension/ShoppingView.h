//
//  ShoppingView.h
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/24/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailView.h"

@interface ShoppingView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet DetailView* detailView;
@property (nonatomic,strong) NSDictionary *jsonDataArray;
- (void)setUpView;
- (void)show:(BOOL)show;
@end
