//
//  ZHYBaseViewController.m
//  ZHYFramework
//
//  Created by apple on 16/5/28.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "ZHYBaseViewController.h"

@implementation ZHYBaseViewController

#pragma mark - life cycle

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - public methods

- (void)alert:(NSString*)msg {
    UIAlertView *alertView=[[UIAlertView alloc]
                            initWithTitle:nil message:msg delegate:nil
                            cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}


@end
