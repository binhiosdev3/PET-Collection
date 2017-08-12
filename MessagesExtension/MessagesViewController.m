//
//  MessagesViewController.m
//  MessagesExtension
//
//  Created by vietthaibinh on 7/24/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "MessagesViewController.h"
#import "ShoppingView.h"
#import "FLAnimatedImageView+WebCache.h"
#import <Messages/Messages.h>
#import "UIView+ExtLayout.h"
#import "StickerBrowserViewController.h"
#import "FooterCollectionReusableView.h"
#import "IAPShare.h"
#import "OverlayView.h"

#define delay_animate rand()%10+2

@interface MessagesViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,weak) IBOutlet UICollectionView* clSticker;
@property (nonatomic,weak) IBOutlet UICollectionView* clIcon;
@property (nonatomic,weak) IBOutlet ShoppingView* shoppingView;
@property (nonatomic,weak) IBOutlet OverlayView* overlayView;
@property (nonatomic,weak) IBOutlet UIView* viewSticker;
@property (nonatomic,weak) IBOutlet UIView* noStickerView;
@property (nonatomic,strong) StickerBrowserViewController* browserStickerVC;
@property (nonatomic,weak) IBOutlet UIButton* btnShopping;
@property (nonatomic,weak) IBOutlet UIImageView* topLine;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint* topShoppingViewContraint;
@property (nonatomic) NSInteger indexSelected;
@property (nonatomic) BOOL isPurchase;
@property (nonatomic) BOOL isRestoring;
@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Util getConfigIfNeededWithCompleteBlock:nil];
    [self setupIAPHelper];
    if(![[userDefaults objectForKey:PASS_FIRST_LOAD_KEY] boolValue]) {
        [FileManager copyDefaultStickerToResourceIfNeeded];
        [userDefaults setObject:@(1) forKey:PASS_FIRST_LOAD_KEY];
        [userDefaults synchronize];
    }
    [self addObserver];
    [StickerManager getInstance];
    [self setUpUI];
}

- (void)setupIAPHelper {
    if(![IAPShare sharedHelper].iap) {
        NSSet* dataSet;
        NSDictionary* dict = [userDefaults objectForKey:JSON_DATA_ARR];
        if(dict) {
            NSArray* jsonSticker = [[NSMutableArray alloc] initWithArray:[dict objectForKey:@"sticker"]];
            NSMutableArray* arrProductId = [NSMutableArray new];
            for(NSDictionary*dict in jsonSticker) {
                [arrProductId addObject:[dict objectForKey:@"product_id"]];
            }
            [arrProductId addObjectsFromArray:DEFAULT_STICKER_PACKAGE_PRODUCTID];
            dataSet = [[NSSet alloc] initWithArray:arrProductId];
            [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
            
        }
        else {
            dataSet = [[NSSet alloc] initWithArray:DEFAULT_STICKER_PACKAGE_PRODUCTID];
        }
        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
        
    }
    [IAPShare sharedHelper].iap.production = APP_STORE ? YES : NO;
}

- (void)checkPackagePurchase:(NSString*)productID {
    
    if([[IAPShare sharedHelper].iap.purchasedProducts containsObject:productID]) {
        self.isPurchase = YES;
        self.viewSticker.hidden = NO;
        [self loadMSSticker];
        self.clSticker.hidden = YES;

    }
    else {
        self.isPurchase = NO;
        self.viewSticker.hidden = YES;
        self.clSticker.hidden = NO;
        [self.clSticker reloadData];
    }
}

- (void)displayContentController: (UIViewController*) content;
{
    _browserStickerVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    _browserStickerVC.view.bounds = self.view.bounds;
    [self.viewSticker addSubview:_browserStickerVC.view];
    [self addChildViewController:_browserStickerVC];
    [_browserStickerVC didMoveToParentViewController:self];
    [self.browserStickerVC.view addConstraintFullLayoutToView:self.viewSticker];
    [self.browserStickerVC.stickerBrowserView setContentInset:UIEdgeInsetsMake(0, 0, 40, 0)];
}


- (void) hideContentController: (UIViewController*) content
{
    [content willMoveToParentViewController:nil];  // 1
    [content.view removeFromSuperview];            // 2
    [content removeFromParentViewController];

}

- (void)setUpUI {
    [_clSticker registerNib:[UINib nibWithNibName:@"FooterCollectionReusableView" bundle:[NSBundle mainBundle]]  forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollecttionFooterView"];
    
    UIImage* imgPlus = [[UIImage imageNamed:@"icon_p"] imageMaskedWithColor:[UIColor whiteColor]];
    [_btnShopping setImage:imgPlus forState:UIControlStateNormal];
    self.indexSelected = 0;
    _clSticker.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _clIcon.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:8.0].active = YES;
    self.topShoppingViewContraint.constant = [UIScreen mainScreen].bounds.size.height;
    _browserStickerVC = [[StickerBrowserViewController alloc] initWithStickerSize:MSStickerSizeSmall withPackInfo:nil];
    [self displayContentController:_browserStickerVC];
    
    _noStickerView.hidden = [StickerManager getInstance].arrPackages.count == 0 ? NO : YES;
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlertView:)name:notification_show_alert object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEndEditMySticker)name:notification_mysticker_did_endEditin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePurchase)name:notification_click_purchase object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRestore)name:notification_click_restore object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification_add_package_download_complete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completedAddPackage)name:notification_add_package_download_complete object:nil];
}



