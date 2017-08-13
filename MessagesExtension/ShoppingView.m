//
//  ShoppingView.m
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/24/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "ShoppingView.h"
#import "UIColor+Ext.h"

#define HeightRow 75.f
#define HeightHeader 68.f
#define HeightHeaderTitle 40.f
#define indexSegmentAll 0
#define indexSegmentTag 1
@interface ShoppingView()

<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ShoppingDetailDelegate>

@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic,strong) NSDictionary *jsonDataArray;
@property (nonatomic, weak) IBOutlet OverlayView* overlayView;
@property (nonatomic,strong) NSMutableArray *arrFilterMySticker;
@property (nonatomic,strong) NSMutableArray *arrMySticker;
@property (nonatomic, strong) HeaderSectionView* headerView;
@property (nonatomic, strong) HeaderSectionViewTop* headerViewTop;
@property (nonatomic, weak) IBOutlet ShoppingDetailView* detailView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* leadingDetailViewContraint;
@property (nonatomic, weak) IBOutlet UILabel* lbNoInternet;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView* indicatorView;
@property (nonatomic, assign) ShoppingTableViewCell* cellSelected;
@property (nonatomic, strong) NSMutableArray* arrDeletePack;
@property (nonatomic, strong) NSMutableArray* arrTags;
@property (nonatomic, strong) NSMutableArray* arrItemsSelectedTag;
@property (nonatomic) BOOL isEditMode;
@property (nonatomic) BOOL isGetingJson;
@property (nonatomic) NSInteger segmentSelected;
@property (nonatomic) NSInteger tagSectionSelected;
@property (nonatomic) BOOL isShowMore;
@end

@implementation ShoppingView

- (void)setUpView {
    _arrTags = [NSMutableArray new];
    _arrItemsSelectedTag = [NSMutableArray new];
    _isEditMode = NO;
    _isGetingJson = NO;
    _arrMySticker = [NSMutableArray new];
    _arrDeletePack = [NSMutableArray new];
    _headerViewTop = [[HeaderSectionViewTop alloc] init];
    _headerView = [[HeaderSectionView alloc] init];
    [_headerView.btnMySticker addTarget:self action:@selector(handleEditMySticker) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.btnRestore addTarget:self action:@selector(handleRestoreClick) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.btnMore addTarget:self action:@selector(handleMoreButton) forControlEvents:UIControlEventTouchUpInside];
    _headerView.tfSearch.delegate = self;
    [_headerView.tfSearch addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _headerView.tfSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_headerView showMySticker:NO];
    _headerView.segmentView.font = _headerView.btnRestore.titleLabel.font;
    [_headerView.segmentView addSegment];
    [_headerView.segmentView.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
   
    [self.tableView registerNib:[UINib nibWithNibName:@"ShoppingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ShoppingTableViewCell"];
    _tagSectionSelected = -1;
    self.alpha = 0.0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_add_package_download_complete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completedAddPackage:)name:notification_add_package_download_complete object:nil];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.detailView.delegate = self;
    self.overlayView.alpha = 0.0;
    self.leadingDetailViewContraint.constant = self.frame.size.width;
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    _lbNoInternet.hidden = YES;
    [_headerView.btnMore setImage:[[UIImage imageNamed:@"more"] imageMaskedWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    _segmentSelected = segmentedControl.selectedSegmentIndex;
    _headerView.tfSearch.text = @"";
    [_headerView.tfSearch resignFirstResponder];
    [self showMore:NO];
    _tagSectionSelected = -1;
    [_tableView setContentOffset:CGPointZero animated:NO];
    [_tableView reloadData];
    
}

- (void)completedAddPackage:(NSNotification*)notification {
    if(!notification.userInfo) {
        [self reloadData];
        return;
    }
    NSDictionary* dict = notification.userInfo;
    NSString* strID =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"productID_sticker"]];
    BlockWeakSelf weakSelf = self;
    [_arrItemShow enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            NSDictionary*dict = obj;
            if([strID isEqualToString:[dict objectForKey:@"product_id"]]) {
                [weakSelf.arrItemShow removeObject:dict];
                [weakSelf.arrFilterMySticker removeAllObjects];
                weakSelf.arrFilterMySticker = [[NSMutableArray alloc] initWithArray:self.arrItemShow];
                [weakSelf.arrTags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary* dictTag = obj;
                    NSString* tag = [dictTag objectForKey:@"tag"];
                    NSArray* arrTag = [((NSString*)[dict objectForKey:@"tag"]) componentsSeparatedByString:@","];
                    for(NSString* str in arrTag) {
                        if([tag isEqualToString:str]) {
                            NSNumber* num = [dictTag objectForKey:@"num"];
                            num = [NSNumber numberWithInteger:num.integerValue-1];
                            if(num.integerValue == 0) {
                                [weakSelf.arrTags removeObject:obj];
                                break;
                            }
                            else {
                                NSMutableDictionary* dictNew = [[NSMutableDictionary alloc] initWithDictionary:dictTag];
                                [dictNew setObject:num forKey:@"num"];
                                [weakSelf.arrTags removeObjectAtIndex:idx];
                                [weakSelf.arrTags insertObject:dictNew atIndex:idx];
                                if(weakSelf.tagSectionSelected == idx+1) {
                                    [weakSelf.arrItemsSelectedTag removeAllObjects];
                                    [weakSelf.arrFilterMySticker enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                        @autoreleasepool {
                                            NSDictionary*dict = obj;
                                            NSString*  str = [dict objectForKey:@"tag"];
                                            NSArray* arrTag = [str componentsSeparatedByString:@","];
                                            for(str in arrTag) {
                                                if( [str caseInsensitiveCompare:tag] == NSOrderedSame ) {
                                                    [weakSelf.arrItemsSelectedTag addObject:dict];
                                                    break;
                                                }
                                            }
                                        }
                                    }];
                                }
                            }
                        }
                    }
                }];
                *stop = YES;
            }
        }
    }];
    [self reloadData];
}

