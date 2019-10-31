//
//  UIViewController+LayoutHelper.m
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/31.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import "UIViewController+LayoutHelper.h"
#import "PanModalPresentable.h"

@implementation UIViewController (LayoutHelper)

- (PanModalPresentationController *)presentedVC {
    if ([self.presentationController isKindOfClass:[PanModalPresentationController class]]) {
        return (PanModalPresentationController *)self.presentationController;
    }
    return nil;
}

- (CGFloat)topLayoutOffset {
    CGFloat offset = 0;
    if (@available(iOS 12.0, *)) {
        offset =  UIApplication.sharedApplication.keyWindow.rootViewController.view.safeAreaInsets.top;
    } else {
        offset = UIApplication.sharedApplication.keyWindow.rootViewController.topLayoutGuide.length;
    }
    return offset;
}

- (CGFloat)bottomLayoutOffset {
    if (@available(iOS 12.0, *)) {
        return UIApplication.sharedApplication.keyWindow.rootViewController.view.safeAreaInsets.bottom;
    }
    return UIApplication.sharedApplication.keyWindow.rootViewController.bottomLayoutGuide.length;
}

- (CGFloat)shortFormYPos {
    if (UIAccessibilityIsVoiceOverRunning()) {
        return self.longFormYPos;
    }
    //[self.presentable respondsToSelector:@selector(shouldRoundTopCorners)] &&
    CGFloat shortFormYPos = [self topMarginFrom:[(id<PanModalPresentable>)self shortFormHeight]] + [(id<PanModalPresentable>)self topOffset];
    
    // shortForm shouldn't exceed longForm
    return MAX(shortFormYPos, self.longFormYPos);
}

- (CGFloat)longFormYPos {
    CGFloat var1 = [self topMarginFrom:[(id<PanModalPresentable>)self longFormHeight]];
    struct PanModalHeightStruct s = {PanModalHeightTypeMaxHeight, 0};
    CGFloat var2 = [self topMarginFrom:s];
    CGFloat ret = MAX(var1, var2 + [(id<PanModalPresentable>)self topOffset]);
    return ret;
}

- (CGFloat)bottomYPos {
    if (self.presentedVC == nil) {
        return self.view.bounds.size.height;
    }
    
    return self.presentedVC.containerView.bounds.size.height - [(id<PanModalPresentable>)self topOffset];
}


- (CGFloat)topMarginFrom:(struct PanModalHeightStruct)from {
    switch (from.type) {
        case PanModalHeightTypeMaxHeight:
            return 0.0f;
            break;
        case PanModalHeightTypeMaxHeightWithTopInset:
            return from.value;
            break;
        case PanModalHeightTypeContentHeight:
            return self.bottomYPos - (from.value + self.bottomLayoutOffset);
            break;
        case PanModalHeightTypeContentHeightIgnoringSafeArea:
            return self.bottomYPos - from.value;
            break;
        case PanModalHeightTypeIntrinsicHeight:
        {
            [self.view layoutIfNeeded];
            CGFloat width = UIScreen.mainScreen.bounds.size.width;
            if (self.presentedVC.containerView) {
                width = CGRectGetWidth(self.presentedVC.containerView.bounds);
            }
            CGSize targetSize = CGSizeMake(width, UILayoutFittingCompressedSize.height);
            CGFloat intrinsicHeight = [self.view systemLayoutSizeFittingSize:targetSize].height;
            return self.bottomYPos - (intrinsicHeight + self.bottomLayoutOffset);
        }
            break;
        default:
            return 0.0f;
            break;
    }
}
@end