- (void)completedAddPackage {
    BlockWeakSelf weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(weakSelf.isRestoring) {
            if([StickerManager getInstance].arrDownloadingPack.count == 0){
                [weakSelf showAlertViewWithText:@"Restore completed!"];
                [weakSelf reloadData];
                weakSelf.isRestoring = NO;
            }
            else {
                [weakSelf showLoadingViewWithText:[NSString stringWithFormat:@"Downloading %ld package(s)...",(unsigned long)[StickerManager getInstance].arrDownloadingPack.count]];
            }
        }
        if ([StickerManager getInstance].arrPackages.count > 0) {
            weakSelf.noStickerView.hidden = YES;
            weakSelf.indexSelected = 0;
            [weakSelf.clIcon reloadData];
        }
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)getNumberStickers {
    if([StickerManager getInstance].arrPackages.count == 0){
        return 0;
    }
    else {
        StickerPack* stickerPackage = [[StickerManager getInstance].arrPackages objectAtIndex:_indexSelected];
        return stickerPackage.arrStickerPath.count;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if(collectionView == _clIcon ||  [StickerManager getInstance].arrPackages.count == 0) return CGSizeZero;
    return CGSizeMake(_clSticker.frame.size.width, 75);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)theIndexPath
{
    if(collectionView == _clSticker ) {
        
        if(kind == UICollectionElementKindSectionFooter)
        {
            FooterCollectionReusableView* footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollecttionFooterView" forIndexPath:theIndexPath];
            return  footerView;
        }
    }
    return nil;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == _clSticker) {
        return self.isPurchase ? 0 : [self getNumberStickers];
    }
    else {
        return [StickerManager getInstance].arrPackages.count;
    }
    return 0;
}

- (CGSize)getSizeOfSticker {
    CGFloat size = (_clSticker.frame.size.width)/[self numberStickerOfRow];
    return CGSizeMake(size, size);
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
    return 3;
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
    cell.selectedBackgroundView = nil;
    iconImgView.backgroundColor = [UIColor clearColor];
    if(indexPath.row == _indexSelected) {
        iconImgView.backgroundColor = self.topLine.backgroundColor;
        iconImgView.alpha = 0.8;
    }
    return cell;
}

- (UICollectionViewCell*)loadStickerCell:(NSIndexPath*)indexPath {
    UICollectionViewCell* cell = [_clSticker dequeueReusableCellWithReuseIdentifier:@"StickerCell" forIndexPath:indexPath];
    FLAnimatedImageView* iconImgView;
    StickerPack* stickerPackage;
    iconImgView = [cell viewWithTag:1];
    UIImageView* lockIconImgView = [cell viewWithTag:2];
    lockIconImgView.hidden = YES;
    if(indexPath.row > [self numOfStickerFree] && !self.isPurchase) {
        lockIconImgView.hidden = NO;
    }
    stickerPackage = [[StickerManager getInstance].arrPackages objectAtIndex:_indexSelected];
    NSString* stickerPath = [stickerPackage.arrStickerPath objectAtIndex:indexPath.row];
    NSURL* stickerUrl = [[FileManager stickerFileURL] URLByAppendingPathComponent:stickerPath];
    [iconImgView sd_setImageWithURL:stickerUrl];
    return cell;
}

