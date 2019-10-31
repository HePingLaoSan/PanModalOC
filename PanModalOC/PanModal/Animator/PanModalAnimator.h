//
//  PanModalAnimator.h
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/30.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+PanModalPresentable.h"

NS_ASSUME_NONNULL_BEGIN

@interface PanModalAnimator : NSObject

+ (void)animate:(AnimationBlockType)animations
         config:(id<PanModalPresentable>)config
     completion:(AnimationCompletionType)completion;

@end

NS_ASSUME_NONNULL_END
