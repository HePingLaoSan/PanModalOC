//
//  UIViewController+PanModalPresenter.h
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/31.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanModalPresentable.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (PanModalPresenter)

@property (nonatomic, assign, readonly) BOOL isPanModalPresented;

- (void)presentPanModal:(id<PanModalPresentable>)viewControllerToPresent sourceView:(UIView *)sourceView sourceRect:(CGRect)sourceRect;
@end

NS_ASSUME_NONNULL_END