- (NSInteger)numOfStickerFree {
    StickerPack*stickerPackage = [[StickerManager getInstance].arrPackages objectAtIndex:_indexSelected];
    if(stickerPackage.isAnimated) {
        return NUM_STICKER_FREE_GIF - 1;
    }
    return NUM_STICKER_FREE_NOT_GIF - 1;
}

-(void)viewDidLayoutSubviews {
    if(self.presentationStyle == MSMessagesAppPresentationStyleCompact && _shoppingView.alpha == 0.0){
        [self.view bringSubviewToFront:_clIcon];
        [self.view bringSubviewToFront:_overlayView];
    }
}

- (void)loadMSSticker {
    if(!self.isPurchase) return;
    [self.browserStickerVC loadStickerPackAtIndex:_indexSelected];
    [self.browserStickerVC.stickerBrowserView reloadData];
    [self.browserStickerVC.stickerBrowserView setContentOffset:CGPointZero animated:NO];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(collectionView == _clIcon) {
        if(_indexSelected == indexPath.row) return;
        self.indexSelected = indexPath.row;
        [_clIcon reloadData];
        [self loadMSSticker];
        [self scrollCollectionToTop:_clSticker];
        [_clSticker reloadData];
    }
    else {
        if (indexPath.row > [self numOfStickerFree] && !self.isPurchase) {
            [self handlePurchase];
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
         [self requestPresentationStyle:MSMessagesAppPresentationStyleCompact];
        [self performSelector:@selector(rotatePlusImg) withObject:nil afterDelay:delay_animate];
    }
}

- (void)showShoppingView:(BOOL)show {
    if(show){
        [self requestPresentationStyle:MSMessagesAppPresentationStyleExpanded];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rotatePlusImg) object:nil];
        if(self.presentationStyle == MSMessagesAppPresentationStyleExpanded){
            [self animateShowShopingView:YES];
        }
    }
    else {
        _noStickerView.hidden = [StickerManager getInstance].arrPackages.count == 0 ? NO : YES;
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
    if (presentationStyle == MSMessagesAppPresentationStyleExpanded && _shoppingView.alpha == 1.0 ) {
        [self animateShowShopingView:YES];
    }
    else {
        [self animateShowShopingView:NO];
    }
}

- (void)animateShowShopingView:(BOOL)show {
    if(show) {
        self.topShoppingViewContraint.constant = 0;
        [self.view bringSubviewToFront:self.shoppingView];
    }
    else {
        self.topShoppingViewContraint.constant = [UIScreen mainScreen].bounds.size.height;
    }
    
    BlockWeakSelf weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.view updateConstraintsIfNeeded];
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setIndexSelected:(NSInteger)indexSelected {
    _indexSelected = indexSelected;
    if([StickerManager getInstance].arrPackages.count == 0) return;
    StickerPack* stickerPackage = [[StickerManager getInstance].arrPackages objectAtIndex:_indexSelected];
    if([[IAPShare sharedHelper].iap.purchasedProducts containsObject:stickerPackage.productID]
       || [stickerPackage.price isEqualToString:@"FREE"]){
        self.isPurchase = YES;
    }
    else {
        self.isPurchase = NO;
    }
}


- (void)setIsPurchase:(BOOL)isPurchase {
    BlockWeakSelf weakself = self;
    _isPurchase = isPurchase;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(isPurchase) {
            weakself.viewSticker.hidden = NO;
            [weakself loadMSSticker];
            weakself.clSticker.hidden = YES;
            [weakself.clSticker reloadData];
        }
        else {
            weakself.viewSticker.hidden = YES;
            weakself.clSticker.hidden = NO;
            [weakself.clSticker reloadData];
        }
    });
    
}

-(IBAction)handlePurchase {
    [self showLoadingViewWithText:@"Purchasing..."];
    BlockWeakSelf weakSelf = self;
    StickerPack* stickerPackage = [[StickerManager getInstance].arrPackages objectAtIndex:_indexSelected];
    if([IAPShare sharedHelper].iap.products.count == 0) {
        [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
         {
             if(response > 0 ) {
                 SKProduct* product;
                 for(product in [IAPShare sharedHelper].iap.products) {
                     if([product.productIdentifier isEqualToString:stickerPackage.productID]) {
                         break;
                     }
                 }
                 [weakSelf buyProduct:product];
             }
         }];
    }
    else {
        SKProduct* product;
        for(product in [IAPShare sharedHelper].iap.products) {
            if([product.productIdentifier isEqualToString:stickerPackage.productID]) {
                break;
            }
        }
        [self buyProduct:product];
    }
    
}

