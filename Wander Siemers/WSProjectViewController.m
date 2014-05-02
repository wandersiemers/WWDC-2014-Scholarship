//
//  WSProjectViewController.m
//  Wander Siemers
//
//  Created by Ronald Siemers on 04-04-14.
//  Copyright (c) 2014 Wander Siemers. All rights reserved.
//

#import "WSProjectViewController.h"
#import "UIImage+ImageEffects.h"
@import StoreKit;

@interface WSProjectViewController () <UITextViewDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) CGPoint originalImageOrigin;

@end

@implementation WSProjectViewController

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	self.originalImageOrigin = self.imageView.frame.origin;
	[self updateExclusionPaths];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if (!self.project) {
		[NSException raise:@"Project variable is nil" format:@"A project view controller doesn't make sense without a project, does it?"];
	}
	
	CGRect frame = self.imageView.frame;
	self.imageView.image = self.project.projectImage;
	self.imageView.frame = frame;
	[self.imageView setContentMode:UIViewContentModeScaleAspectFill];
	self.imageView.layer.masksToBounds = YES;
	self.imageView.clipsToBounds = YES;
	self.backgroundImageView.image = [self.project.projectImage applyLightEffect];
	
	self.textView.editable = NO;
	self.textView.delegate = self;
	self.textView.text = self.project.bodyText;
		
	if (self.project.itunesIdentifier) {
		UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"App Store"
																 style:UIBarButtonItemStylePlain
																target:self
																action:@selector(tappedAppStoreButton:)];
		self.navigationItem.rightBarButtonItem = item;
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	self.imageView.frame = CGRectMake(self.originalImageOrigin.x + scrollView.contentOffset.x,
									  self.originalImageOrigin.y + self.imageView.bounds.origin.y - scrollView.contentOffset.y,
									  self.imageView.frame.size.width,
									  self.imageView.frame.size.height);
}

- (void)updateExclusionPaths
{
	CGRect rect = [self.textView convertRect:self.imageView.bounds fromView:self.imageView];
	UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:rect];
	
	self.textView.textContainer.exclusionPaths = @[bezierPath];
}

- (void)tappedAppStoreButton:(id)sender
{
	NSLog(@"executing %@", NSStringFromSelector(_cmd));
	SKStoreProductViewController *productVC = [[SKStoreProductViewController alloc] init];
	[self presentViewController:productVC animated:YES completion:^{
		[productVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: self.project.itunesIdentifier}
							 completionBlock:^(BOOL result, NSError *error) {
			if (error.code == 5) {
				NSLog(@"This functionality (show the App Store page for this app) doesn't work in the iOS Simulator");
			}
		}];
	}];
	
}

@end
