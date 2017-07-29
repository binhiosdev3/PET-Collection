//
//  ShoppingView.m
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/24/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "ShoppingView.h"
#import "StickerManager.h"
#import "ShoppingTableViewCell.h"
#import "Constant.h"

@implementation ShoppingView

typedef void(^ResponseObjectCompleteBlock)(NSString *responseObject);

- (void)setUpView {
    _indexSelected = -1;
    self.alpha = 0.0;
    _tableView.hidden = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    NSString *filePath = [[NSBundle mainBundle].resourcePath stringByAppendingFormat:@"/Stickers/rubiks.gif"];
//    NSURL    *imageURL = [NSURL fileURLWithPath:filePath];
//    [_headerImg sd_setImageWithURL:imageURL];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_add_package_download_complete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completedAddPackage)name:notification_add_package_download_complete object:nil];
    /*
    if([[userDefaults objectForKey:IS_PURCHASE_KEY] intValue] == 1) {
        self.heightViewPurchaseButton.constant = 0;
    }
    else {
        self.heightViewPurchaseButton.constant = 60;
    }
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];*/
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
    BlockWeakSelf weakself = self;
    [self getDataFromSerVer:JSON_URL completeBlock:^(NSString *responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.jsonDataArray = [NSJSONSerialization JSONObjectWithData:[responseObject dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
            [weakself filterDownloadedPackage];
            weakself.tableView.hidden = NO;
            [weakself.tableView reloadData];
        });
    }];
}

- (void)filterDownloadedPackage {
    self.arrItemShow = [[NSMutableArray alloc] initWithArray:[self.jsonDataArray objectForKey:@"sticker"]];
    NSMutableArray* arr = [NSMutableArray new];
    for(StickerPack* stiPack in [StickerManager getInstance].arrPackages) {
        for(NSDictionary*dict in self.arrItemShow) {
            if([stiPack.packageID isEqualToString:[dict objectForKey:@"id"]]) {
                [arr addObject:dict];
                break;
            }
        }
    }
    if(arr.count > 0) {
        [self.arrItemShow removeObjectsInArray:arr];
    }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrItemShow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingTableViewCell"];
    NSDictionary* dict = [self.arrItemShow objectAtIndex:indexPath.row];
    if(indexPath.row == _indexSelected) cell.selected = YES;
    [cell loadCell:dict];
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
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        CGFloat height = 0;
        if(_indexSelected != indexPath.row) {
            _indexSelected = indexPath.row;
            height = 75*(indexPath.row);
        }
        else {
            _indexSelected = -1;
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES]; //commenting u are setting it by using setContentOffset so dont use this
        [tableView setContentOffset:CGPointMake(0, height )animated:YES]; //set the selected cell to top

    });*/
}

@end
