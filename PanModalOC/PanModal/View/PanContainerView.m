//
//  PanContainerView.m
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/30.
//  Copyright © 2019 张英杰. All rights reserved.
//

#import "PanContainerView.h"

@implementation PanContainerView

- (instancetype)initWithFrame:(CGRect)frame
                presentedView:(UIView *)presentedView
{
    self = [super initWithFrame:frame];
    [self addSubview:presentedView];
    return self;
}

@end
