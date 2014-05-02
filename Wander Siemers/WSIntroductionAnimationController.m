//
//  WSIntroductionAnimationController.m
//  Wander Siemers
//
//  Created by Ronald Siemers on 11-04-14.
//  Copyright (c) 2014 Wander Siemers. All rights reserved.
//

#import "WSIntroductionAnimationController.h"
#import "WSTimelineViewController.h"


@interface WSIntroductionAnimationController ()

@property (nonatomic, strong) id <UIViewControllerContextTransitioning> context;

@end

@implementation WSIntroductionAnimationController

const NSTimeInterval WSAnimationControllerAnimationDuration = 0.7;

#pragma mark - UIPanGestureRecognizer handling

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
	NSAssert(self.fromViewController != nil, @"An animator that doesn't know what to animate from\
			 doesn't make sense. Set the fromViewController property!");
	NSAssert(self.toViewController != nil, @"An animator that doesn't know what to animate to \
			 doesn't make sense. Set the toViewController property");
	if (gesture.state == UIGestureRecognizerStateBegan) {
		[self gestureBegan:gesture];
	} else if (gesture.state == UIGestureRecognizerStateChanged) {
		[self gestureChanged:gesture];
	} else if (gesture.state == UIGestureRecognizerStateEnded) {
		[self gestureEnded:gesture];
	}
}

- (void)gestureBegan:(UIPanGestureRecognizer *)gesture
{
	if ([gesture velocityInView:self.fromViewController.view].x < 0) {
		self.toViewController.transitioningDelegate = self;
		self.toViewController.modalPresentationStyle = UIModalPresentationCustom;
		[self.fromViewController presentViewController:self.toViewController animated:YES completion:nil];
	} else {
		// Nop: user swiped from left to right while we support right to left only
	}
}

- (void)gestureChanged:(UIPanGestureRecognizer *)gesture
{
	// Calculate how far the user has panned and update the interactive transaction
	CGPoint touchLocation = [gesture locationInView:self.fromViewController.view];
	CGFloat percentComplete = touchLocation.x / self.fromViewController.view.bounds.size.width;
	[self updateInteractiveTransition:percentComplete];
}

- (void)gestureEnded:(UIPanGestureRecognizer *)gesture
{
	CGPoint velocity = [gesture velocityInView:self.fromViewController.view];
	if (velocity.x < 0) {
		[self finishInteractiveTransition];
	} else {
		[self cancelInteractiveTransition];
	}
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
																  presentingController:(UIViewController *)presenting
																	  sourceController:(UIViewController *)source
{
	return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
	if (self.isInteractive) {
		return self;
	}
	return nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
	UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	
	UIView *containerView = transitionContext.containerView;
	[containerView addSubview:fromVC.view];
	[containerView addSubview:toVC.view];
	
	CGRect newFrame = toVC.view.frame;
	CGPoint newOrigin = toVC.view.frame.origin;
	newOrigin.x += toVC.view.frame.size.width;
	newFrame.origin = newOrigin;
	
	[UIView animateWithDuration:WSAnimationControllerAnimationDuration animations:^{
		toVC.view.frame = newFrame;
	} completion:^(BOOL finished) {
		[transitionContext completeTransition:finished];
	}];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
	return WSAnimationControllerAnimationDuration;
}

#pragma mark - UIViewControllerInteractiveTransitioning

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
	self.context = transitionContext;
	UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	
	UIView *containerView = transitionContext.containerView;
	[containerView addSubview:fromVC.view];
	toVC.view.hidden = YES;
	[containerView addSubview:toVC.view];
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
	UIViewController *toVC = [self.context viewControllerForKey:UITransitionContextToViewControllerKey];
	toVC.view.hidden = NO;
	
	CGFloat xCoordinate = toVC.view.frame.size.width * percentComplete;
	CGPoint newOrigin = CGPointMake(xCoordinate, toVC.view.frame.origin.y);
	CGRect newFrame = toVC.view.frame;
	newFrame.origin = newOrigin;
	toVC.view.frame = newFrame;
}

- (void)finishInteractiveTransition
{
	UIViewController *toVC = [self.context viewControllerForKey:UITransitionContextToViewControllerKey];
	CGRect endFrame = [self.context containerView].bounds;
	
	[UIView animateWithDuration:0.5f animations:^{
		toVC.view.frame = endFrame;
	} completion:^(BOOL finished) {
		[self.context completeTransition:YES];
	}];
}

- (void)cancelInteractiveTransition
{
	UIViewController *toVC = [self.context viewControllerForKey:UITransitionContextToViewControllerKey];
	CGRect endFrame = [self.context containerView].bounds;
	CGRect offscreenEndFrame = CGRectOffset(endFrame, endFrame.size.width, 0.0);
	
	[UIView animateWithDuration:0.5f animations:^{
		toVC.view.frame = offscreenEndFrame;
	} completion:^(BOOL finished) {
		[self.context completeTransition:NO];
	}];
	
}

@end
