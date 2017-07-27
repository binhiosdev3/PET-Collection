//
//  ShoppingView.m
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/24/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "ShoppingView.h"
#import "FLAnimatedImageView+WebCache.h"
#import "ShoppingTableViewCell.h"
#import "Constant.h"

@implementation ShoppingView

typedef void(^ResponseObjectCompleteBlock)(NSString *responseObject);

- (void)setUpView {
    _detailView.alpha = 0.0;
    self.alpha = 0.0;
    _tableView.hidden = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)show:(BOOL)show {
    if(show) {
        self.alpha = 1.0;
        [self getJson];
    }
    else {
        self.alpha = 0.0;
        self.tableView.hidden = YES;
    }
}

- (void)getJson {
    BlockWeakSelf weakself = self;
    [self getDataFromSerVer:JSON_URL completeBlock:^(NSString *responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.jsonDataArray = [NSJSONSerialization JSONObjectWithData:[responseObject dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
            weakself.tableView.hidden = NO;
            [weakself.tableView reloadData];
        });
    }];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingTableViewCell"];
    NSArray* arr = [_jsonDataArray objectForKey:@"sticker"];
    NSDictionary* dict = [arr firstObject];
    [cell loadCell:dict];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.detailView.alpha = 1.0;
}

@end
