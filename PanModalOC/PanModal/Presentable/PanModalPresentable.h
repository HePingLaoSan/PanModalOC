//
//  PanModalPresentable.h
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/30.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PanModalPresentationController.h"
#import "PanModalHeight.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PanModalPresentable <NSObject>

/**
The scroll view embedded in the view controller.
Setting this value allows for seamless transition scrolling between the embedded scroll view
and the pan modal container view.
*/
- (UIScrollView *)panScrollable;

/**
 The offset between the top of the screen and the top of the pan modal container view.

 Default value is the topLayoutGuide.length + 21.0.
 */
- (CGFloat)topOffset;

/**
 The height of the pan modal container view
 when in the shortForm presentation state.

 This value is capped to .max, if provided value exceeds the space available.

 Default value is the longFormHeight.
 */
- (struct PanModalHeightStruct)shortFormHeight;

/**
 The height of the pan modal container view
 when in the longForm presentation state.
 
 This value is capped to .max, if provided value exceeds the space available.

 Default value is .max.
 */
- (struct PanModalHeightStruct)longFormHeight;

/**
 The corner radius used when `shouldRoundTopCorners` is enabled.

 Default Value is 8.0.
 */
- (CGFloat)cornerRadius;

/**
 The springDamping value used to determine the amount of 'bounce'
 seen when transitioning to short/long form.

 Default Value is 0.8.
 */
- (CGFloat)springDamping;

/**
 The transitionDuration value is used to set the speed of animation during a transition,
 including initial presentation.

 Default value is 0.5.
*/
- (CGFloat)transitionDuration;

/**
 The animation options used when performing animations on the PanModal, utilized mostly
 during a transition.

 Default value is [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState].
*/
- (UIViewAnimationOptions)transitionAnimationOptions;

/**
 The background view alpha.

 - Note: This is only utilized at the very start of the transition.

 Default Value is 0.7.
 */
- (CGFloat)backgroundAlpha;

/**
 We configure the panScrollable's scrollIndicatorInsets interally so override this value
 to set custom insets.

 - Note: Use `panModalSetNeedsLayoutUpdate()` when updating insets.
 */
- (UIEdgeInsets)scrollIndicatorInsets;

/**
A flag to determine if scrolling should be limited to the longFormHeight.
Return false to cap scrolling at .max height.

Default value is true.
*/
- (BOOL)anchorModalToLongForm;

/**
A flag to determine if scrolling should seamlessly transition from the pan modal container view to
the embedded scroll view once the scroll limit has been reached.

Default value is false. Unless a scrollView is provided and the content height exceeds the longForm height.
*/
- (BOOL)allowsExtendedPanScrolling;

/**
 A flag to determine if dismissal should be initiated when swiping down on the presented view.

 Return false to fallback to the short form state instead of dismissing.

 Default value is true.
 */
- (BOOL)allowsDragToDismiss;

/**
 A flag to toggle user interactions on the container view.

 - Note: Return false to forward touches to the presentingViewController.

 Default is true.
*/
- (BOOL)isUserInteractionEnabled;

/**
 A flag to determine if haptic feedback should be enabled during presentation.

 Default value is true.
 */
- (BOOL)isHapticFeedbackEnabled;

/**
 A flag to determine if the top corners should be rounded.

 Default value is true.
 */
- (BOOL)shouldRoundTopCorners;

/**
 A flag to determine if a drag indicator should be shown
 above the pan modal container view.

 Default value is true.
 */
- (BOOL)showDragIndicator;

/**
 Asks the delegate if the pan modal should respond to the pan modal gesture recognizer.
 
 Return false to disable movement on the pan modal but maintain gestures on the presented view.

 Default value is true.
 */
- (BOOL)shouldRespondPanModalGestureRecognizer:(UIPanGestureRecognizer *)panModalGestureRecognizer;

/**
 Notifies the delegate when the pan modal gesture recognizer state is either
 `began` or `changed`. This method gives the delegate a chance to prepare
 for the gesture recognizer state change.

 For example, when the pan modal view is about to scroll.

 Default value is an empty implementation.
 */
- (void)willRespondPanModalGestureRecognizer:(UIPanGestureRecognizer *)panModalGestureRecognizer;

/**
Asks the delegate if the pan modal gesture recognizer should be prioritized.

For example, you can use this to define a region
where you would like to restrict where the pan gesture can start.

If false, then we rely solely on the internal conditions of when a pan gesture
should succeed or fail, such as, if we're actively scrolling on the scrollView.

Default return value is false.
*/
- (BOOL)shouldPrioritizePanModalGestureRecognizer:(UIPanGestureRecognizer *)panModalGestureRecognizer;

/**
Asks the delegate if the pan modal should transition to a new state.

Default value is true.
*/
- (BOOL)shouldTransitionState:(PresentationState)state;

/**
 Notifies the delegate that the pan modal is about to transition to a new state.

 Default value is an empty implementation.
 */
- (void)willTransitionState:(PresentationState)state;

/**
 Notifies the delegate that the pan modal is about to be dismissed.

 Default value is an empty implementation.
 */
- (void)panModalWillDismiss;


//PanModalPresentable+LayoutHelpers
- (PanModalPresentationController *)presentedVC;



@end

NS_ASSUME_NONNULL_END
