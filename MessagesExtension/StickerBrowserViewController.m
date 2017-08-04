//
//  StickerBrowserViewController.m
//  PET Sticker Collection
//
//  Created by vietthaibinh on 8/1/17.
//  Copyright © 2017 Pham. All rights reserved.
//

#import "StickerBrowserViewController.h"

@interface StickerBrowserViewController ()
@property (nonatomic) NSMutableArray<MSSticker *> *stickers;

@end

@implementation StickerBrowserViewController

- (instancetype)initWithStickerSize:(MSStickerSize)stickerSize withPackInfo:(NSDictionary *)packInfo {
    self = [super initWithStickerSize:stickerSize];
    if (!self)
        return nil;
    _stickers = [NSMutableArray new];
    return self;
}

- (void)loadStickerPackAtIndex:(NSInteger)index {
    StickerPack* stickerPackage = [[StickerManager getInstance].arrPackages objectAtIndex:index];
    [_stickers removeAllObjects];
    for(NSString* path in stickerPackage.arrStickerPath) {
        @autoreleasepool {
            MSSticker *sticker;
            NSError *error;
            NSURL* stickerUrl = [[FileManager stickerFileURL] URLByAppendingPathComponent:path];
            sticker = [[MSSticker alloc] initWithContentsOfFileURL:stickerUrl localizedDescription:path error:&error];
            if (error)
                NSLog(@"Error init sticker %@", error.localizedDescription);
            else
                [_stickers addObject:sticker];
        }
    }
    [self.stickerBrowserView reloadData];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.stickerBrowserView.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfStickersInStickerBrowserView:(MSStickerBrowserView *)stickerBrowserView {
    return _stickers.count;
}

- (MSSticker *)stickerBrowserView:(MSStickerBrowserView *)stickerBrowserView stickerAtIndex:(NSInteger)index {
    return [_stickers objectAtIndex:index];
}

@end
