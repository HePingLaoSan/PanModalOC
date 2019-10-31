//
//  FullScreenNavController.m
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/31.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import "FullScreenNavController.h"

@interface FullScreenViewController : UIViewController
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation FullScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textLabel = [UILabel new];
    self.textLabel.text = @"Drag downwards to dismiss";
    self.textLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.title = @"Full Screen";
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupConstraints];
}

- (void)setupConstraints {
    [self.view addSubview:self.textLabel];
    [self.textLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [self.textLabel.centerYAnchor constraintEqualToAnchor: self.view.centerYAnchor].active = true;
}

@end


@interface FullScreenNavController ()

@end

@implementation FullScreenNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pushViewController:FullScreenViewController.new animated:false];
}

- (UIScrollView *)panScrollable {
    return nil;
}

- (CGFloat)topOffset {
    return 0;
}

- (CGFloat)springDamping {
    return 1.0f;
}

- (CGFloat)transitionDuration {
    return 0.4;
}

- (UIViewAnimationOptions)transitionAnimationOptions {
    return UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState;
}

- (BOOL)shouldRoundTopCorners {
    return false;
}

- (BOOL)showDragIndicator {
    return false;
}

@end
