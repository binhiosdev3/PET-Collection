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
@property (nonatomic,weak) IBOutlet UILabel* lbFreeDownload;
@property (nonatomic,weak) IBOutlet KBRoundedButton* btnDownload;
@property (nonatomic,weak) IBOutlet UIImageView* imgViewArrow;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint* heightPreviewImg;
@property (nonatomic,weak) IBOutlet FLAnimatedImageView* previewImg;
@property (nonatomic,assign) NSDictionary* packageDict;
@end

@implementation ShoppingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage* imgDownIcon = [UIImage imageNamed:@"images-2"];
    [_btnDownload setImage:imgDownIcon forState:UIControlStateNormal];
    [_btnDownload setBackgroundColorForStateNormal:[UIColor clearColor]];
    [_btnDownload setBackgroundColorForStateDisabled:[UIColor lightGrayColor]];
    UIImage* imgArrow = [[UIImage imageNamed:@"10897-200"] imageMaskedWithColor:[UIColor lightGrayColor]];
    [_imgViewArrow setImage:imgArrow];
    [_lbFreeDownload.layer setMasksToBounds:YES];
    [_lbFreeDownload.layer setCornerRadius:5.f];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)expand:(BOOL)expand {
    if(expand) {
        self.heightPreviewImg.constant = [self heightWhenExpand];
        self.previewImg.image = [UIImage imageNamed:@"b"];
    }
    else {
        self.heightPreviewImg.constant = 0;
    }
    self.previewImg.hidden = !expand;
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}


- (CGFloat)heightWhenExpand {
    CGFloat h= (self.frame.size.width - 70)*488/364;
    return h;
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
    self.selectedBackgroundView = nil;
    [self expand:self.selected];
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
