//
//  UIViewController+PanModalPresenter.m
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/31.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import "UIViewController+PanModalPresenter.h"
#import "PanModalPresentationDelegateImp.h"
#import "AppDelegate.h"

@implementation UIViewController (PanModalPresenter)

- (BOOL)isPanModalPresented {
    return [self.transitioningDelegate conformsToProtocol:@protocol(PanModalPresentationDelegate)];
}

- (void)presentPanModal:(id<PanModalPresentable>)viewControllerToPresent sourceView:(UIView *)sourceView sourceRect:(CGRect)sourceRect {
    if (![viewControllerToPresent conformsToProtocol:@protocol(PanModalPresentable)]) {
        return;
    }
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [(UIViewController *)viewControllerToPresent popoverPresentationController].sourceRect = sourceRect;
        [(UIViewController *)viewControllerToPresent popoverPresentationController].sourceView = sourceView;
        [(UIViewController *)viewControllerToPresent popoverPresentationController].delegate = [PanModalPresentationDelegateImp sharedInstance];

        
    } else {
        ((UIViewController *)viewControllerToPresent).modalPresentationStyle = UIModalPresentationCustom;
        ((UIViewController *)viewControllerToPresent).transitioningDelegate = [PanModalPresentationDelegateImp sharedInstance];
        ((UIViewController *)viewControllerToPresent).modalPresentationCapturesStatusBarAppearance = true;

    }
    [self presentViewController:(UIViewController *)viewControllerToPresent animated:true completion:nil];
}

@end
