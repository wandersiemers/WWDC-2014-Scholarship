//
//  WSAnimationController.m
//  Wander Siemers
//
//  Created by Ronald Siemers on 05-04-14.
//  Copyright (c) 2014 Wander Siemers. All rights reserved.
//

#import "WSProjectAnimationController.h"

const NSTimeInterval kDefaultTransitionDuration = 0.8;
const CGFloat kSpringDamping = 0.6;

@implementation WSProjectAnimationController

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
	return self.transitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
	id <UIViewControllerContextTransitioning> ctx = transitionContext;
	UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
	UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
	UIView *containerView = [transitionContext containerView];
	
	[containerView addSubview:fromView];
	
	CGRect oldFrame = toView.frame;
	CGRect newFrame = oldFrame;
	if (self.reverse) {
		newFrame.origin.x -= toView.frame.size.width;
	} else {
		newFrame.origin.x += toView.frame.size.width;
	}
	toView.frame = newFrame;
	[containerView addSubview:toView];
	
	[UIView animateWithDuration:[self transitionDuration:ctx]
						  delay:0.0
		 usingSpringWithDamping:kSpringDamping
		  initialSpringVelocity:0.0
						options:UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 toView.frame = oldFrame;
					 } completion:^(BOOL finished) {
						 [transitionContext completeTransition:YES];
					 }];
}

- (NSTimeInterval)transitionDuration
{
	if (!_transitionDuration) {
		return kDefaultTransitionDuration;
	}
	return _transitionDuration;
}

@end
