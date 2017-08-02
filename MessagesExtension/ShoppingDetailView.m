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
@property (nonatomic,weak) IBOutlet KBRoundedButton* btnDownload;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint* heightOfContentView;
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
}

static CGPoint prelocation;

static bool islefttoright;

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
    NSString* str = [self.dictSticker objectForKey:@"icon"];
    _lbTitle.text = [[self.dictSticker objectForKey:@"title"] capitalizedString];
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:str]];
    [_preViewImg sd_setImageWithURL:[NSURL URLWithString:[self.dictSticker objectForKey:@"img_pre"]]];
    CGFloat w = [[self.dictSticker objectForKey:@"w_preview"] floatValue];
    CGFloat h = [[self.dictSticker objectForKey:@"h_preview"] floatValue];
    CGFloat height = h*self.frame.size.width/w + 250;
    self.heightOfContentView.constant = height;
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    for(NSString* strId in [StickerManager getInstance].arrDownloadingPack) {
        if([[_dictSticker objectForKey:@"id"] isEqualToString:strId]) {
            _btnDownload.enabled = NO;
            _btnDownload.working = YES;
        }
    }
}

- (IBAction)handleDownload:(id)sender {
    self.btnDownload.enabled = NO;
    self.btnDownload.working = YES;
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
