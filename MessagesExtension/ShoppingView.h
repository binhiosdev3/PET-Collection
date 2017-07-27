//
//  ShoppingView.h
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/24/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailView.h"
#import "FLAnimatedImageView+WebCache.h"

@interface ShoppingView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet DetailView* detailView;
@property (nonatomic, weak) IBOutlet FLAnimatedImageView* headerImg;
@property (nonatomic, weak) IBOutlet UIView* viewButton;
@property (nonatomic, weak) IBOutlet UIButton* btnRestore;
@property (nonatomic, weak) IBOutlet UIButton* btnPurchase;
@property (nonatomic,strong) NSDictionary *jsonDataArray;
@property (nonatomic,strong) NSMutableArray *arrItemShow;
- (void)setUpView;
- (void)show:(BOOL)show;
@end
