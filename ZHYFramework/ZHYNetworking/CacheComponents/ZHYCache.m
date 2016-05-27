//
//  ZHYCache.m
//  ZHYNetworking
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "ZHYCache.h"
#import "ZHYNetworkingConfiguration.h"
#import "ZHYCacheObject.h"

@interface ZHYCache()

@property (strong, nonatomic) NSCache *cache;

@end


@implementation ZHYCache

#pragma mark - life cycle

+ (instancetype)sharedInstance{
    static ZHYCache *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZHYCache alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods

- (void)saveCacheWithData:(NSData *)cachedData serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams{
    [self saveCacheWithData:cachedData key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (NSData *)fetchCachedDataWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams{
    return [self fetchCachedDataWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams{
    [self deleteCacheWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

#pragma mark - private methods

- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key{
    ZHYCacheObject *cachedObject = [self.cache objectForKey:key];
    if (!cachedObject) {
        cachedObject = [[ZHYCacheObject alloc] init];
    }
    [cachedObject updateContent:cachedData];
    [self.cache setObject:cachedObject forKey:key];
}

- (NSData *)fetchCachedDataWithKey:(NSString *)key{
    ZHYCacheObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject.isOutDate || cachedObject.isEmpty) {
        return nil;
    } else {
        return cachedObject.content;
    }
}

- (void)deleteCacheWithKey:(NSString *)key{
    [self.cache removeObjectForKey:key];
}

- (void)clean{
    [self.cache removeAllObjects];
}

- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier
                            methodName:(NSString *)methodName
                         requestParams:(NSDictionary *)requestParams{
    return @"";
}


#pragma mark - get & set

- (NSCache *)cache{
    if (!_cache) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = kZHYCacheCountLimit;
    }
    return _cache;
}

@end
