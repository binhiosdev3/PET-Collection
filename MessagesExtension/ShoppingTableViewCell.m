//
//  ShoppingTableViewCell.m
//  PET Sticker Collection
//
//  Created by vietthaibinh on 7/27/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "ShoppingTableViewCell.h"

@interface ShoppingTableViewCell()

@property (nonatomic,weak) IBOutlet FLAnimatedImageView* iconView;
@property (nonatomic,weak) IBOutlet UILabel* lbTitle;
@property (nonatomic,weak) IBOutlet UILabel* lbFreeDownload;
@property (nonatomic,weak) IBOutlet KBRoundedButton* btnDownload;
@property (nonatomic,weak) IBOutlet UIButton* btnDownloadBack;
@property (nonatomic,weak) IBOutlet UIImageView* imgViewArrow;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint* heightPreviewImg;
@property (nonatomic,weak) IBOutlet FLAnimatedImageView* previewImg;
@property (nonatomic,weak) IBOutlet UIImageView* imgPlay;
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


- (void)loadCellWithDict:(NSDictionary*)dict{
    _packageDict = dict;
    _btnDownload.hidden = NO;
    _lbFreeDownload.hidden = NO;
    _btnDownloadBack.hidden = NO;
    NSString* str = [_packageDict objectForKey:@"icon"];
    _lbTitle.text = [[_packageDict objectForKey:@"title"] capitalizedString];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:str]];
    for(NSString* strId in [StickerManager getInstance].arrDownloadingPack) {
        if([[_packageDict objectForKey:@"product_id"] isEqualToString:strId]) {
            _btnDownload.enabled = NO;
            _btnDownload.working = YES;
        }
    }
    if([[_packageDict objectForKey:@"price"] isEqualToString:@"FREE"]) {
        _lbFreeDownload.text = @"  FREE  ";
    }
    else {
        _lbFreeDownload.text = [NSString stringWithFormat:@"  %@  ",[_packageDict objectForKey:@"price"]];
    }
    _imgPlay.hidden = [[_packageDict objectForKey:@"isGif"] intValue] == 0 ? YES : NO;
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
}

- (void)loadCellWithPackage:(StickerPack*)pack {
    _btnDownload.hidden = YES;
    _lbFreeDownload.hidden = YES;
    _btnDownloadBack.hidden = YES;
    _lbTitle.text = [pack.title capitalizedString];
    NSURL* iconUrl =  [[FileManager stickerFileURL] URLByAppendingPathComponent:pack.iconPath];
    [_iconView sd_setImageWithURL:iconUrl];
    _imgPlay.hidden = !pack.isAnimated;
}

-(void)prepareForReuse {
    _btnDownload.enabled = YES;
    _btnDownload.working = NO;
}

- (IBAction)handleDownload:(id)sender {
    NSString *stringURL = [_packageDict objectForKey:@"url"];
    _btnDownload.enabled = NO;
    _btnDownload.working = YES;
    
    [Util downloadPackage:stringURL andDict:self.packageDict];
}




@end
