//
//  ZHYTabBarControllerConfig.m
//  ZHYFramework
//
//  Created by apple on 16/5/28.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "ZHYTabBarControllerConfig.h"

@interface ZHYTabBarControllerConfig()

@property (strong, nonatomic, readwrite) UITabBarController *tabBarController;

@end


@implementation ZHYTabBarControllerConfig


#pragma mark - get & set

- (UITabBarController *)tabBarController{
    if (!_tabBarController) {
        
    }
    return _tabBarController;
}

@end
