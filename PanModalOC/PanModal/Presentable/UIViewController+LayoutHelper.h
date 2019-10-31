//
//  UIViewController+LayoutHelper.h
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/31.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanModalHeight.h"
#import "PanModalPresentationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (LayoutHelper)

@property (nonatomic, strong, readonly) PanModalPresentationController *presentedVC;

@property (nonatomic, assign, readonly) CGFloat topLayoutOffset;

@property (nonatomic, assign, readonly) CGFloat bottomLayoutOffset;

@property (nonatomic, assign, readonly) CGFloat shortFormYPos;

@property (nonatomic, assign, readonly) CGFloat longFormYPos;

@property (nonatomic, assign, readonly) CGFloat bottomYPos;

- (CGFloat)topMarginFrom:(struct PanModalHeightStruct)from;

@end

NS_ASSUME_NONNULL_END
