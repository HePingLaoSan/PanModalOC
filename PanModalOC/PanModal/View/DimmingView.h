//
//  DimmingView.h
//  YNote
//
//  Created by 张英杰 on 2019/10/30.
//  Copyright © 2019 Youdao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DimmingState) {
    DimmingStateMax,
    DimmingStateOff,
    DimmingStateCustomPercent,
};

typedef void(^DimmingDidTap)(UIGestureRecognizer *recognizer);

@interface DimmingView : UIView

@property (nonatomic, copy) DimmingDidTap didTap;
@property (nonatomic, assign) CGFloat dimAlpha;

- (void)setDimmingState:(DimmingState)state percent:(CGFloat)percent;

@end

NS_ASSUME_NONNULL_END
