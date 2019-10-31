//
//  PanModalPresentationDelegateImp.m
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/31.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import "PanModalPresentationDelegateImp.h"
#import "PanModalPresentationController.h"

@interface PanModalPresentationDelegateImp ()

@end

@implementation PanModalPresentationDelegateImp

static PanModalPresentationDelegateImp *imp = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (imp == nil) {
            imp = [PanModalPresentationDelegateImp new];
        }
    });
    return imp;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[PanModalPresentationAnimator alloc] initWithTransitionStyle:PanModalTransitionStylePresentation];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[PanModalPresentationAnimator alloc] initWithTransitionStyle:PanModalTransitionStyleDismissal];
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    PanModalPresentationController *controller = [[PanModalPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    controller.delegate = self;
    return controller;
}

#pragma mark - UIAdaptivePresentationControllerDelegate & UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForController:(nonnull UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationNone;
}

@end
