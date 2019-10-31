//
//  PanModalPresentationController.m
//  PanModalOC
//
//  Created by 张英杰 on 2019/10/30.
//  Copyright © 2019 张英杰. All rights reserved.
//

//todo:
/**
 configureViewLayout
 */

#import "PanModalPresentationController.h"
#import "PanModalPresentable.h"
#import "PanModalAnimator.h"
#import "DimmingView.h"
#import "PanContainerView.h"
#import "UIViewController+Defaults.h"
#import "UIViewController+LayoutHelper.h"

@interface PanModalPresentationController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) DimmingView *backgroundView;

@property (nonatomic, strong) PanContainerView *panContainerView;

@property (nonatomic, strong) UIView *dragIndicatorView;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, assign) BOOL observerWorking;

@end

@implementation PanModalPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    [self initConstants];
    [self initProperties];
    [self containerView];
    return self;
}

- (void)initConstants {
    self.indicatorYOffset = 8.0f;
    self.snapMovementSensitivity = 0.7f;
    self.dragIndicatorSize = CGSizeMake(36, 5);
}

- (void)initProperties {
    self.isPresentedViewAnimating = NO;
    self.extendsPanScrolling = YES;
    self.anchorModalToLongForm = YES;
    self.scrollViewYOffset = 0.0f;
    
    self.shortFormYPosition = 0.0f;
    self.longFormYPosition = 0.0f;
}

- (CGFloat)anchoredYPosition {
    CGFloat defaultTopOffset = [[self presentable] topOffset];
    return _anchorModalToLongForm ? _longFormYPosition : defaultTopOffset;
}

- (id<PanModalPresentable>)presentable {
    if ([self.presentedViewController conformsToProtocol:@protocol(PanModalPresentable)]) {
        return (id<PanModalPresentable>)self.presentedViewController;
    }
    return nil;
}

- (DimmingView *)backgroundView {
    if (_backgroundView) {
        return _backgroundView;
    }
    _backgroundView = [[DimmingView alloc] init];
    if ([self presentable] && [[self presentable] respondsToSelector:@selector(backgroundAlpha)]) {
        _backgroundView.dimAlpha = [[self presentable] backgroundAlpha];
    }
    __weak typeof(self)weakSelf = self;
    _backgroundView.didTap = ^(UIGestureRecognizer * _Nonnull recognizer) {
        if (weakSelf.presentable.allowsDragToDismiss) {
            [weakSelf dismissPresentedViewController];
        }
    };
    return _backgroundView;
}

- (PanContainerView *)panContainerView {
    if (_panContainerView) {
        return _panContainerView;
    }
    _panContainerView = [[PanContainerView alloc] initWithFrame:self.containerView.frame presentedView:self.presentedViewController.view];
    return _panContainerView;
}

- (UIView *)dragIndicatorView {
    if (_dragIndicatorView) {
        return _dragIndicatorView;
    }
    _dragIndicatorView = [UIView new];
    _dragIndicatorView.backgroundColor = UIColor.lightGrayColor;
    _dragIndicatorView.layer.cornerRadius = self.dragIndicatorSize.height / 2.0;
    return _dragIndicatorView;
}

- (UIView *)presentedView {
    return self.panContainerView;
}

- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (_panGestureRecognizer) {
        return _panGestureRecognizer;
    }
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanOnPresentedView:)];
    _panGestureRecognizer.minimumNumberOfTouches = 1;
    _panGestureRecognizer.maximumNumberOfTouches = 1;
    _panGestureRecognizer.delegate = self;
    return _panGestureRecognizer;
}

- (void)dealloc {
    [self removeObserver:[[self presentable] panScrollable]];
}

#pragma mark - Life Cycle
- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    [self configureViewLayout];
}

- (void)presentationTransitionWillBegin {
    if (self.containerView == nil)  return;
    [self layoutBackgroundView:self.containerView];
    [self layoutPresentedView:self.containerView];
    [self configureScrollViewInsets];
    
    if (self.presentedViewController.transitionCoordinator == nil) {
        [self.backgroundView setDimmingState:DimmingStateMax percent:0];
        return;
    }
    
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.backgroundView setDimmingState:DimmingStateMax percent:0];
        [self.presentedViewController setNeedsStatusBarAppearanceUpdate];
    } completion:nil];
}

