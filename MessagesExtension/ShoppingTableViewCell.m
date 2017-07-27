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
#import "StickerManager.h"

@interface ShoppingTableViewCell()

@property (nonatomic,weak) IBOutlet FLAnimatedImageView* iconView;
@property (nonatomic,weak) IBOutlet UILabel* lbTitle;
@property (nonatomic,weak) IBOutlet KBRoundedButton* btnDownload;
@property (nonatomic,assign) NSDictionary* packageDict;
@end

@implementation ShoppingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage* imgDownIcon = [[UIImage imageNamed:@"down_filled"] imageMaskedWithColor:[UIColor whiteColor]];
    [_btnDownload setImage:imgDownIcon forState:UIControlStateNormal];
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
    for(NSString* strId in [StickerManager getInstance].arrDownloadingPack) {
        if([[_packageDict objectForKey:@"id"] isEqualToString:strId]) {
            _btnDownload.enabled = NO;
            _btnDownload.working = YES;
        }
    }
    
}

-(void)prepareForReuse {
    _btnDownload.enabled = YES;
    _btnDownload.working = NO;
}

- (IBAction)handleDownload:(id)sender {
    NSString *stringURL = [_packageDict objectForKey:@"url"];
    _btnDownload.enabled = NO;
    _btnDownload.working = YES;
    [[StickerManager getInstance].arrDownloadingPack addObject:[_packageDict objectForKey:@"id"]];
    BlockWeakSelf weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(0,0);
    dispatch_async(queue, ^{
        NSLog(@"Beginning download");
        NSURL  *url = [NSURL URLWithString:stringURL];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        NSLog(@"Got the data!");
        //Save the data
        NSLog(@"Saving");
        [FileManager createStickerWithDictionary:weakSelf.packageDict andData:urlData];


    });
}
@end
