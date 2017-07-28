//
//  MessagesViewController.m
//  MessagesExtension
//
//  Created by vietthaibinh on 7/24/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "MessagesViewController.h"
#import "CollectionViewCell.h"
#import "ShoppingView.h"
#import "FileManager.h"
#import "StickerManager.h"
#import "FLAnimatedImageView+WebCache.h"
#import "IAPShare.h"
#import "IAPHelper.h"
#import "Constant.h"

#define delay_animate rand()%10+2

@interface MessagesViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,weak) IBOutlet UICollectionView* clSticker;
@property (nonatomic,weak) IBOutlet UICollectionView* clIcon;
@property (nonatomic,weak) IBOutlet ShoppingView* shoppingView;
@property (nonatomic,weak) IBOutlet UIButton* btnShopping;
@property (nonatomic,weak) IBOutlet UIImageView* topLine;
@property (nonatomic) NSInteger indexSelected;
@property (nonatomic) BOOL isPurchase;
@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [StickerManager getInstance];
    UIImage* imgPlus = [[UIImage imageNamed:@"icon_p"] imageMaskedWithColor:[UIColor whiteColor]];
    [_btnShopping setImage:imgPlus forState:UIControlStateNormal];
    _indexSelected = 0;
    _clSticker.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    _clIcon.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:8.0].active = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_add_package_download_complete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completedAddPackage)name:notification_add_package_download_complete object:nil];
    [self setupIAP];
    if([[userDefaults objectForKey:IS_PURCHASE_KEY] intValue] == 1) {
        self.isPurchase = YES;
    }
    else {
        self.isPurchase = NO;
    }
}

- (void)completedAddPackage {
    BlockWeakSelf weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.clIcon reloadData];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == _clSticker) {
        if([StickerManager getInstance].arrPackages.count == 0){
            return 0;
        }
        else {
            StickerPack* stickerPackage = [[StickerManager getInstance].arrPackages objectAtIndex:_indexSelected];
            return stickerPackage.arrStickerPath.count;
        }
    }
    else {
        return [StickerManager getInstance].arrPackages.count;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    int size = 40.f;
    if (collectionView == _clSticker) {
        size = (collectionView.frame.size.width)/[self numberStickerOfRow];
        return CGSizeMake(size, size);
    }
    return CGSizeMake(size, size);
}

- (int)numberStickerOfRow {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == _clIcon) {
        return [self loadIconCell:indexPath];
    }
    return [self loadStickerCell:indexPath];
}

- (UICollectionViewCell*)loadIconCell:(NSIndexPath*)indexPath {
    UICollectionViewCell* cell = [_clIcon dequeueReusableCellWithReuseIdentifier:@"IconCell" forIndexPath:indexPath];
    FLAnimatedImageView* iconImgView;

    StickerPack* stickerPackage;
    iconImgView = [cell viewWithTag:1];
    stickerPackage = [[StickerManager getInstance].arrPackages objectAtIndex:indexPath.row];
    NSURL* iconUrl =  [[FileManager stickerFileURL] URLByAppendingPathComponent:stickerPackage.iconPath];
    [iconImgView sd_setImageWithURL:iconUrl];
    UIView* selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = self.topLine.backgroundColor;
    cell.selectedBackgroundView = selectedView;
    return cell;
}

- (UICollectionViewCell*)loadStickerCell:(NSIndexPath*)indexPath {
    UICollectionViewCell* cell = [_clSticker dequeueReusableCellWithReuseIdentifier:@"StickerCell" forIndexPath:indexPath];
    FLAnimatedImageView* iconImgView;
    StickerPack* stickerPackage;
    iconImgView = [cell viewWithTag:1];
    UIImageView* lockIconImgView = [cell viewWithTag:2];
    lockIconImgView.hidden = YES;
    if(indexPath.row > NUM_STICKER_FREE && !self.isPurchase) {
        lockIconImgView.hidden = NO;
    }
    stickerPackage = [[StickerManager getInstance].arrPackages objectAtIndex:_indexSelected];
    NSString* stickerPath = [stickerPackage.arrStickerPath objectAtIndex:indexPath.row];
    NSURL* stickerUrl = [[FileManager stickerFileURL] URLByAppendingPathComponent:stickerPath];
    [iconImgView sd_setImageWithURL:stickerUrl];
    return cell;
}

