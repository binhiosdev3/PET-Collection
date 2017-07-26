//
//  ShoppingView.m
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/24/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "ShoppingView.h"
#import "FLAnimatedImageView+WebCache.h"

@implementation ShoppingView



- (void)setUpView {
    _detailView.alpha = 0.0;
    self.alpha = 0.0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    NSString* myJSON = [self getDataFrom:@"https://gist.githubusercontent.com/binhiosdev3/2443f758e248b1697bc3289feb97f927/raw/"];
    
    _jsonDataArray = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    [self.tableView reloadData];
}

- (NSString *) getDataFrom:(NSString *)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        return nil;
    }
    
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingTableViewCell"];
    FLAnimatedImageView* iconView = [cell viewWithTag:1];
    UILabel* lbTitle = [cell viewWithTag:2];
    UIButton* btn = [cell viewWithTag:3];
    
    NSArray* arr = [_jsonDataArray objectForKey:@"sticker"];
    NSDictionary* dict = [arr firstObject];
    NSString* str = [dict objectForKey:@"icon"];
    lbTitle.text = [dict objectForKey:@"title"];
    [iconView sd_setImageWithURL:[NSURL URLWithString:str]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.detailView.alpha = 1.0;
}

@end
