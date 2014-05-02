//
//  WSIntroductionAnimationController.h
//  Wander Siemers
//
//  Created by Ronald Siemers on 11-04-14.
//  Copyright (c) 2014 Wander Siemers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSIntroductionAnimationController : UIPercentDrivenInteractiveTransition <UIViewControllerInteractiveTransitioning, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter = isInteractive) BOOL interactive;
@property (nonatomic, strong) UIViewController *fromViewController;
@property (nonatomic, strong) UIViewController *toViewController;

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture;

@end
