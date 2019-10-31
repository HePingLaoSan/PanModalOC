//
//  PanModalPresentationAnimator.h
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/30.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PanModalTransitionStyle) {
    PanModalTransitionStylePresentation,
    PanModalTransitionStyleDismissal,
};

@interface PanModalPresentationAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) PanModalTransitionStyle transitionStyle;

@property (nonatomic, strong) UISelectionFeedbackGenerator *feedbackGenerator;

- (instancetype)initWithTransitionStyle:(PanModalTransitionStyle)transitionStyle;



@end

NS_ASSUME_NONNULL_END
