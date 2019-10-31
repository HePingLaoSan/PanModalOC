//
//  PanModalPresentationDelegateImp.h
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/31.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PanModalPresentationDelegate.h"
#import "PanModalPresentationAnimator.h"

NS_ASSUME_NONNULL_BEGIN

@interface PanModalPresentationDelegateImp : NSObject<UIViewControllerTransitioningDelegate,UIAdaptivePresentationControllerDelegate, UIPopoverPresentationControllerDelegate>

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
