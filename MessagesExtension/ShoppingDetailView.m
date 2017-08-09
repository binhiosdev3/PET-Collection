//
//  ShoppingDetailView.m
//  PET Sticker Collection
//
//  Created by vietthaibinh on 8/2/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "ShoppingDetailView.h"

@interface ShoppingDetailView() <UIGestureRecognizerDelegate>
@property (nonatomic,weak) IBOutlet UIScrollView* scrllView;
@property (nonatomic,weak) IBOutlet FLAnimatedImageView* iconImgView;
@property (nonatomic,weak) IBOutlet FLAnimatedImageView* preViewImg;
@property (nonatomic,weak) IBOutlet UILabel* lbTitle;
@property (nonatomic,weak) IBOutlet UIImageView* imgArrowSwipe;
@property (nonatomic,weak) IBOutlet KBRoundedButton* btnDownload;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint* heightOfContentView;
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView* downloadIndicator;
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView* loadingImageIndicator;
@property (nonatomic,weak) IBOutlet UILabel* lbFreeDownload;
@end

@implementation ShoppingDetailView

- (void)awakeFromNib {
    [super awakeFromNib];
    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(handlePan:)];
    pan.maximumNumberOfTouches = 1;
    pan.cancelsTouchesInView = NO;
    [pan setEdges:UIRectEdgeLeft];
    [pan setDelegate:self];
    [self addGestureRecognizer:pan];
    _imgArrowSwipe.image = [[UIImage imageNamed:@"swipe-right"] imageMaskedWithColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completedAddPackage:)name:notification_add_package_download_complete object:nil];
    [_lbFreeDownload.layer setMasksToBounds:YES];
    [_lbFreeDownload.layer setCornerRadius:5.f];
}

static CGPoint prelocation;

static bool islefttoright;

- (void)completedAddPackage:(NSNotification*)notification {
    if(self.leadingShopingViewContraint.constant == self.frame.size.width) return;
    BlockWeakSelf weakSelf = self;
    da_main(^{
        NSDictionary* dict = notification.userInfo;
        NSString* strID =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        NSString* strID2 =  [NSString stringWithFormat:@"%@",[weakSelf.dictSticker objectForKey:@"id"]];
        if([strID isEqualToString:strID2]) {
            weakSelf.downloadIndicator.hidden = YES;
            [weakSelf.btnDownload setTitle:@"Downloaded" forState:UIControlStateDisabled];
        }
    });
    
}

- (void)handlePan:(UIPanGestureRecognizer *)sender{
    
    if(sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged)
    {
        
        CGPoint location = [sender locationInView:self.superview];
        islefttoright = location.x - prelocation.x   > 0;
        prelocation = location;
        self.leadingShopingViewContraint.constant = prelocation.x;
        if([self.delegate respondsToSelector:@selector(didChangeX:)]) {
            [self.delegate didChangeX:self.leadingShopingViewContraint.constant];
        }
    }
    else if(sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled)
    {
        
        if(self.frame.origin.x < self.frame.size.width * 0.25 || !islefttoright) // more then half of a button visible
        {
            self.leadingShopingViewContraint.constant = 0.f;
            if([self.delegate respondsToSelector:@selector(didChangeX:)]) {
                [self.delegate didChangeX:self.leadingShopingViewContraint.constant];
            }
            [UIView animateWithDuration:0.2 animations:^{
                [self.superview updateConstraintsIfNeeded];
                [self.superview layoutIfNeeded];
            }];
        }
        else
        {
            [self close:nil];
        }
    }

}

- (void)loadDetail{
    [self.scrllView setContentOffset:CGPointZero];
    if([[self.dictSticker objectForKey:@"product_id"] isEqualToString:@"FREE"]) {
        _lbFreeDownload.text = @"  FREE  ";
    }
    else {
        _lbFreeDownload.text = @"  0.99$  ";
    }

    NSString* str = [self.dictSticker objectForKey:@"icon"];
    _lbTitle.text = [[self.dictSticker objectForKey:@"title"] capitalizedString];
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:str]];
    BlockWeakSelf weakSelf = self;
    self.heightOfContentView.constant = self.frame.size.height;
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    weakSelf.loadingImageIndicator.hidden = NO;
    [_preViewImg sd_setImageWithURL:[NSURL URLWithString:[self.dictSticker objectForKey:@"img_pre"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(image) {
            da_main(^{
                weakSelf.loadingImageIndicator.hidden = YES;
                CGFloat w = image.size.width;
                CGFloat h = image.size.height;
                CGFloat height = h*self.frame.size.width/w + 270;
                weakSelf.heightOfContentView.constant = height;
                [weakSelf updateConstraintsIfNeeded];
                [weakSelf layoutIfNeeded];
            });
        }
    }];
    [self setDownloadingButtonStatus:NO];
    for(NSString* strId in [StickerManager getInstance].arrDownloadingPack) {
        if([[_dictSticker objectForKey:@"id"] isEqualToString:strId]) {
            [self setDownloadingButtonStatus:YES];
        }
    }
}

- (void)setDownloadingButtonStatus:(BOOL)isDownloading {
    if(isDownloading) {
        _btnDownload.enabled = NO;
        _btnDownload.alpha = 0.8;
        [_btnDownload setTitle:@"Downloading..." forState:UIControlStateDisabled];
        _downloadIndicator.hidden = NO;
    }
    else {
        [_btnDownload setTitle:@"Free Download" forState:UIControlStateDisabled];
        _btnDownload.enabled = YES;
        _downloadIndicator.hidden = YES;
        _btnDownload.alpha = 1.0;
    }
}

- (IBAction)handleDownload:(id)sender {
    [self setDownloadingButtonStatus:YES];
    if([self.delegate respondsToSelector:@selector(didTouchDownload)]) {
        [self.delegate didTouchDownload];
    }
}

- (IBAction)close:(id)sender{
    self.leadingShopingViewContraint.constant = self.frame.size.width;
    if([self.delegate respondsToSelector:@selector(didClose)]) {
        [self.delegate didClose];
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self.superview updateConstraintsIfNeeded];
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

@end