- (void)buyProduct:(SKProduct*)product {
    NSLog(@"Price: %@",[[IAPShare sharedHelper].iap getLocalePrice:product]);
    NSLog(@"Title: %@",product.localizedTitle);
    BlockWeakSelf weakSelf = self;
    [[IAPShare sharedHelper].iap buyProduct:product
                               onCompletion:^(SKPaymentTransaction* trans){
       if(trans.error)
       {
           [weakSelf showAlertViewWithText:[trans.error localizedDescription]];
           
       }
       else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
           
           [[IAPShare sharedHelper].iap checkReceipt:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] AndSharedSecret:KEYSERECT onCompletion:^(NSString *response, NSError *error) {
               
               //Convert JSON String to NSDictionary
               NSDictionary* rec = [IAPShare toJSON:response];
               
               if([rec[@"status"] integerValue]==0)
               {
                   
                   [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
                   NSLog(@"SUCCESS %@",response);
                   NSLog(@"Pruchases %@",[IAPShare sharedHelper].iap.purchasedProducts);
                   [weakSelf.overlayView showThankView];
                   self.indexSelected = _indexSelected;
               }
               else {
                   [weakSelf showAlertViewWithText:@"Purchase Fail. Please try again!"];
               }
           }];
       }
       else if(trans.transactionState == SKPaymentTransactionStateFailed) {
           NSLog(@"Fail");
       }
    }];//end of buy product
}


- (IBAction)handleRestore {
    _isRestoring = YES;
    [self showLoadingViewWithText:@"Restoring..."];
    BlockWeakSelf weakSelf = self;
    [[IAPShare sharedHelper].iap restoreProductsWithCompletion:^(SKPaymentQueue *queue, NSError *error) {
        if(!error) {
            [weakSelf checkDownloadRestoreProductIfNeeded:queue];
        }
        else {
            [weakSelf showAlertViewWithText:error.localizedDescription];
            _isRestoring = NO;
        }
    }];
}

- (void)checkDownloadRestoreProductIfNeeded:(SKPaymentQueue *)queue {
    BOOL isDownloading = NO;
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStateRestored:
            {
                BOOL isDownloaded = NO;
                for(StickerPack* pack in [StickerManager getInstance].arrPackages) {
                    if([transaction.payment.productIdentifier isEqualToString:pack.productID]) {
                        isDownloaded = YES;
                        break;
                    }
                }
                if(isDownloaded) break;
                for(NSDictionary* dict in _shoppingView.arrItemShow) {
                    NSString* proId = [dict objectForKey:@"product_id"];
                    if([proId isEqualToString:transaction.payment.productIdentifier]) {
                        NSString *stringURL = [dict objectForKey:@"url"];
                        [Util downloadPackage:stringURL andDict:dict];
                        isDownloading = YES;
                        break;
                    }
                }
            }
            default:
                break;
        }
    }
    if(!isDownloading) {
        _isRestoring = NO;
        [self showAlertViewWithText:@"Restore completed!"];
        [self reloadData];
    }
    else {
        [self showLoadingViewWithText:[NSString stringWithFormat:@"Downloading %ld package(s)...",(unsigned long)[StickerManager getInstance].arrDownloadingPack.count]];
    }
}

- (void)reloadData {
    self.indexSelected = _indexSelected;
}

- (void)clearALL {
    [userDefaults removeObjectForKey:StickerPackageArr_key];
    [userDefaults removeObjectForKey:numberOfPackage_key];
    [userDefaults synchronize];
}

- (void)handleEndEditMySticker {
//    BlockWeakSelf weakself = self;
//     dispatch_async(dispatch_get_main_queue(), ^{
         self.indexSelected = 0;
         [self.clIcon reloadData];
         [self loadMSSticker];
         [self scrollCollectionToTop:_clSticker];
         [self.clSticker reloadData];
//     });
}

- (void)showAlertView:(NSNotification*)notification {
    NSString* message = [notification.userInfo objectForKey:@"message"];
    [self showAlertViewWithText:message];
}

- (void)showLoadingViewWithText:(NSString*)text {
    [self.view bringSubviewToFront:self.overlayView];
    [self.overlayView showLoadingViewWithText:text];
}

- (void)showAlertViewWithText:(NSString*)text {
    BlockWeakSelf weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.view bringSubviewToFront:self.overlayView];
        [weakself.overlayView showAlertWithTitle:@"" andMessage:text];
    });
   
}

@end
