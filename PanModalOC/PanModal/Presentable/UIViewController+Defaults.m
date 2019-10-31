//
//  UIViewController+Defaults.m
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/31.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import "UIViewController+Defaults.h"
#import "UIViewController+PanModalPresenter.h"
#import "UIViewController+LayoutHelper.h"

@implementation UIViewController (Defaults) 

- (CGFloat)topOffset {
    return self.topLayoutOffset + 21.0f;
}

- (struct PanModalHeightStruct)shortFormHeight {
    return self.longFormHeight;
}

- (struct PanModalHeightStruct)longFormHeight {
    if (self.panScrollable == nil) {
        struct PanModalHeightStruct a = {PanModalHeightTypeMaxHeight,0};
        return a;
    }
    [self.panScrollable layoutIfNeeded];
    struct PanModalHeightStruct a = {PanModalHeightTypeContentHeight,self.panScrollable.contentSize.height};
    return a;
}

- (CGFloat)cornerRadius {
    return 8.0f;
}

- (CGFloat)springDamping {
    return 0.8;
}

- (CGFloat)transitionDuration {
    return 0.5;
}

- (UIViewAnimationOptions)transitionAnimationOptions {
    return UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState;
}

- (CGFloat)backgroundAlpha {
    return 0.7;
}

- (UIEdgeInsets)scrollIndicatorInsets {
    CGFloat top = 0;
    if ([self respondsToSelector:@selector(shouldRoundTopCorners)] && [self respondsToSelector:@selector(cornerRadius)]) {
        top = [self cornerRadius];
    }
    return UIEdgeInsetsMake(top, 0, self.bottomLayoutOffset, 0);
}

- (BOOL)anchorModalToLongForm {
    return YES;
}

- (BOOL)allowsExtendedPanScrolling {
    if (self.panScrollable == nil) {
        return NO;
    }
    [self.panScrollable layoutIfNeeded];
    return self.panScrollable.contentSize.height > (self.panScrollable.frame.size.height - self.bottomLayoutOffset);
}

- (BOOL)allowsDragToDismiss {
    return YES;
}

- (BOOL)isUserInteractionEnabled {
    return YES;
}

- (BOOL)isHapticFeedbackEnabled {
    return YES;
}

- (BOOL)shouldRoundTopCorners {
    return [self isPanModalPresented];
}

- (BOOL)showDragIndicator {
    return self.shouldRoundTopCorners;
}

- (BOOL)shouldRespondPanModalGestureRecognizer:(UIPanGestureRecognizer *)panModalGestureRecognizer {
    return YES;
}

- (void)willRespondPanModalGestureRecognizer:(UIPanGestureRecognizer *)panModalGestureRecognizer {
    
}

- (BOOL)shouldTransitionState:(PresentationState)state {
    return YES;
}

- (BOOL)shouldPrioritizePanModalGestureRecognizer:(UIPanGestureRecognizer *)panModalGestureRecognizer {
    return false;
}

- (void)willTransitionState:(PresentationState)state {
    
}

- (void)panModalWillDismiss {
    
}

- (UIScrollView *)panScrollable {
    return nil;
}

@end