- (void)dismissalTransitionWillBegin {
    id<UIViewControllerTransitionCoordinator>coordinator = self.presentedViewController.transitionCoordinator;
    if (coordinator==nil) {
        [self.backgroundView setDimmingState:DimmingStateOff percent:0];
        return;
    }
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dragIndicatorView.alpha = 0.0;
        [self.backgroundView setDimmingState:DimmingStateOff percent:0];
        [self.presentingViewController setNeedsStatusBarAppearanceUpdate];
    } completion:nil];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (completed) {
        return;
    }
    [_backgroundView removeFromSuperview];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if ([self presentable]) {
            [self adjustPresentedViewFrame];
            if ([[self presentable] shouldRoundTopCorners]) {
                [self addRoundedCornersToView:self.presentedView];
            }
        }
    } completion:nil];
}

#pragma mark - Public Methods

- (void)transitionState:(PresentationState)state {
    if ([self.presentable shouldTransitionState:state]) {
        [self.presentable willTransitionState:state];
        switch (state) {
            case PresentationStateShortForm:
                [self snapToYPosition:_shortFormYPosition];
                break;
            case PresentationStateLongForm:
                [self snapToYPosition:_longFormYPosition];
                break;
                
            default:
                break;
        }
    }
}


- (void)addObserver:(UIScrollView *)scrollView {
    NSAssert(_observerWorking==NO, @"");
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld context:nil];
    _observerWorking = YES;
}

- (void)removeObserver:(UIScrollView *)scrollView {
    if (scrollView == nil || _observerWorking==NO) {
        return;
    }
    @try {
        [scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    } @catch (NSException *exception) {
        
    }
    _observerWorking = NO;
}

- (void)setContentOffset:(CGPoint)offset {
    UIScrollView *scrollView = [[self presentable] panScrollable];
    if (scrollView == nil) return ;
    [self removeObserver:scrollView];
    [scrollView setContentOffset:offset animated:false];
    [self trackScrolling:scrollView];
    [self addObserver:scrollView];
}

- (void)setNeedsLayoutUpdate {
    [self configureViewLayout];
    [self adjustPresentedViewFrame];
    [self removeObserver:self.presentable.panScrollable];
    [self addObserver:self.presentable.panScrollable];
    [self configureScrollViewInsets];
}

#pragma mark - Presented View Layout Configuration

- (BOOL)isPresentedViewAnchored {
    if (!_isPresentedViewAnimating && _extendsPanScrolling && CGRectGetMinY(self.presentedView.frame) <= self.anchoredYPosition) {
        return YES;
    }
    return NO;
}

- (void)layoutPresentedView:(UIView *)containerView {
    if (self.presentable == nil) {
        return;
    }
    
    [containerView addSubview:self.presentedView];
    [containerView addGestureRecognizer:self.panGestureRecognizer];

    if ([self.presentable respondsToSelector:@selector(showDragIndicator)] && [self.presentable showDragIndicator]) {
        [self addDragIndicatorView:self.presentedView];
    }
    
    if ([self.presentable respondsToSelector:@selector(shouldRoundTopCorners)] && self.presentable.shouldRoundTopCorners) {
        [self addRoundedCornersToView:self.presentedView];
    }

    [self setNeedsLayoutUpdate];
    [self adjustPanContainerBackgroundColor];
}

- (void)adjustPresentedViewFrame {
    if (self.containerView == nil) {
        return;
    }
    CGSize adjustedSize = CGSizeMake(CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame) - self.anchoredYPosition);
    CGRect panFrame = self.panContainerView.frame;
    
    self.panContainerView.frame = CGRectMake(self.panContainerView.frame.origin.x, self.panContainerView.frame.origin.y, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));

    
    if (![@[@(self.shortFormYPosition), @(_longFormYPosition)] containsObject:@(panFrame.origin.y)]) {
        [self adjustToYPosition:panFrame.origin.y - panFrame.size.height + self.containerView.frame.size.height];
    }
    self.panContainerView.frame = CGRectMake(self.containerView.frame.origin.x, self.panContainerView.frame.origin.y, CGRectGetWidth(self.panContainerView.frame), CGRectGetHeight(self.panContainerView.frame));
    self.presentedViewController.view.frame = CGRectMake(0, 0, adjustedSize.width, adjustedSize.height);
}