- (void)show:(BOOL)show {
    if(show) {
        self.alpha = 1.0;
        [self getJson];
        [self showMore:NO];
    }
    else {
        self.alpha = 0.0;
        [self resetSegmentIndex];
        _headerView.tfSearch.text = @"";
        [_headerView.tfSearch resignFirstResponder];
        if(self.isEditMode) {
           [self handleEditMySticker];
        }
        
    }
}

- (void)getJson {
    if(![Util isInternetActived]) {
        if(_arrItemShow.count == 0) {
            _lbNoInternet.hidden = NO;
        }
        self.indicatorView.hidden = YES;
        return;
    }
    self.tableView.hidden = NO;
    self.headerView.segmentView.hidden = YES;
    _lbNoInternet.hidden = YES;
    if(_arrItemShow.count == 0) {
        self.indicatorView.hidden = NO;
    }
    BlockWeakSelf weakself = self;
    _isGetingJson = YES;
    NSString* strUrl = [userDefaults objectForKey:JSON_URL_KEY];
    if(strUrl.length == 0) {
        [Util getConfigIfNeededWithCompleteBlock:^(NSString *responseObject) {
            if(responseObject) {
                [weakself getJson];
            }
        }];
    }
    else {
        [Util getDataFromSerVer:strUrl completeBlock:^(NSString *responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakself.isGetingJson = NO;
                weakself.jsonDataArray = [NSJSONSerialization JSONObjectWithData:[responseObject dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
                [userDefaults setObject:weakself.jsonDataArray forKey:JSON_DATA_ARR];
                [userDefaults synchronize];
                [weakself filterDownloadedPackage];
                weakself.indicatorView.hidden = YES;
                [weakself.tableView reloadData];
                [weakself generateTagsArray];
                weakself.headerView.segmentView.hidden = NO;
            });
        }];
    }
    
}

- (void)generateTagsArray {
    [_arrTags removeAllObjects];
    BlockWeakSelf weakSelf = self;
    [self.arrItemShow enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            NSMutableDictionary* dictTag;
            NSDictionary*dict = obj;
            NSString*  str = [dict objectForKey:@"tag"];
            NSArray* arrTag = [str componentsSeparatedByString:@","];
            for(str in arrTag) {
                BOOL isContain = NO;
                for(dictTag in _arrTags) {
                    NSString* tag = [dictTag objectForKey:@"tag"];
                    if([tag isEqualToString:str]) {
                        NSNumber* num = (NSNumber*)[dictTag objectForKey:@"num"];
                        NSInteger i = num.integerValue + 1;
                        [dictTag setObject:[NSNumber numberWithInteger:i] forKey:@"num"];
                        isContain = YES;
                        break;
                    }
                }
                if(!isContain) {
                    dictTag = [NSMutableDictionary new];
                    [dictTag setObject:str forKey:@"tag"];
                    [dictTag setObject:[NSNumber numberWithInteger:1]  forKey:@"num"];
                    if([str isEqualToString:@"hot"]) {
                        [weakSelf.arrTags insertObject:dictTag atIndex:0];
                    }
                    else if([str isEqualToString:@"free"]) {
                        [weakSelf.arrTags insertObject:dictTag atIndex:1];
                    }
                    else {
                        [weakSelf.arrTags addObject:dictTag];
                    }
                }
            }
        }
    }];
    NSArray *sortedArray;
    sortedArray = [_arrTags sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString*  str = [a objectForKey:@"tag"];
        if([str isEqualToString:@"hot"]) {
            return NO;
        }
        if([str isEqualToString:@"free"]) {
            return NO;
        }
        NSNumber* num1 = (NSNumber*)[a objectForKey:@"num"];
        NSNumber* num2 = (NSNumber*)[b objectForKey:@"num"];
        return num1.integerValue < num2.integerValue;
    }];
    [_arrTags removeAllObjects];
    [_arrTags addObjectsFromArray:sortedArray];
}

