//
//  BaseViewController.m
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/31.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import "BaseViewController.h"
#import "PanModalPresentable.h"

@interface BaseViewController ()<PanModalPresentable>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:26.0f/255.0f green:29.0f/255.0f blue:33.0f/255.0f alpha:1.0f];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (UIScrollView *)panScrollable {
    return nil;
}

- (struct PanModalHeightStruct)longFormHeight {
    struct PanModalHeightStruct ret = {PanModalHeightTypeMaxHeightWithTopInset, 200};
    return ret;
}

- (BOOL)anchorModalToLongForm {
    return false;
}
@end
