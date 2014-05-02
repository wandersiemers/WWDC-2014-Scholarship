//
//  WSIntroductionViewController.m
//  Wander Siemers
//
//  Created by Ronald Siemers on 09-04-14.
//  Copyright (c) 2014 Wander Siemers. All rights reserved.
//

#import "WSIntroductionViewController.h"
#import "UIImage+ImageEffects.h"
#import "WSIntroductionAnimationController.h"
#import "WSTimelineViewController.h"
@import QuartzCore;

const NSTimeInterval WSIntroductionAnimationDuration = 0.5;

@interface WSIntroductionViewController ()

@property (nonatomic, weak) UIImageView *blurredBackgroundImageView;
@property (nonatomic, strong) WSIntroductionAnimationController *animationController;
@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel	*textLabel;
@property (nonatomic, readonly) UIFont *labelFont;

@end

@implementation WSIntroductionViewController


- (void)viewDidLoad
{
	[super viewDidLoad];
	WSIntroductionAnimationController *animationController = [[WSIntroductionAnimationController alloc] init];
	animationController.fromViewController = self;
	animationController.toViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
											instantiateViewControllerWithIdentifier:@"timeline"];
	animationController.interactive = YES;
	
	self.animationController = animationController;
	UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc]
												 initWithTarget:self.animationController
												 action:@selector(handlePanGesture:)];
	[self.view addGestureRecognizer:gestureRecognizer];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	UIViewController *destination = segue.destinationViewController;
	destination.transitioningDelegate = self.animationController;
	self.modalPresentationStyle = UIModalPresentationCustom;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];\
	// Avoid flickering (UIKit bug?)
	[self performSelector:@selector(setupBlurredBackground) withObject:nil afterDelay:0.2];
}

- (void)setupBlurredBackground
{
	CGRect renderRect = self.view.frame;

	UIGraphicsBeginImageContextWithOptions(renderRect.size, YES, 2.0);
	BOOL success = [self.view.window drawViewHierarchyInRect:renderRect afterScreenUpdates:YES];
	if (!success) {
		return;
	}
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	image = [image applyLightEffect];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	imageView.frame = renderRect;
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	imageView.center = self.view.center;
	imageView.alpha = 0.0;
	[self.view addSubview:imageView];
	self.blurredBackgroundImageView = imageView;
	
	[self addAvatarView];
	
	[UIView animateWithDuration:WSIntroductionAnimationDuration animations:^{
		imageView.alpha = 1.0;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:WSIntroductionAnimationDuration delay:0.1 options:0 animations:^{
			self.avatarImageView.alpha = 1.0;
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:WSIntroductionAnimationDuration delay:0.3 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:0 animations:^{
				CGPoint center = self.avatarImageView.center;
				center.y -= 100.0;
				self.avatarImageView.center = center;
			} completion:^(BOOL finished) {
				[self addTextLabels];
				[self addSwipeToUnlockLabel];
				[UIView animateWithDuration:WSIntroductionAnimationDuration animations:^{
					self.textLabel.alpha = 1.0;
					// todo http://stackoverflow.com/questions/438046/iphone-slide-to-unlock-animation
				}];
			}];
		}];
	}];
}

- (void)addAvatarView
{
	UIImageView *avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"awyeah"]];
	NSAssert(CGRectGetHeight(avatarImageView.frame) != 0.0, nil);
	NSAssert(CGRectGetHeight(avatarImageView.frame) == CGRectGetWidth(avatarImageView.frame), @"Image isn't square");
	avatarImageView.layer.cornerRadius = CGRectGetHeight(avatarImageView.frame) / 2.0;
	avatarImageView.layer.masksToBounds = YES;
	avatarImageView.alpha = 0.0;
	avatarImageView.center = self.view.center;
	
	[self.blurredBackgroundImageView addSubview:avatarImageView];
	self.avatarImageView = avatarImageView;
}

- (void)addTextLabels
{
	UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	textLabel.text = @"Hi!\nMy name is Wander\nThank you for considering my application\n";
	textLabel.font = self.labelFont;
	textLabel.textAlignment = NSTextAlignmentCenter;
	textLabel.center = self.view.center;
	textLabel.alpha = 0.0;
	textLabel.backgroundColor = [UIColor clearColor];
	textLabel.numberOfLines = 4;
	
	[textLabel sizeToFit];
	CGRect newFrame = textLabel.frame;
	
	newFrame.origin.y = CGRectGetMaxY(self.avatarImageView.frame) + 20.0;
	
	textLabel.frame = newFrame;
	
	[self.view addSubview:textLabel];
	
	CGPoint newCenter = textLabel.center;
	newCenter.x = self.view.center.x;
	textLabel.center = newCenter;
	
	self.textLabel = textLabel;
	
	[self addSwipeToUnlockLabel];
}

- (void)addSwipeToUnlockLabel
{
	CATextLayer *swipeToUnlockTextLayer = [[CATextLayer alloc] init];
	swipeToUnlockTextLayer.contentsScale = [UIScreen mainScreen].scale; // Retina support: otherwise, the layer gets pixelated
	swipeToUnlockTextLayer.string = @"Swipe left to get started";
	[self.view.layer addSublayer:swipeToUnlockTextLayer];
	CGFontRef coreGraphicsFont = CGFontCreateWithFontName((CFStringRef)self.labelFont.fontName);
	swipeToUnlockTextLayer.font = coreGraphicsFont;
	swipeToUnlockTextLayer.fontSize = self.labelFont.pointSize;
	CGFontRelease(coreGraphicsFont);
	swipeToUnlockTextLayer.foregroundColor = [UIColor blackColor].CGColor;
	CGFloat width = 177.0; // Too lazy to use CoreText to calculate actual width
	CGFloat height = 50.0; // Idem
	swipeToUnlockTextLayer.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 0.5 * width,
											  CGRectGetMaxY(self.textLabel.frame), width, height);
	
	CALayer *maskLayer = [[CALayer alloc] init];
	maskLayer.contents = (id)[UIImage imageNamed:@"textlayermask"].CGImage;
	maskLayer.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.15f] CGColor];
	
	maskLayer.contentsGravity = kCAGravityCenter;
	maskLayer.frame = CGRectMake(0.0, 0.0f, width * 2, height);
	
	// Animate the mask layer's horizontal position
	CABasicAnimation *maskAnim = [CABasicAnimation animationWithKeyPath:@"position.x"];
	maskAnim.byValue = [NSNumber numberWithFloat:-width + -20.0];
	maskAnim.duration = 2.0f;
	maskAnim.repeatCount = HUGE_VALF;
	[maskLayer addAnimation:maskAnim forKey:@"slideToUnlockAnimation"];
	
	swipeToUnlockTextLayer.mask = maskLayer;
	
	[self.view.layer addSublayer:swipeToUnlockTextLayer];
}

- (UIFont *)labelFont
{
	return [UIFont fontWithName:@"Avenir-Medium" size:16.0];
}

@end
