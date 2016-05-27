//
//  ZHYServiceFactory.m
//  ZHYNetworking
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "ZHYServiceFactory.h"
#import <objc/runtime.h>

@implementation ZHYServiceFactory

#pragma mark - life cycle
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static ZHYServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZHYServiceFactory alloc] init];
    });
    return sharedInstance;
}

- (ZHYService <ZHYServiceProtocal> *)serviceWithIdentifier:(NSString *)identifier{
    return [[NSClassFromString(identifier) alloc] init];
}

@end
