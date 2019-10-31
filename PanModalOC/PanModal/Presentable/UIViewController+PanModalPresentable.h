//
//  UIViewController+PanModalPresentable.h
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/30.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanModalPresentable.h"
#import "PanModalPresentationController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AnimationBlockType)(void);
typedef void(^AnimationCompletionType)(BOOL completion);

@interface UIViewController (PanModalPresentable)

- (void)panModalSetNeedsLayoutUpdate;

- (void)panModalTransitionState:(PresentationState)state ;

@end

NS_ASSUME_NONNULL_END
