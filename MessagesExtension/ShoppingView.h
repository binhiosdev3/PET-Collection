//
//  ShoppingView.h
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/24/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImageView+WebCache.h"
#import "KBRoundedButton.h"
#import "HeaderSectionView.h"

@interface ShoppingView : BaseView <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UIView* bottomPurchaseView;
@property (nonatomic, weak) IBOutlet UIView* viewButton;
@property (nonatomic, weak) IBOutlet UIView* bottomAlertView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* topBottomAlertView;
@property (nonatomic, weak) IBOutlet UIButton* btnRestore;
@property (nonatomic, weak) IBOutlet KBRoundedButton* btnPurchase;
@property (nonatomic,strong) NSDictionary *jsonDataArray;
@property (nonatomic,strong) NSMutableArray *arrItemShow;
@property (nonatomic,strong) NSMutableArray *arrFilterMySticker;
@property (nonatomic,strong) NSMutableArray *arrMySticker;
@property (nonatomic, strong) HeaderSectionView* headerView;
@property (nonatomic) BOOL isEditMode;
@property (nonatomic) NSInteger indexSelected;
- (void)setUpView;
- (void)show:(BOOL)show;
- (void)handleEditMySticker;
- (void)showBottomAlertView:(BOOL)show;
@end
