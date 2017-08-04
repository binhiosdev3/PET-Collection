//
//  ZPReachability.h
//  Zippie
//
//  Created by Hung Tran on 3/10/16.
//  Copyright © 2016 Lunex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ZPReachability : NSObject

+ (instancetype)getInstance;

@property (nonatomic, strong) Reachability *internetReachability;

// Reachability
@property (nonatomic, assign) BOOL internetConnected;
@property (nonatomic, assign) BOOL wifiConnected;
@property (nonatomic, assign) BOOL hostConnected;

@property (nonatomic, assign, readonly) BOOL isInternetActived;

@end
