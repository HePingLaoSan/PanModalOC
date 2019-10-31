//
//  SampleViewController.m
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/31.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import "SampleViewController.h"
#import "UIViewController+PanModalPresenter.h"
#import "FullScreenNavController.h"
#import "UserGroupViewController.h"

@interface SampleViewController ()

@property (nonatomic, strong) NSArray *array;

@end

@implementation SampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PanModal";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableView.tableFooterView = UIView.new;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    self.array = @[@"Full Screen",@"User Group"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        FullScreenNavController *nav = [[FullScreenNavController alloc] init];
        [self presentPanModal:nav sourceView:nil sourceRect:CGRectZero];
    } else {
        UserGroupViewController *userGroup = [[UserGroupViewController alloc] init];
        [self presentPanModal:userGroup sourceView:nil sourceRect:CGRectZero];
    }
}


@end
