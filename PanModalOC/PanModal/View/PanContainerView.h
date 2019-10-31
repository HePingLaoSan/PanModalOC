//
//  PanContainerView.h
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/30.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PanContainerView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                presentedView:(UIView *)presentedView;

@end

NS_ASSUME_NONNULL_END
