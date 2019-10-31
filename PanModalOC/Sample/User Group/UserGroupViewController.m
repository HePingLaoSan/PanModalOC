//
//  UserGroupViewController.m
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/31.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import "UserGroupViewController.h"
#import "SampleViewController.h"
#import "FullScreenNavController.h"
#import "UIViewController+PanModalPresenter.h"
#import "UIViewController+PanModalPresentable.h"

@interface UserGroupViewController ()<PanModalPresentable>
{
    BOOL isShortFormEnabled;
}
@property (nonatomic, strong) NSArray *array;

@end

@implementation UserGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isShortFormEnabled = YES;
    
    self.title = @"PanModal";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableView.tableFooterView = UIView.new;
    self.tableView.tableHeaderView = UIView.new;
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 100);
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    self.array = @[@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group",@"Full Screen",@"User Group"];
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
        SampleViewController *samp = [[SampleViewController alloc] init];
        [self presentPanModal:samp sourceView:nil sourceRect:CGRectZero];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"sdasdf";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}

- (UIScrollView *)panScrollable {
    return self.tableView;
}

- (struct PanModalHeightStruct)shortFormHeight {
    if (isShortFormEnabled) {
        struct PanModalHeightStruct stuct = {PanModalHeightTypeContentHeight, 300};
        return stuct;
    }
    return [self longFormHeight];
}

- (BOOL)shouldPrioritizePanModalGestureRecognizer:(UIPanGestureRecognizer *)panModalGestureRecognizer {
    
    CGPoint location = [panModalGestureRecognizer locationInView:self.view];
    return CGRectContainsPoint(self.tableView.tableHeaderView.frame, location);
}

- (BOOL)anchorModalToLongForm {
    return true;
}

- (void)willTransitionState:(PresentationState)state {
    if (isShortFormEnabled && state == PresentationStateLongForm) {
        isShortFormEnabled = NO;
        [self panModalSetNeedsLayoutUpdate];
    }
}

- (BOOL)showDragIndicator {
    return YES;
}

- (BOOL)shouldRoundTopCorners {
    return YES;
}
@end
