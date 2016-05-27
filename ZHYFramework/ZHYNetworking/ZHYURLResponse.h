//
//  ZHYURLResponse.h
//  ZHYNetworking
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHYNetworkingConfiguration.h"

@interface ZHYURLResponse : NSObject

@property (nonatomic, assign, readonly) ZHYURLResponseStatus status;
@property (nonatomic, copy, readonly) id content;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, assign, readonly) NSInteger requestId;

- (instancetype)initWithRequestId:(NSNumber *)requestId responseData:(NSData *)responseData error:(NSError *)error;


@end
