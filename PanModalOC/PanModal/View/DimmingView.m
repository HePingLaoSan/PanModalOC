//
//  DimmingView.m
//  YNote
//
//  Created by 张英杰 on 2019/10/30.
//  Copyright © 2019 Youdao. All rights reserved.
//

#import "DimmingView.h"

@interface DimmingView ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign) CGFloat panLocationStart;
@end

@implementation DimmingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dimAlpha = 0.7;
        [self tapGesture];
        self.backgroundColor = UIColor.blackColor;
        self.alpha = 0.0f;
    }
    return self;
}

- (UITapGestureRecognizer *)tapGesture {
    if (_tapGesture)  return _tapGesture;
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    [self addGestureRecognizer:_tapGesture];
    return _tapGesture;
}

- (void)didTapView:(UITapGestureRecognizer *)recognizer {
    if (self.didTap) {
        self.didTap(recognizer);
    }
}

- (void)setDimmingState:(DimmingState)state percent:(CGFloat)percent {
    switch (state) {
        case DimmingStateMax:
            self.alpha = _dimAlpha;
            break;
        case DimmingStateOff:
            self.alpha = 0.0f;
            break;
        case DimmingStateCustomPercent:
        {
            CGFloat value = MAX(0, MIN(1, percent));
            self.alpha = _dimAlpha * value;
        }
            break;
        
        default:
            break;
    }
}

@end
