//
//  WSProject.m
//  Wander Siemers
//
//  Created by Ronald Siemers on 05-04-14.
//  Copyright (c) 2014 Wander Siemers. All rights reserved.
//

#import "WSProject.h"

@implementation WSProject

- (instancetype)initWithTitle:(NSString *)title
		   humanReadableTitle:(NSString *)humanReadableTitle
		 smallBackgroundImage:(UIImage *)smallBackgroundImage
				 projectImage:(UIImage *)projectImage
					 bodyText:(NSString *)bodyText
			 itunesIdentifier:(NSNumber *)itunesIdentifier
{
	NSParameterAssert(title != nil);
	NSParameterAssert(humanReadableTitle != nil);
	NSParameterAssert(smallBackgroundImage != nil);
	NSParameterAssert(projectImage != nil);
	NSParameterAssert(bodyText != nil);
	
	self = [super init];
	if (self) {
		_title = title;
		_humanReadableTitle = humanReadableTitle;
		_smallBackgroundImage = smallBackgroundImage;
		_projectImage = projectImage;
		_bodyText = bodyText;
		_itunesIdentifier = itunesIdentifier;
	}
	return self;
}

@end
