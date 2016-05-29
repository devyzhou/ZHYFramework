
//
//  ZHYAPIBaseManager.m
//  ZHYNetworking
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "ZHYAPIBaseManager.h"
#import "ZHYNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "ZHYAPIProxy.h"
#import "MBProgressHUD.h"
#import "AppMacro.h"
#import "ZHYCache.h"
#import "AFHTTPSessionManager.h"
#import "ZHYURLResponse.h"
#import "ZHYLogger.h"
#import "ZHYServiceFactory.h"

#define ZHYCallAPI(REQUEST_METHOD,REQUEST_ID) \
{                                              \
    REQUEST_ID = [[ZHYAPIProxy sharedInstance] call##REQUEST_METHOD##WithParams:params serviceIdentifier:self.child.serviceType methodName:self.child.methodName completionHandler:^(ZHYURLResponse *response, NSError *error) {\
    [self removeRequestIdWithRequestID:response.requestId]; \
    if (!error) { \
        [self successedOnCallingAPI:response CompleteHandle:completeHandle];\
    }else{ \
        [self failedOnCallingAPI:ZHYAPIManagerErrorTypeNoNetWork CompleteHandle:completeHandle];\
    }\
    }];\
    [self.requestIdList addObject:@(REQUEST_ID)];\
}

@interface ZHYAPIBaseManager ()

@property (nonatomic, strong) NSMutableArray *requestIdList;
@property (nonatomic, readwrite) ZHYAPIManagerErrorType errorType;
@property (strong, nonatomic) ZHYCache *cache;

@end

@implementation ZHYAPIBaseManager

#pragma mark - life cycle

- (instancetype)init{
    self = [super init];
    if (self) {
        _paramSource = nil;
        _validator = nil;
        if ([self conformsToProtocol:@protocol(ZHYAPIManager)]) {
            self.child = (id <ZHYAPIManager>)self;
        }
    }
    return self;
}

- (void)dealloc{
    [self cancelAllRequests];
    self.requestIdList = nil;
}


#pragma mark - public methods

- (void)cancelAllRequests{
    [[ZHYAPIProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID{
    [self removeRequestIdWithRequestID:requestID];
    [[ZHYAPIProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (NSInteger)loadDataCompleteHandle:(void (^)(ZHYAPIBaseManager *,id ,ZHYAPIManagerErrorType ))completeHandle{
    return [self loadDataWithParams:[self.paramSource paramsForApi:self] CompleteHandle:completeHandle];
}

#pragma mark - private methods

- (void)removeRequestIdWithRequestID:(NSInteger)requestId{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

- (BOOL)hasCacheWithParams:(NSDictionary *)params CompleteHandle:(void (^)(ZHYAPIBaseManager *,id ,ZHYAPIManagerErrorType ))completeHandle{
    NSString *serviceIdentifier = self.child.serviceType;
    NSString *methodName = self.child.methodName;
    NSData *result = [self.cache fetchCachedDataWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params];
    
    if (result == nil) {
        return NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        ZHYURLResponse *response = [[ZHYURLResponse alloc] initWithData:result];
        response.requestParams = params;
        [ZHYLogger logDebugInfoWithCachedResponse:response methodName:methodName serviceIdentifier:[[ZHYServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier]];
        [self successedOnCallingAPI:response CompleteHandle:completeHandle];
    });
    return YES;
}

#pragma mark - calling api

- (NSInteger)loadDataWithParams:(NSDictionary *)params
                 CompleteHandle:(void (^)(ZHYAPIBaseManager *, id, ZHYAPIManagerErrorType))completeHandle{
    NSInteger requestId = 0;
    if ([self.validator manager:self isCorrectWithParamsData:params]) {
        
        // 先检查一下是否有缓存
        if (([self outdateTimeSeconds] > 0) && [self hasCacheWithParams:params CompleteHandle:completeHandle]) {
            return 0;
        }

        if ([self isReachable]) {
            switch ([self.child requestType]) {
                case ZHYAPIManagerRequestTypeGet:{
                    ZHYCallAPI(GET,requestId);
                    break;
                }
                case ZHYAPIManagerRequestTypePost:{
                    ZHYCallAPI(POST,requestId);
                    break;
                }
                default:{
                    break;
                }
            }
        }else{
            [self failedOnCallingAPI:ZHYAPIManagerErrorTypeNoNetWork CompleteHandle:completeHandle];
        }
    }else{
        [self failedOnCallingAPI:ZHYAPIManagerErrorTypeParamsError CompleteHandle:completeHandle];
    }
    return requestId;
}

- (void)successedOnCallingAPI:(ZHYURLResponse *)response CompleteHandle:(void (^)(ZHYAPIBaseManager *, id, ZHYAPIManagerErrorType))completeHandle{
    if ([self.validator manager:self isCorrectWithCallBackData:response.content]) {
        if (([self outdateTimeSeconds] > 0) && !response.isCache) {
            [self.cache saveCacheWithData:response.responseData serviceIdentifier:self.child.serviceType methodName:self.child.methodName requestParams:response.requestParams outdateTimeSeconds:[self outdateTimeSeconds]];
        }
        if (completeHandle){
            completeHandle(self, response.content, ZHYAPIManagerErrorTypeSuccess);
        }
    }else{
        [self failedOnCallingAPI:ZHYAPIManagerErrorTypeNoContent CompleteHandle:completeHandle];
    }
}

- (void)failedOnCallingAPI:(ZHYAPIManagerErrorType)errorType CompleteHandle:(void (^)(ZHYAPIBaseManager *, id, ZHYAPIManagerErrorType))completeHandle{
    if (completeHandle){
        completeHandle(self,nil,errorType);
    }
}

#pragma mark - child method

- (NSTimeInterval)outdateTimeSeconds{
    return 0;
}

#pragma mark - get & set

- (ZHYCache *)cache{
    if (!_cache) {
        _cache = [ZHYCache sharedInstance];
    }
    return _cache;
}

- (BOOL)isReachable{
    BOOL isReachability;
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        isReachability = YES;
    } else {
        isReachability = [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
    if (!isReachability) {
        self.errorType = ZHYAPIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

- (NSMutableArray *)requestIdList{
    if (!_requestIdList) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isLoading{
    return [self.requestIdList count] > 0;
}


@end




@implementation ZHYAPIBaseManager (HUDProgress)

-(void)showNetworkIndicator{
    UIApplication *app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=YES;
}

-(void)hideNetworkIndicator{
    UIApplication *app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=NO;
}

-(void)showProgress {
    [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
}

-(void)hideProgress {
    [MBProgressHUD hideHUDForView:kKeyWindow animated:YES];
}

- (void)toast:(NSString *)text {
    [self toast:text duration:2];
}

- (void)toast:(NSString *)text duration:(NSTimeInterval)duration {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    hud.detailsLabelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:duration];
}

-(void)showHUDText:(NSString*)text{
    [self toast:text];
}


@end
