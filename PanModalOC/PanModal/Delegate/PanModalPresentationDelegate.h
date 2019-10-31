//
//  PanModalPresentationDelegate.h
//  PulleyOCDemo
//
//  Created by 张英杰 on 2019/10/30.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PanModalPresentationAnimator.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PanModalPresentationDelegate <UIViewControllerTransitioningDelegate,UIAdaptivePresentationControllerDelegate, UIPopoverPresentationControllerDelegate>


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresented:(UIViewController *)presented
                                                                  presenting:(UIViewController *)presenting
                                                                      source:(UIViewController *)source;
//{
//    return [[PanModalPresentationAnimator alloc] initWithTransitionStyle:PanModalTransitionStylePresentation];
//}

//    /**
//     Returns a modal presentation animator configured for the dismissing state
//     */
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissed:(UIViewController *)dismissed;
//        return PanModalPresentationAnimator(transitionStyle: .dismissal)


//    /**
//     Returns a modal presentation controller to coordinate the transition from the presenting
//     view controller to the presented view controller.
//
//     Changes in size class during presentation are handled via the adaptive presentation delegate
//     */
- (UIPresentationController *)presentationControllerForPresented:(UIViewController *)presented
                                                      presenting:(UIViewController *)presenting
                                                          source:(UIViewController *)source;



/**
 - Note: We do not adapt to size classes due to the introduction of the UIPresentationController
 & deprecation of UIPopoverController (iOS 9), there is no way to have more than one
 presentation controller in use during the same presentation

 This is essential when transitioning from .popover to .custom on iPad split view... unless a custom popover view is also implemented
 (popover uses UIPopoverPresentationController & we use PanModalPresentationController)
 */

/**
 Dismisses the presented view controller
 */
- (UIModalPresentationStyle)adaptivePresentationStyleForController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection;



@end

NS_ASSUME_NONNULL_END
