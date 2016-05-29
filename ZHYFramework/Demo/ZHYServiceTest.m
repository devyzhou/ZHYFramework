//
//  ZHYServiceTest.m
//  ZHYFramework
//
//  Created by apple on 16/5/29.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "ZHYServiceTest.h"

@implementation ZHYServiceTest

#pragma mark - ZHYServiceProtocal
- (BOOL)isOnline{
    return YES;
}

- (NSString *)onlineApiBaseUrl{
    return @"https://api.app.net/";
}

- (NSString *)onlineApiVersion{
    return @"";
}

- (NSString *)onlinePrivateKey{
    return @"";
}

- (NSString *)onlinePublicKey{
    return @"";
}

- (NSString *)offlineApiBaseUrl{
    return self.onlineApiBaseUrl;
}

- (NSString *)offlineApiVersion{
    return self.onlineApiVersion;
}

- (NSString *)offlinePrivateKey{
    return self.onlinePrivateKey;
}

- (NSString *)offlinePublicKey{
    return self.onlinePublicKey;
}
@end
