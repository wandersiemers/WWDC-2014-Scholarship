//
//  WSProjectViewController.h
//  Wander Siemers
//
//  Created by Ronald Siemers on 04-04-14.
//  Copyright (c) 2014 Wander Siemers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSProject.h"

@interface WSProjectViewController : UIViewController

@property (nonatomic, strong) WSProject *project;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end