- (void)filterDownloadedPackage {
    self.arrItemShow = [[NSMutableArray alloc] initWithArray:[self.jsonDataArray objectForKey:@"sticker"]];
    NSMutableArray* arr = [NSMutableArray new];
    [[StickerManager getInstance].arrPackages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        StickerPack* stiPack = obj;
        for(NSDictionary*dict in self.arrItemShow) {
            if([stiPack.productID isEqualToString:[dict objectForKey:@"product_id"]]) {
                [arr addObject:dict];
                break;
            }
        }
    }];
    if(arr.count > 0) {
        [self.arrItemShow removeObjectsInArray:arr];
    }
    for (int x = 0; x < [self.arrItemShow count]; x++) {
        int randInt = (arc4random() % ([self.arrItemShow count] - x)) + x;
        [self.arrItemShow exchangeObjectAtIndex:x withObjectAtIndex:randInt];
    }
    [_arrFilterMySticker removeAllObjects];
    _arrFilterMySticker = [[NSMutableArray alloc] initWithArray:self.arrItemShow];

}

- (void)handleSearch {
    [self.arrItemShow removeAllObjects];
    if(self.headerView.tfSearch.text.length == 0) {
        [self.arrItemShow addObjectsFromArray:_arrFilterMySticker];
    }
    else {
        BlockWeakSelf weakSelf = self;
        [self.arrFilterMySticker enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary*dict = obj;
            NSString* strId = (NSString*)[dict objectForKey:@"title"];
            if ([strId rangeOfString:_headerView.tfSearch.text options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [weakSelf.arrItemShow addObject:dict];
            }
        }];
    }
    [self.tableView reloadData];
    
}

- (void)layoutSubviews {
    [self bringSubviewToFront:self.tableView];
}

- (void)reloadData {
    BlockWeakSelf weakself = self;
    da_main(^{
        [weakself.tableView reloadData];
    });
}

- (UIView*)createHeaderTitle {
    float fontSize = 18;
    UILabel *labelHeader = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, _tableView.bounds.size.width, HeightHeaderTitle)];
    labelHeader.font = [UIFont systemFontOfSize:fontSize];
    [labelHeader setTextColor:[UIColor colorFromHexString:@"#666666"]];
    labelHeader.tag = 999;
    UIView *headerView = [[UIView alloc] init];
    headerView.clipsToBounds = YES;
    [headerView addSubview:labelHeader];
    headerView.backgroundColor =  UIColorFromHexa(0xefeff4);;
    headerView.alpha = 0.9f;
    // Line bottom
    UIView *lineBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, HeightHeaderTitle - 0.5f, _tableView.bounds.size.width, 1.0f)];
    lineBottomView.backgroundColor = [UIColor colorWithRed:224.0f/255 green:224.0f/255 blue:224.0f/255 alpha:1.0];
    [headerView addSubview:lineBottomView];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderTitleSection:)];
    [headerView addGestureRecognizer:tap];
    UIImageView* imageArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zpoint_arrow_down"]];
    imageArrow.tag = 888;
    imageArrow.frame = CGRectMake(_tableView.frame.size.width - 12 - 15, (HeightHeaderTitle-8)/2, 12, 8);
    [headerView addSubview:imageArrow];
    return headerView;
}

