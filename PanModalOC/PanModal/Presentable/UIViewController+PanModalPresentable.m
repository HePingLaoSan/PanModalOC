//
//  UIViewController+PanModalPresentable.m
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/30.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import "UIViewController+PanModalPresentable.h"
#import "PanModalAnimator.h"

@implementation UIViewController (PanModalPresentable)

- (PanModalPresentationController *)presentedVC {
    if ([self.presentationController isKindOfClass:[PanModalPresentationController class]]) {
        PanModalPresentationController *presentedVC = (PanModalPresentationController *)self.presentationController;
        return presentedVC;
    }
    return nil;
}


- (void)panModalTransitionState:(PresentationState)state {
    [self.presentedVC transitionState:state];
}

- (void)panModalSetContentOffset:(CGPoint)point {
    [self.presentedVC setContentOffset:point];
}

- (void)panModalSetNeedsLayoutUpdate {
    [self.presentedVC setNeedsLayoutUpdate];
}

- (void)panModalAnimate:(AnimationBlockType)animationBlock completion:(AnimationCompletionType)completion {
    [PanModalAnimator animate:animationBlock config:(id<PanModalPresentable>)self completion:completion];
}
@end
