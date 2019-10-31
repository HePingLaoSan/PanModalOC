//
//  PanModalPresentationAnimator.m
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/30.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import "PanModalPresentationAnimator.h"
#import "PanModalPresentable.h"
#import "UIView+panContainerView.h"
#import "PanModalAnimator.h"
#import "UIViewController+LayoutHelper.h"

@interface PanModalPresentationAnimator ()

@end

@implementation PanModalPresentationAnimator


- (instancetype)initWithTransitionStyle:(PanModalTransitionStyle)transitionStyle {
    self = [super init];
    if (self) {
        self.transitionStyle = transitionStyle;
        
        if (transitionStyle == PanModalTransitionStylePresentation) {
            self.feedbackGenerator = [[UISelectionFeedbackGenerator alloc] init];
            [self.feedbackGenerator prepare];
        }
    }
    return self;
}

- (void)animatePresentationWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
       UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!fromVC || !toVC) {
        return;
    }

    id<PanModalPresentable>presentable = [self panModalLayoutType:transitionContext];

    // Calls viewWillAppear and viewWillDisappear
    [fromVC beginAppearanceTransition:false animated:true];

    CGFloat yPos = [(UIViewController *)presentable shortFormYPos];
    
    UIView *panView = transitionContext.containerView.panContainerView;
    if (panView == nil) {
        panView = toVC.view;
    }
    
    panView.frame = [transitionContext finalFrameForViewController:toVC];
    CGRect newFrame = panView.frame;
    newFrame.origin.y = transitionContext.containerView.frame.size.height;
    panView.frame = newFrame;
    
    if ([presentable isHapticFeedbackEnabled]) {
        [self.feedbackGenerator selectionChanged];
    }
    
    [PanModalAnimator animate:^{
        panView.frame = CGRectMake(panView.frame.origin.x, yPos, panView.frame.size.width, panView.frame.size.height);
    } config:presentable completion:^(BOOL completion) {
        // Calls viewDidAppear and viewDidDisappear
        [fromVC endAppearanceTransition];
        [transitionContext completeTransition:completion];
    }];
}

- (void)animateDismissalTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!fromVC || !toVC) {
        return;
    }
    // Calls viewWillAppear and viewWillDisappear
    [toVC beginAppearanceTransition:true animated:true];
    
    id<PanModalPresentable> presentable = [self panModalLayoutType:transitionContext];
    UIView *panView = transitionContext.containerView.panContainerView;
    if (panView == nil) {
        panView = fromVC.view;
    }
    [PanModalAnimator animate:^{
        panView.frame = CGRectMake(panView.frame.origin.x, transitionContext.containerView.frame.size.height, panView.frame.size.width, panView.frame.size.height);
    } config:presentable completion:^(BOOL completion) {
        [fromVC.view removeFromSuperview];
        // Calls viewDidAppear and viewDidDisappear
        [toVC endAppearanceTransition];
        [transitionContext completeTransition:completion];
    }];
}


- (id<PanModalPresentable>)panModalLayoutType:(id<UIViewControllerContextTransitioning>)context{
    switch (_transitionStyle) {
        case PanModalTransitionStylePresentation:
        {
            UIViewController *vc = [context viewControllerForKey:UITransitionContextToViewControllerKey];
            return [vc conformsToProtocol:@protocol(PanModalPresentable)]?vc:nil;
        }
            break;
        case PanModalTransitionStyleDismissal:
        {
            UIViewController *vc = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
            return [vc conformsToProtocol:@protocol(PanModalPresentable)]?vc:nil;
        }
            break;
        
        default:
            break;
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    id<PanModalPresentable> presentable = [self panModalLayoutType:transitionContext];
    if (presentable == nil || transitionContext ==nil) {
        return 0.5;
    }
    return presentable.transitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.transitionStyle) {
        case PanModalTransitionStylePresentation:
            [self animatePresentationWithTransitionContext:transitionContext];
        break;
        case PanModalTransitionStyleDismissal:
            [self animateDismissalTransitionContext:transitionContext];
        break;
        
        default:
            break;
    }
}

@end
