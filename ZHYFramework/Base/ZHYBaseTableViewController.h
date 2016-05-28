//
//  ZHYBaseTableViewController.h
//  ZHYFramework
//
//  Created by apple on 16/5/28.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "ZHYBaseViewController.h"

@interface ZHYBaseTableViewController : ZHYBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (assign, nonatomic) UITableViewStyle tableViewStyle;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section __attribute__((objc_requires_super));

@end
