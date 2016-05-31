//
// Created by apple on 16/5/31.
// Copyright (c) 2016 ZhouYuan. All rights reserved.
//

#import <Aspects/Aspects.h>
#import "UIViewController+Intercepter.h"

@implementation UIViewController (Intercepter)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo){
            [self loadView:aspectInfo.instance];
        } error:NULL];

        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){
            NSLog(@"[viewWillAppear:%@]", animated? @"YES" : @"NO");
        } error:NULL];
    });
}

#pragma mark - fake methods
+ (void)loadView:(UIViewController *)viewController {
    /* 你可以使用这个方法进行打日志，初始化基础业务相关的内容 */
    NSLog(@"[%@ loadView]", [viewController class]);
}


@end