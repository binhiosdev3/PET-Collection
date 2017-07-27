//
//  ShoppingTableViewCell.m
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/27/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "ShoppingTableViewCell.h"
#import "FLAnimatedImageView+WebCache.h"
#import "FileManager.h"

@interface ShoppingTableViewCell()

@property (nonatomic,weak) IBOutlet FLAnimatedImageView* iconView;
@property (nonatomic,weak) IBOutlet UILabel* lbTitle;
@property (nonatomic,weak) IBOutlet UIButton* btnDownload;
@property (nonatomic,assign) NSDictionary* packageDict;
@end

@implementation ShoppingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadCell:(NSDictionary*)dict {
    _packageDict = dict;
    NSString* str = [_packageDict objectForKey:@"icon"];
    _lbTitle.text = [_packageDict objectForKey:@"title"];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:str]];
}


- (IBAction)handleDownload:(id)sender {
    NSString *stringURL = [_packageDict objectForKey:@"url"];
    BlockWeakSelf weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(0,0);
    dispatch_async(queue, ^{
        NSLog(@"Beginning download");
        
        NSURL  *url = [NSURL URLWithString:stringURL];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        
        //Find a cache directory. You could consider using documenets dir instead (depends on the data you are fetching)
        NSLog(@"Got the data!");
        //Save the data
        NSLog(@"Saving");
        [FileManager createStickerWithDictionary:weakSelf.packageDict andData:urlData];
//        [urlData writeToFile:dataPath atomically:YES];

    });
}
@end
