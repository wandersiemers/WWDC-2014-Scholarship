//
//  WSProject.h
//  Wander Siemers
//
//  Created by Ronald Siemers on 05-04-14.
//  Copyright (c) 2014 Wander Siemers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSProject : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *humanReadableTitle;
@property (nonatomic, strong) UIImage *smallBackgroundImage;
@property (nonatomic, strong) UIImage *projectImage;
@property (nonatomic, copy) NSString *bodyText;
@property (nonatomic, strong) NSNumber *itunesIdentifier;

- (instancetype)initWithTitle:(NSString *)title
		   humanReadableTitle:(NSString *)humanReadableTitle
		 smallBackgroundImage:(UIImage *)smallBackgroundImage
				 projectImage:(UIImage *)projectImage
					 bodyText:(NSString *)bodyText
			 itunesIdentifier:(NSNumber *)itunesIdentifier;

@end