-(void)viewDidLayoutSubviews {
    _clIcon.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == _clIcon) {
        if(_indexSelected == indexPath.row) return;
        [_clIcon deselectItemAtIndexPath:[NSIndexPath indexPathForItem:_indexSelected inSection:0] animated:YES];
        _indexSelected = indexPath.row;
        [self scrollCollectionToTop:_clSticker];
        [_clSticker reloadData];
    }
    else {
        if (indexPath.row > NUM_STICKER_FREE && !self.isPurchase) {
            [self handlePurchase:nil];
            return;
        }
        StickerPack* stickerPackage = [[StickerManager getInstance].arrPackages objectAtIndex:_indexSelected];
        NSString* stickerPath = [stickerPackage.arrStickerPath objectAtIndex:indexPath.row];
        NSURL* stickerUrl = [[FileManager stickerFileURL] URLByAppendingPathComponent:stickerPath];
        MSConversation *currentConversation = [self activeConversation];
        
        MSSticker *challengeSticker2 = [[MSSticker alloc] initWithContentsOfFileURL:stickerUrl localizedDescription:@"Pet Collection Sticker" error:nil];
        
        [currentConversation insertSticker:challengeSticker2 completionHandler:^(NSError * error)
        {

        }];
    }
}

- (void)scrollCollectionToTop:(UICollectionView*)cllView {
    [cllView scrollRectToVisible:CGRectMake(0,0,1,1) animated:NO];
    [cllView flashScrollIndicators];
}


- (IBAction)handleShoppingButton:(id)sender {
    if (self.presentationStyle == MSMessagesAppPresentationStyleCompact || _shoppingView.alpha == 0.0) {
        [self showShoppingView:YES];
    }
    else {
        [self showShoppingView:NO];
        [self.view bringSubviewToFront:_clIcon];
         [self requestPresentationStyle:MSMessagesAppPresentationStyleCompact];
        [self performSelector:@selector(rotatePlusImg) withObject:nil afterDelay:delay_animate];
    }
}

- (void)showShoppingView:(BOOL)show {
    if(show){
        [self requestPresentationStyle:MSMessagesAppPresentationStyleExpanded];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rotatePlusImg) object:nil];
    }
    [_shoppingView show:show];
    _btnShopping.hidden = show;
    
}

- (void)rotatePlusImg {
    [self rotateLayer:self.btnShopping.layer];
    [self performSelector:@selector(rotatePlusImg) withObject:nil afterDelay:delay_animate];
}

- (void)rotateLayer:(CALayer*)layer{
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = @0.0f;
    rotation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    rotation.duration = 0.5f; // Speed
    rotation.repeatCount = 1; // Repeat forever
    [layer addAnimation:rotation forKey:@"Spin"];
}

#pragma mark - Conversation Handling

-(void)didBecomeActiveWithConversation:(MSConversation *)conversation {
    [FileManager copyDefaultStickerToResourceIfNeeded];
    [StickerManager getInstance];
    [_shoppingView setUpView];
    [_clIcon reloadData];
    [_clSticker reloadData];
    [_clIcon selectItemAtIndexPath:[NSIndexPath indexPathForItem:_indexSelected inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rotatePlusImg) object:nil];
    [self performSelector:@selector(rotatePlusImg) withObject:nil afterDelay:delay_animate];

}

