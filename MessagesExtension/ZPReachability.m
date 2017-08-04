//
//  ZPReachability.m
//  Zippie
//
//  Created by Hung Tran on 3/10/16.
//  Copyright © 2016 Lunex. All rights reserved.
//

#import "ZPReachability.h"
#import "Reachability.h"

@interface ZPReachability ()

@property (nonatomic, strong) Reachability *hostReachability;
@property (nonatomic, strong) Reachability *wifiReachability;

@end

@implementation ZPReachability

+ (instancetype)getInstance {
    static ZPReachability *instance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[ZPReachability alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        /*
         Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
         */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        self.internetReachability = [Reachability reachabilityForInternetConnection];
        [self.internetReachability startNotifier];
        [self updateInterfaceWithReachability:self.internetReachability];
        
        NSString *remoteHostName = @"www.google.com";
        self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
        [self.hostReachability startNotifier];
        [self updateInterfaceWithReachability:self.hostReachability];
        
        self.wifiReachability = [Reachability reachabilityForInternetConnection];
        [self.wifiReachability startNotifier];
        [self updateInterfaceWithReachability:self.wifiReachability];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Reachability

- (void)reachabilityChanged:(id)notification {
    id object = [notification object];
    if ([object isKindOfClass:[Reachability class]]) {
        Reachability* curReach = (Reachability *)object;
        [self updateInterfaceWithReachability:curReach];
    }
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability {
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable: {
            if (reachability == self.internetReachability) {
                self.internetConnected = NO;
            }
            if (reachability == self.wifiReachability) {
                self.wifiConnected = NO;
            }
            if (reachability == self.hostReachability) {
                self.hostConnected = NO;
            }
        }
            break;
        default:{
            if (reachability == self.internetReachability) {
                self.internetConnected = YES;
            }
            if (reachability == self.wifiReachability) {
                self.wifiConnected = YES;
            }
            if (reachability == self.hostReachability) {
                self.hostConnected = YES;
            }
        }
            break;
    }
}

- (BOOL)isInternetActived {
    return (self.internetConnected || self.hostConnected || self.wifiConnected);
}

@end
