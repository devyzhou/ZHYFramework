//
//  ZHYCacheObject.m
//  ZHYNetworking
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "ZHYCacheObject.h"
#import "ZHYNetworkingConfiguration.h"

@interface ZHYCacheObject()

@property (strong, nonatomic, readwrite) NSData *content;
@property (strong, nonatomic, readwrite) NSDate *lastUpdateTime;

@end

@implementation ZHYCacheObject


#pragma mark - life cycle
- (instancetype)initWithContent:(NSData *)content{
    self = [super init];
    if (self) {
        self.content = content;
    }
    return self;
}

#pragma mark - public method
- (void)updateContent:(NSData *)content{
    self.content = content;
}

#pragma mark - getters and setters
- (BOOL)isEmpty{
    return self.content == nil;
}

- (BOOL)isOutdated{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return timeInterval > kZHYCacheOutdateTimeSeconds;
}

- (void)setContent:(NSData *)content{
    _content = content;
    self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}


@end
