//
//  UIView+panContainerView.m
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/30.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import "UIView+panContainerView.h"

@implementation UIView (panContainerView)

- (PanContainerView *)panContainerView {
    PanContainerView *result = nil;
    NSArray *subViews = self.subviews;
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[PanContainerView class]]) {
            result = (PanContainerView *)view;
            break;
        }
    }
    return result;
}
@end
