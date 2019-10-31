//
//  PanModalPresentationController.h
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/30.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PresentationState) {
    PresentationStateShortForm,
    PresentationStateLongForm,
};

@interface PanModalPresentationController : UIPresentationController

//Constants
@property (nonatomic, assign) CGFloat indicatorYOffset;
@property (nonatomic, assign) CGFloat snapMovementSensitivity;
@property (nonatomic, assign) CGSize dragIndicatorSize;

//Properties

/**
 A flag to track if the presented view is animating
 */
@property (nonatomic, assign) BOOL isPresentedViewAnimating;
/**
 A flag to determine if scrolling should seamlessly transition
 from the pan modal container view to the scroll view
 once the scroll limit has been reached.
 */
@property (nonatomic, assign) BOOL extendsPanScrolling;
/**
 A flag to determine if scrolling should be limited to the longFormHeight.
 Return false to cap scrolling at .max height.
 */
@property (nonatomic, assign) BOOL anchorModalToLongForm;
/**
 The y content offset value of the embedded scroll view
 */
@property (nonatomic, assign) CGFloat scrollViewYOffset;

// store the y positions so we don't have to keep re-calculating

/**
 The y value for the short form presentation state
 */
@property (nonatomic, assign) CGFloat shortFormYPosition;

/**
 The y value for the long form presentation state
 */
@property (nonatomic, assign) CGFloat longFormYPosition;

/**
 Determine anchored Y postion based on the `anchorModalToLongForm` flag
 */
@property (nonatomic, assign) CGFloat anchoredYPosition;


- (void)transitionState:(PresentationState)state;

- (void)setContentOffset:(CGPoint)offset;

- (void)setNeedsLayoutUpdate;



@end

NS_ASSUME_NONNULL_END