- (void)adjustPanContainerBackgroundColor {
    if (self.presentedViewController) {
        _panContainerView.backgroundColor = self.presentedViewController.view.backgroundColor;
    } else {
        _panContainerView.backgroundColor = self.presentable.panScrollable.backgroundColor;
    }
}

- (void)layoutBackgroundView:(UIView *)containerView {
    [containerView addSubview:self.backgroundView];
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = false;
    [self.backgroundView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor].active = YES;
    [self.backgroundView.leadingAnchor constraintEqualToAnchor: containerView.leadingAnchor].active = true;
    [self.backgroundView.trailingAnchor constraintEqualToAnchor: containerView.trailingAnchor].active = true;
    [self.backgroundView.bottomAnchor constraintEqualToAnchor: containerView.bottomAnchor].active = true;
}

- (void)addDragIndicatorView:(UIView *)view {
    [view addSubview:self.dragIndicatorView];
    self.dragIndicatorView.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.dragIndicatorView.bottomAnchor constraintEqualToAnchor:view.topAnchor constant:(-self.indicatorYOffset)].active = YES;
    [self.dragIndicatorView.centerXAnchor constraintEqualToAnchor: view.centerXAnchor].active = true;
    [self.dragIndicatorView.widthAnchor constraintEqualToConstant:self.dragIndicatorSize.width].active = true;
    [self.dragIndicatorView.heightAnchor constraintEqualToConstant: self.dragIndicatorSize.height].active = true;
}

- (void)configureViewLayout {
    if (![self.presentedViewController conformsToProtocol:@protocol(PanModalPresentable)]) {
        return;
    }
    id<PanModalPresentable> layoutPresentable = (id<PanModalPresentable>)self.presentedViewController;
    _shortFormYPosition = ((UIViewController *)layoutPresentable).shortFormYPos;
    _longFormYPosition = ((UIViewController *)layoutPresentable).longFormYPos;
    _anchorModalToLongForm = ((UIViewController *)layoutPresentable).anchorModalToLongForm;
    _extendsPanScrolling = ((UIViewController *)layoutPresentable).allowsExtendedPanScrolling;

    self.containerView.userInteractionEnabled = layoutPresentable.isUserInteractionEnabled;
}

- (void)configureScrollViewInsets {
    UIScrollView *scrollView = self.presentable.panScrollable;
    if (scrollView == nil || ![self isScrolling:scrollView]) return;
    scrollView.showsVerticalScrollIndicator = false;
    scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    if ([self.presentable respondsToSelector:@selector(scrollIndicatorInsets)]) {
        scrollView.scrollIndicatorInsets = [self.presentable scrollIndicatorInsets];
    }


    /**
     Set the appropriate contentInset as the configuration within this class
     offsets it
     */
    scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top, scrollView.contentInset.left, self.presentingViewController.bottomLayoutGuide.length, scrollView.contentInset.right);
    

    /**
     As we adjust the bounds during `handleScrollViewTopBounce`
     we should assume that contentInsetAdjustmentBehavior will not be correct
     */
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

#pragma mark - Pan Gesture Event Handler

- (void)didPanOnPresentedView:(UIPanGestureRecognizer *)recognizer {
    if (![self shouldRespondGestureRecognizer:recognizer] || self.containerView == nil) {
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        return;
    }
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            [self respondToPanGesture:recognizer];
            if (self.presentedView.frame.origin.y == self.anchoredYPosition && _extendsPanScrolling) {
                [[self presentable] willTransitionState:PresentationStateLongForm];
            }
        }
            break;
        default:
        {
            CGPoint velocity = [recognizer velocityInView:self.presentedView];
            BOOL isVelocityWithinSensitivityRange = ((fabs(velocity.y) - (1000 * (1 - self.snapMovementSensitivity))) > 0);
            if (isVelocityWithinSensitivityRange) {
                /**
                 If velocity is within the sensitivity range,
                 transition to a presentation state or dismiss entirely.

                 This allows the user to dismiss directly from long form
                 instead of going to the short form state first.
                 */
                if (velocity.y < 0) {
                    [self transitionState:PresentationStateLongForm];
                } else if (((([self nearestToNumber:CGRectGetMinY(self.presentedView.frame) inValues:@[@(CGRectGetHeight(self.containerView.bounds)),@(_longFormYPosition)]]) == _longFormYPosition
                    && CGRectGetMinY(self.presentedView.frame) < _shortFormYPosition)) || self.presentable.allowsDragToDismiss == false) {
                    [self transitionState:PresentationStateShortForm];

                } else {
                    [self dismissPresentedViewController];
                }
            } else {
                CGFloat position = [self nearestToNumber:CGRectGetMinY(self.presentedView.frame) inValues:@[@(CGRectGetHeight(self.containerView.bounds)),@(_shortFormYPosition),@(_longFormYPosition)]];
                if (position == _longFormYPosition) {
                    [self transitionState:PresentationStateLongForm];
                } else if (position == _shortFormYPosition || self.presentable.allowsDragToDismiss == false) {
                    [self transitionState:PresentationStateShortForm];
                } else {
                    [self dismissPresentedViewController];
                }
            }
        }
            break;
    }
    
    
}

