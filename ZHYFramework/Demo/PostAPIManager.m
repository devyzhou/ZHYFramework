//
//  PostAPIManager.m
//  ZHYFramework
//
//  Created by apple on 16/5/29.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "PostAPIManager.h"
#import "ZHYServiceTest.h"

@implementation PostAPIManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.validator = self;
        self.paramSource = self;
    }
    return self;
}

#pragma mark - ZHYAPIManager

- (NSString *)serviceType{
    return NSStringFromClass([ZHYServiceTest class]);
}

- (NSString *)methodName{
    return @"stream/0/posts/stream/global";
}

- (ZHYAPIManagerRequestType)requestType{
    return ZHYAPIManagerRequestTypeGet;
}

- (NSTimeInterval)outdateTimeSeconds{
    return 10;
}


#pragma mark - ZHYAPIManagerValidator

- (BOOL)manager:(ZHYAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data{
    return YES;
}

- (BOOL)manager:(ZHYAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data{
    return YES;
}

#pragma mark - ZHYAPIManagerParamSourceDelegate

- (NSDictionary *)paramsForApi:(ZHYAPIBaseManager *)manager{
    return @{};
}




@end
