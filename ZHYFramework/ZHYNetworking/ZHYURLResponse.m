//
//  ZHYURLResponse.m
//  ZHYNetworking
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "ZHYURLResponse.h"

@interface ZHYURLResponse ()

@property (nonatomic, assign, readwrite) ZHYURLResponseStatus status;
@property (nonatomic, copy, readwrite) id content;
@property (nonatomic, copy, readwrite) NSData *responseData;
@property (nonatomic, assign, readwrite) NSInteger requestId;

@end

@implementation ZHYURLResponse

- (instancetype)initWithRequestId:(NSNumber *)requestId responseData:(NSData *)responseData error:(NSError *)error{
    self = [super init];
    if (self) {
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:NSJSONReadingMutableContainers
                                                             error:NULL];
        }else{
            self.content = nil;
        }
        self.status = [self responseStatusWithError:error];
        self.requestId = [requestId integerValue];
        self.responseData = responseData;
    }
    return self;
}

#pragma mark - private methods
- (ZHYURLResponseStatus)responseStatusWithError:(NSError *)error{
    if (error) {
        ZHYURLResponseStatus result = ZHYURLResponseStatusErrorNoNetwork;
        // 除了超时以外，所有错误都当成是无网络
        if (error.code == NSURLErrorTimedOut) {
            result = ZHYURLResponseStatusErrorNoNetwork;
        }
        return result;
    } else {
        return ZHYURLResponseStatusSuccess;
    }
}


@end