- (IBAction)tapHeaderTitleSection:(id)sender{
    UITapGestureRecognizer* tap = sender;
    [_arrItemsSelectedTag removeAllObjects];
    if(_tagSectionSelected == tap.view.tag) {
        _tagSectionSelected = -1;
    }
    else {
        _tagSectionSelected = tap.view.tag;
        NSDictionary* dict = [_arrTags objectAtIndex:_tagSectionSelected-2];
        NSString* tagSelected = [dict objectForKey:@"tag"];
        BlockWeakSelf weakSelf = self;
        [self.arrFilterMySticker enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                NSDictionary*dict = obj;
                NSString*  str = [dict objectForKey:@"tag"];
                NSArray* arrTag = [str componentsSeparatedByString:@","];
                for(str in arrTag) {
                    if( [str caseInsensitiveCompare:tagSelected] == NSOrderedSame ) {
                        [weakSelf.arrItemsSelectedTag addObject:dict];
                        break;
                    }
                }
            }
        }];
    }
    [_tableView reloadData];
    if(_tagSectionSelected >= 0 && _arrItemsSelectedTag.count > 0) {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:_tagSectionSelected];
        [self.tableView scrollToRowAtIndexPath:ip
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_segmentSelected == indexSegmentTag) {
        return _arrTags.count + 2;
    }
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return _headerViewTop;
    }
    else if(section == 1) {
        return _headerView;
    }
    if(_segmentSelected == indexSegmentTag) {
        UIView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headertitle"];
        if (!headerView) {
            headerView = [self createHeaderTitle];
        }
        UILabel* titleLabel = (UILabel *)[headerView viewWithTag:999];
        NSDictionary* dict = [_arrTags objectAtIndex:section-2];
        titleLabel.text = [NSString stringWithFormat:@"#%@ (%@)",[[dict objectForKey:@"tag" ] capitalizedString],[dict objectForKey:@"num"]];
        headerView.tag = section;
        UIImageView* imgArrow = (UIImageView *)[headerView viewWithTag:888];
        if(section == _tagSectionSelected) {
            imgArrow.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
        }
        else {
            imgArrow.transform = CGAffineTransformIdentity;
        }
        return headerView;
    }
  
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 65;
    if(section == 1) return HeightHeader;
    if(_segmentSelected == indexSegmentTag) return HeightHeaderTitle;
    return 0.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return 0;
    if(tableView.editing) return _arrMySticker.count;
    if(_segmentSelected == indexSegmentTag) {
        if(_tagSectionSelected == section) {
            return _arrItemsSelectedTag.count;
        }
        return 0;
    }
    return self.arrItemShow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* dict;
    ShoppingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingTableViewCell"];
    if(tableView.editing) {
        StickerPack* pack = [_arrMySticker objectAtIndex:indexPath.row];
        [cell loadCellWithPackage:pack];
        return cell;
    }
    if(_segmentSelected == indexSegmentTag) {
        dict = [_arrItemsSelectedTag objectAtIndex:indexPath.row];

    }
    else {
        dict = [self.arrItemShow objectAtIndex:indexPath.row];
    }
    
    [cell loadCellWithDict:dict];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HeightRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_headerView.tfSearch resignFirstResponder];
    if(!_isEditMode) {
        [self showMore:NO];
    }
    
    NSDictionary* dict;
    if(!tableView.editing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if(_segmentSelected == indexSegmentTag) {
            dict = [_arrItemsSelectedTag objectAtIndex:indexPath.row];
            
        }
        else {
            dict = [self.arrItemShow objectAtIndex:indexPath.row];
        }
        _cellSelected = [tableView cellForRowAtIndexPath:indexPath];
        self.detailView.dictSticker = dict;
        self.detailView.leadingShopingViewContraint = self.leadingDetailViewContraint;
        [self showDetailView:YES];
        [self.detailView loadDetail];
    }
    else {
        self.headerView.btnRestore.enabled = [_tableView indexPathsForSelectedRows].count > 0 ? YES : NO;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.editing) {
        self.headerView.btnRestore.enabled = [_tableView indexPathsForSelectedRows].count > 0 ? YES : NO;
    }
}

- (void)showDetailView:(BOOL)show {
    if(show) {
        self.leadingDetailViewContraint.constant = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.overlayView.alpha = 9.0;
    }];
}