- (BOOL)shouldRespondGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    if ([[self presentable] shouldRespondPanModalGestureRecognizer:panGestureRecognizer]==true || !(panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateCancelled)) {
        BOOL ret = ![self shouldFailGestureRecognizer:panGestureRecognizer];
        return ret;
    }
    panGestureRecognizer.enabled = false;
    panGestureRecognizer.enabled = true;
    return NO;

}

- (void)respondToPanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    [[self presentable] willRespondPanModalGestureRecognizer:panGestureRecognizer];
    
    CGFloat yDisplacement = [panGestureRecognizer translationInView:self.presentedView].y;
    
    if (self.presentedView.frame.origin.y < _longFormYPosition) {
        yDisplacement /= 2.0;
    }
    [self adjustToYPosition:self.presentedView.frame.origin.y + yDisplacement];
    [panGestureRecognizer setTranslation:CGPointZero inView:self.presentedView];
}

- (BOOL)shouldFailGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    BOOL ret = ![self shouldPrioritize:panGestureRecognizer];
    if (ret == NO) {
        [[self presentable] panScrollable].panGestureRecognizer.enabled = false;
        [[self presentable] panScrollable].panGestureRecognizer.enabled = true;
        return false;
    }
    UIScrollView *scrollView = [[self presentable] panScrollable];
    if (self.isPresentedViewAnchored && scrollView && scrollView.contentOffset.y >0) {
        CGPoint loc = [panGestureRecognizer locationInView:self.presentedView];
        return CGRectContainsPoint(scrollView.frame, loc) || [self isScrolling:scrollView];
    }
    return false;
}


- (BOOL)shouldPrioritize:(UIPanGestureRecognizer *)panGestureRecognizer {
    return panGestureRecognizer.state == UIGestureRecognizerStateBegan &&
    [self.presentable shouldPrioritizePanModalGestureRecognizer:panGestureRecognizer];
}

- (BOOL)isVelocityWithinSensitivityRange:(CGFloat)velocity {
    return (fabs(velocity) - (1000 * (1 - self.snapMovementSensitivity))) > 0;
}

- (void)snapToYPosition:(CGFloat)yPos {
    [PanModalAnimator animate:^{
        [self adjustToYPosition:yPos];
        self.isPresentedViewAnimating = YES;
    } config:self.presentable completion:^(BOOL completion) {
        self.isPresentedViewAnimating = !completion;
    }];
}

- (void)adjustToYPosition:(CGFloat)yPos {
    CGFloat topY = MAX(yPos, self.anchoredYPosition);
    self.presentedView.frame = CGRectMake(CGRectGetMinX(self.presentedView.frame), topY, CGRectGetWidth(self.presentedView.frame), CGRectGetHeight(self.presentedView.frame));
    if (self.presentedView.frame.origin.y <= _shortFormYPosition) {
        [self.backgroundView setDimmingState:DimmingStateMax percent:0];
        return;
    }
    CGFloat yDisplacementFromShortForm = self.presentedView.frame.origin.y - _shortFormYPosition;

    [self.backgroundView setDimmingState:DimmingStateCustomPercent percent:(1.0 - (yDisplacementFromShortForm / self.presentedView.frame.size.height))];
}

- (CGFloat)nearestToNumber:(CGFloat)number inValues:(NSArray *)values {
    CGFloat min = CGFLOAT_MAX;
    for (NSNumber *eachNum in values) {
        if (fabs(eachNum.floatValue - number) < min) {
            min = eachNum.floatValue;
        }
    }
    return min;
}

