//
//  ShoppingView.h
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/24/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderSectionView.h"
#import "ShoppingDetailView.h"
#import "ShoppingTableViewCell.h"

@interface ShoppingView : BaseView <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ShoppingDetailDelegate>

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
@property (nonatomic, weak) IBOutlet ShoppingDetailView* detailView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* leadingDetailViewContraint;
@property (nonatomic, weak) IBOutlet UIView* overlayView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView* indicatorView;
@property (nonatomic, assign) ShoppingTableViewCell* cellSelected;

@property (nonatomic) BOOL isEditMode;
@property (nonatomic) NSInteger indexSelected;
- (void)setUpView;
- (void)show:(BOOL)show;
- (void)handleEditMySticker;
- (void)showBottomAlertView:(BOOL)show;
@end
