//
//  PanModalAnimator.m
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/30.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import "PanModalAnimator.h"
#import "PanModalPresentable.h"

@implementation PanModalAnimator

+ (void)animate:(AnimationBlockType)animations
    config:(id<PanModalPresentable>)config
     completion:(AnimationCompletionType)completion {
    CGFloat transitionDuration = [config transitionDuration];
    CGFloat springDamping = [config springDamping];
    UIViewAnimationOptions options = [config transitionAnimationOptions];
    [UIView animateWithDuration:transitionDuration delay:0 usingSpringWithDamping:springDamping initialSpringVelocity:0 options:options animations:animations completion:completion];
    
}

@end
