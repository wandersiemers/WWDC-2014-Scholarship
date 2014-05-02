//
//  WSTimelineTableViewCell.h
//  Wander Siemers
//
//  Created by Ronald Siemers on 03-04-14.
//  Copyright (c) 2014 Wander Siemers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSProject.h"

@interface WSTimelineTableViewCell : UITableViewCell

@property (nonatomic, strong) WSProject *project;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end