- (void)dismissPresentedViewController {
    [[self presentable] panModalWillDismiss];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollView Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.containerView==nil) {
        return;
    }
    NSNumber *oldObj = change[NSKeyValueChangeOldKey];
    CGPoint oldPoint = [oldObj CGPointValue];
    [self didPanOnScrollView:object point:oldPoint];
}

- (void)didPanOnScrollView:(UIScrollView *)scrollView point:(CGPoint)point {
    if (self.presentedViewController.isBeingDismissed || self.presentedViewController.isBeingPresented) {
        return;
    }
    
    
    if (![self isPresentedViewAnchored] && scrollView.contentOffset.y>0) {
        [self haltScrolling:scrollView];
    } else if ([self isScrolling:scrollView] || _isPresentedViewAnimating) {
        if ([self isPresentedViewAnchored]) {
            [self trackScrolling:scrollView];
        } else {
            [self haltScrolling:scrollView];
        }
    } else if ([self.presentedViewController.view isKindOfClass:[UIScrollView class]] && !_isPresentedViewAnimating && scrollView.contentOffset.y <= 0) {
        [self handleScrollViewTopBounce:scrollView point:point];
    } else {
        [self trackScrolling:scrollView];
    }
}

- (void)haltScrolling:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(0, _scrollViewYOffset) animated:false];
    scrollView.showsVerticalScrollIndicator = false;
}

- (void)trackScrolling:(UIScrollView *)scrollView {
    _scrollViewYOffset = MAX(scrollView.contentOffset.y, 0);
    scrollView.showsVerticalScrollIndicator = true;
}

- (void)handleScrollViewTopBounce:(UIScrollView *)scrollView point:(CGPoint)point {
    CGFloat yOffset = scrollView.contentOffset.y;
    CGFloat oldYValue = point.y;
    CGSize presentedSize = CGSizeZero;
    if (scrollView.isDecelerating == NO) {
        return;
    }
    
    if (self.containerView) {
        presentedSize = self.containerView.frame.size;
    }
    self.presentedView.bounds = CGRectMake(0, 0, presentedSize.width, presentedSize.height + yOffset);
    if (oldYValue > yOffset) {
        self.presentedView.frame = CGRectMake(CGRectGetMinX(self.presentedView.frame), _longFormYPosition - yOffset, CGRectGetWidth(self.presentedView.frame), CGRectGetHeight(self.presentedView.frame));
    } else {
        _scrollViewYOffset = 0;
        [self snapToYPosition:_longFormYPosition];
    }
    
    scrollView.showsVerticalScrollIndicator = false;
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return false;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([[self presentable] panScrollable] == otherGestureRecognizer.view) {
        return YES;
    }
    return NO;
}

#pragma mark - UIBezierPath
- (void)addRoundedCornersToView:(UIView *)view {
    id<PanModalPresentable>presentable =[self presentable];
    CGFloat radius = [presentable cornerRadius];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)];
    
    if (presentable && [presentable showDragIndicator]) {
        CGFloat indicatorLeftEdgeXPos = view.bounds.size.width/2.0 - self.dragIndicatorSize.width/2.0;
        [self drawAroundDragIndicator:path indicatorLeftEdgeXPos:indicatorLeftEdgeXPos];
    }
    
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = path.CGPath;
    view.layer.mask = mask;
    
    view.layer.shouldRasterize = true;
    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)drawAroundDragIndicator:(UIBezierPath *)path indicatorLeftEdgeXPos:(CGFloat)indicatorLeftEdgeXPos {
    CGFloat totalIndicatorOffset = self.indicatorYOffset + self.dragIndicatorSize.height;
    [path addLineToPoint:CGPointMake(indicatorLeftEdgeXPos, path.currentPoint.y)];
    [path addLineToPoint:CGPointMake(path.currentPoint.x, path.currentPoint.y - totalIndicatorOffset)];
    [path addLineToPoint:CGPointMake(path.currentPoint.x + self.dragIndicatorSize.width, path.currentPoint.y)];
    [path addLineToPoint:CGPointMake(path.currentPoint.x, path.currentPoint.y + totalIndicatorOffset)];
}


#pragma mark - Helper Extensions

- (BOOL)isScrolling:(UIScrollView *)scrollView {
    return (scrollView.isDragging && !scrollView.isDecelerating) || scrollView.isTracking;
}
@end
