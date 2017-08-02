//
//  ShoppingView.m
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/24/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "ShoppingView.h"


@implementation ShoppingView

typedef void(^ResponseObjectCompleteBlock)(NSString *responseObject);


- (void)setUpView {
    _isEditMode = NO;
    _arrMySticker = [NSMutableArray new];
    _headerView = [[HeaderSectionView alloc] init];
    [_headerView.btnMySticker addTarget:self action:@selector(handleEditMySticker) forControlEvents:UIControlEventTouchUpInside];
    _headerView.tfSearch.delegate = self;
    [_headerView.tfSearch addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _headerView.tfSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_headerView showMySticker:NO];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShoppingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ShoppingTableViewCell"];
    _indexSelected = -1;
    self.alpha = 0.0;
    _tableView.hidden = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
//    NSString *filePath = [[NSBundle mainBundle].resourcePath stringByAppendingFormat:@"/Stickers/rubiks.gif"];
//    NSURL    *imageURL = [NSURL fileURLWithPath:filePath];
//    [_headerImg sd_setImageWithURL:imageURL];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_add_package_download_complete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completedAddPackage)name:notification_add_package_download_complete object:nil];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.detailView.delegate = self;
    self.overlayView.alpha = 0.0;
    self.leadingDetailViewContraint.constant = self.frame.size.width;
}

- (void)completedAddPackage {
    [self reloadData];
}

- (void)show:(BOOL)show {
    if(show) {
        self.alpha = 1.0;
        [self getJson];
        [_btnPurchase setTitle:@"Unlock All Stickers" forState:UIControlStateNormal];
    }
    else {
        if(_indexSelected >=0) {
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:_indexSelected inSection:0] animated:YES];
            _indexSelected = -1;
        }
        
        self.alpha = 0.0;
        self.tableView.hidden = YES;
        
    }
}

- (void)getJson {
    self.indicatorView.hidden = NO;
    BlockWeakSelf weakself = self;
    [self getDataFromSerVer:JSON_URL completeBlock:^(NSString *responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.jsonDataArray = [NSJSONSerialization JSONObjectWithData:[responseObject dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
            [weakself filterDownloadedPackage];
            weakself.indicatorView.hidden = YES;
            weakself.tableView.hidden = NO;
            [weakself.tableView reloadData];
        });
    }];
}

- (void)filterDownloadedPackage {
    self.arrItemShow = [[NSMutableArray alloc] initWithArray:[self.jsonDataArray objectForKey:@"sticker"]];
    NSMutableArray* arr = [NSMutableArray new];
    [[StickerManager getInstance].arrPackages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        StickerPack* stiPack = obj;
        for(NSDictionary*dict in self.arrItemShow) {
            if([stiPack.packageID isEqualToString:[dict objectForKey:@"id"]]) {
                [arr addObject:dict];
                break;
            }
        }
    }];
    if(arr.count > 0) {
        [self.arrItemShow removeObjectsInArray:arr];
    }
    [_arrFilterMySticker removeAllObjects];
    [self.arrItemShow addObjectsFromArray:[self.jsonDataArray objectForKey:@"sticker"]];
    [self.arrItemShow addObjectsFromArray:[self.jsonDataArray objectForKey:@"sticker"]];
    [self.arrItemShow addObjectsFromArray:[self.jsonDataArray objectForKey:@"sticker"]];
    [self.arrItemShow addObjectsFromArray:[self.jsonDataArray objectForKey:@"sticker"]];
    [self.arrItemShow addObjectsFromArray:[self.jsonDataArray objectForKey:@"sticker"]];
    [self.arrItemShow addObjectsFromArray:[self.jsonDataArray objectForKey:@"sticker"]];
    [self.arrItemShow addObjectsFromArray:[self.jsonDataArray objectForKey:@"sticker"]];
    _arrFilterMySticker = [[NSMutableArray alloc] initWithArray:self.arrItemShow];
    _headerView.tfSearch.text = @"";
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

- (void)reloadData {
    BlockWeakSelf weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself filterDownloadedPackage];
        [weakself.tableView reloadData];
    });
}

- (void)getDataFromSerVer:(NSString *)url completeBlock:(ResponseObjectCompleteBlock)completeBlock {
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:url]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                if(data) {
                    NSString* responeStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    if(completeBlock) completeBlock(responeStr);
                }
            }] resume];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return _headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) return 120.f;
    return 0.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return 0;
    if(tableView.editing) return _arrMySticker.count;
    return self.arrItemShow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingTableViewCell"];
    if(tableView.editing) {
        StickerPack* pack = [_arrMySticker objectAtIndex:indexPath.row];
        [cell loadCellWithPackage:pack];
        return cell;
    }
    
    NSDictionary* dict = [self.arrItemShow objectAtIndex:indexPath.row];
    if(indexPath.row == _indexSelected) cell.selected = YES;
    [cell loadCellWithDict:dict];
    return cell;
}

- (CGFloat)heightWhenExpand {
    CGFloat w = (self.frame.size.width - 70)*488/364;
    return w;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == _indexSelected) return 75 + [self heightWhenExpand];
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* dict = [self.arrItemShow objectAtIndex:indexPath.row];
    _cellSelected = [tableView cellForRowAtIndexPath:indexPath];
    self.detailView.dictSticker = dict;
    self.detailView.leadingShopingViewContraint = self.leadingDetailViewContraint;
    [self showDetailView:YES];
    [self.detailView loadDetail];
}

- (void)showDetailView:(BOOL)show {
    if(show) {
        self.leadingDetailViewContraint.constant = 0;
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.overlayView.alpha = 9.0;
    }];
}


- (IBAction)handlePurchase:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_click_purchase object:nil];
}

- (IBAction)handleRestore:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_click_restore object:nil];
}

- (void)handleEditMySticker {
    [_headerView.tfSearch resignFirstResponder];
    if(!_isEditMode) {
        _isEditMode = YES;
        [_arrMySticker addObjectsFromArray:[StickerManager getInstance].arrPackages];
        [_headerView showMySticker:YES];
    }
    else {
        [[StickerManager getInstance].arrPackages removeAllObjects];
        [[StickerManager getInstance].arrPackages addObjectsFromArray:_arrMySticker];
        [[StickerManager getInstance] saveArrPackage];
        [_arrMySticker removeAllObjects];
        _isEditMode = NO;
        [_headerView showMySticker:NO];
        [[StickerManager getInstance] saveArrPackage];
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_mysticker_did_endEditin object:nil];
    }
    self.tableView.editing = _isEditMode;
    [self.tableView reloadData];
}

-(void)textFieldDidChange:(id)sender {
    [self handleSearch];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
     [_headerView.tfSearch resignFirstResponder];
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

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [_arrMySticker removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

- (void)showBottomAlertView:(BOOL)show {
    BlockWeakSelf weakSelf = self;
    self.topBottomAlertView.constant = show ? 0 : 80.f;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf updateConstraintsIfNeeded];
        [weakSelf layoutIfNeeded];
    }];
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
