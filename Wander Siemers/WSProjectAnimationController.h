//
//  WSAnimationController.h
//  Wander Siemers
//
//  Created by Ronald Siemers on 05-04-14.
//  Copyright (c) 2014 Wander Siemers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSProjectAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter = isReverse) BOOL reverse;
@property (nonatomic, assign) NSTimeInterval transitionDuration;

@end