- (void)handleEditMySticker {
    [self resetSegmentIndex];
    [_headerView.tfSearch resignFirstResponder];
    if(!_isEditMode) {
        _headerView.traillingBtnMySticker.constant = 8.f;
        _headerView.btnMore.hidden = YES;
        _isEditMode = YES;
        _indicatorView.hidden = YES;
        [_arrMySticker removeAllObjects];
        [_arrMySticker addObjectsFromArray:[StickerManager getInstance].arrPackages];
        [_headerView showMySticker:YES];
        _tableView.allowsMultipleSelectionDuringEditing = true;
        _tableView.allowsSelectionDuringEditing = YES;
        [_tableView setContentOffset:CGPointZero animated:NO];
    }
    else {
        _headerView.btnMore.hidden = NO;
        [self showMore:NO];
        if(self.isGetingJson) {
            _indicatorView.hidden = NO;
        }
        _tableView.allowsMultipleSelectionDuringEditing = false;
        _tableView.allowsSelectionDuringEditing = NO;
        _isEditMode = NO;
        [_headerView showMySticker:NO];
        [self saveEditMySticker];
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_mysticker_did_endEditin object:nil];
    }
    self.tableView.editing = _isEditMode;
    [self.tableView reloadData];
    [self bringSubviewToFront:self.tableView];
}


- (void)handleMoreButton {
    [_headerView.tfSearch resignFirstResponder];
    [self showMore:!_isShowMore];
}

- (void)showMore:(BOOL)show {
    if(show) {
        _isShowMore = YES;
        [_headerView.btnMore setImage:[[UIImage imageNamed:@"more"] imageMaskedWithColor:_headerView.btnMySticker.currentTitleColor] forState:UIControlStateNormal];
        _headerView.traillingFullTfSearch.constant = 190;
        _headerView.traillingBtnMySticker.constant = 50.f;
    }
    else {
        _isShowMore = NO;
        [_headerView.btnMore setImage:[[UIImage imageNamed:@"more"] imageMaskedWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
        _headerView.traillingFullTfSearch.constant = 50;
        _headerView.traillingBtnMySticker.constant = -150;
    }
    BlockWeakSelf weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.headerView updateFocusIfNeeded];
        [weakSelf.headerView layoutIfNeeded];
    }];
}

- (void)saveEditMySticker {
    [[StickerManager getInstance].arrPackages removeAllObjects];
    [[StickerManager getInstance].arrPackages addObjectsFromArray:_arrMySticker];
    [[StickerManager getInstance] saveArrPackage];
    [_arrDeletePack removeAllObjects];
}

- (void)handleRestoreClick {
    
    [_headerView.tfSearch resignFirstResponder];
    if(_tableView.isEditing) { //delete
        for(NSIndexPath* indextPath in [_tableView indexPathsForSelectedRows]) {
            [_arrDeletePack addObject:[_arrMySticker objectAtIndex:indextPath.row]];
        }
        //delete file
        for(StickerPack* pack in _arrDeletePack) {
            [FileManager deleteStickerPackage:pack];
        }
        [_arrMySticker removeObjectsInArray:_arrDeletePack];
        [self saveEditMySticker];
        [self.tableView reloadData];
        self.headerView.btnRestore.enabled = NO;
    }
    else { //restore
        [self showMore:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_click_restore object:nil];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self showMore:NO];
    [self resetSegmentIndex];
}

- (void)resetSegmentIndex {
    if(_segmentSelected == indexSegmentTag) {
        _segmentSelected = indexSegmentAll;
        _tagSectionSelected = -1;
        [_headerView.segmentView.segmentedControl setSelectedSegmentIndex:indexSegmentAll];
        [self performSelectorWithBlock:^{
            [_tableView reloadData];
        } afterDelay:0.5];
    }
}

-(void)textFieldDidChange:(id)sender {
    [self handleSearch];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
     [_headerView.tfSearch resignFirstResponder];
    if(!_isEditMode) {
        [self showMore:NO];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    StickerPack* pack = _arrMySticker[sourceIndexPath.row];
    [_arrMySticker removeObjectAtIndex:sourceIndexPath.row];
    [_arrMySticker insertObject:pack atIndex:destinationIndexPath.row];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Detemine if it's in editing mode
//    if (self.tableView.editing) {
//        return UITableViewCellEditingStyleDelete;
//    }
    return UITableViewCellEditingStyleNone;
}


- (void)didChangeX:(CGFloat)x {
    CGFloat alpha = (self.frame.size.width - x)/self.frame.size.width;
    self.overlayView.alpha = MIN(alpha, 0.7);
}

- (void)didClose {
    self.overlayView.alpha = 0.0;
}

- (void)didTouchDownload {
    [_cellSelected handleDownload:nil];
}
@end