-(void)willResignActiveWithConversation:(MSConversation *)conversation {
    // Called when the extension is about to move from the active to inactive state.
    // This will happen when the user dissmises the extension, changes to a different
    // conversation or quits Messages.
    
    // Use this method to release shared resources, save user data, invalidate timers,
    // and store enough state information to restore your extension to its current state
    // in case it is terminated later.
}

-(void)didReceiveMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when a message arrives that was generated by another instance of this
    // extension on a remote device.
    
    // Use this method to trigger UI updates in response to the message.
}

-(void)didStartSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user taps the send button.
}

-(void)didCancelSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user deletes the message without sending it.
    
    // Use this to clean up state related to the deleted message.
}

-(void)willTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    if (presentationStyle == MSMessagesAppPresentationStyleCompact && _shoppingView.alpha == 1.0) {
        [self showShoppingView:NO];
    }
}

-(void)didTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    // Called after the extension transitions to a new presentation style.
    
    // Use this method to finalize any behaviors associated with the change in presentation style.
}

- (void)setupIAP {
    return;
    if(![IAPShare sharedHelper].iap) {
        
        NSSet* dataSet = [[NSSet alloc] initWithObjects:@"PetCollectionMonthlyPurchase",nil];
        
        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
        
    }
    [IAPShare sharedHelper].iap.production = NO;
    if([self isPurchased]) {
        [userDefaults setObject:@(1) forKey:IS_PURCHASE_KEY];
        _isPurchase = YES;
    }
    else {
        _isPurchase = NO;
        [userDefaults setObject:@(0) forKey:IS_PURCHASE_KEY];
    }
    [userDefaults synchronize];
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         
     }];
    
    NSLog(@"Pruchases %@",[IAPShare sharedHelper].iap.purchasedProducts);
    [[IAPShare sharedHelper].iap checkReceipt:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] AndSharedSecret:@"fb375a41a19f456f969d82a4028158a5" onCompletion:^(NSString *response, NSError *error) {
        
        //Convert JSON String to NSDictionary
        NSDictionary* rec = [IAPShare toJSON:response];
        
        if([rec[@"status"] integerValue]==0)
        {
            
//            [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
            NSLog(@"SUCCESS %@",response);
            NSLog(@"Pruchases %@",[IAPShare sharedHelper].iap.purchasedProducts);
        }
        else {
            NSLog(@"Fail");
        }
    }];

}

-(IBAction)handlePurchase:(id)sender {
    [[IAPShare sharedHelper].iap buyProduct:[[IAPShare sharedHelper].iap.products objectAtIndex:0] onCompletion:^(SKPaymentTransaction *trans) {
        if(trans.error)
        {
            NSLog(@"Fail %@",[trans.error localizedDescription]);
        }
        else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
            
            [[IAPShare sharedHelper].iap checkReceipt:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] AndSharedSecret:@"fb375a41a19f456f969d82a4028158a5" onCompletion:^(NSString *response, NSError *error) {
                
                //Convert JSON String to NSDictionary
                NSDictionary* rec = [IAPShare toJSON:response];
                
                if([rec[@"status"] integerValue]==0)
                {
                    
                    [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
                    NSLog(@"SUCCESS %@",response);
                    NSLog(@"Pruchases %@",[IAPShare sharedHelper].iap.purchasedProducts);
                }
                else {
                    NSLog(@"Fail");
                }
            }];
        }
        else if(trans.transactionState == SKPaymentTransactionStateFailed) {
            NSLog(@"Fail");
        }
    }];
}

- (BOOL)isPurchased {
    return [[IAPShare sharedHelper].iap isPurchasedProductsIdentifier:@"PetCollectionMonthlyPurchase"];
}

- (IBAction)handleRestore {
    [[IAPShare sharedHelper].iap restoreProductsWithCompletion:^(SKPaymentQueue *payment, NSError *error) {
        
    }];
}

- (void)clearALL {
    [userDefaults removeObjectForKey:StickerPackageArr_key];
    [userDefaults removeObjectForKey:numberOfPackage_key];
    [userDefaults synchronize];
}

@end
