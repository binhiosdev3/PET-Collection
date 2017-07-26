//
//  ShoppingView.m
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/24/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "ShoppingView.h"

@implementation ShoppingView

- (void)setUpView {
    _detailView.alpha = 0.0;
    self.alpha = 0.0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingTableViewCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.detailView.alpha = 1.0;
}

@end
