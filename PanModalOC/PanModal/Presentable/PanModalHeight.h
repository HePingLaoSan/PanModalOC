//
//  PanModalHeight.h
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/30.
//  Copyright © 2019 张英杰. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PanModalHeightType) {
    PanModalHeightTypeMaxHeight,
    PanModalHeightTypeMaxHeightWithTopInset,
    PanModalHeightTypeContentHeight,
    PanModalHeightTypeContentHeightIgnoringSafeArea,
    PanModalHeightTypeIntrinsicHeight,
};

struct PanModalHeightStruct {
    PanModalHeightType type;
    CGFloat value;
};


NS_ASSUME_NONNULL_END
