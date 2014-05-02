//
//  WSTimelineViewController.m
//  Wander Siemers
//
//  Created by Ronald Siemers on 03-04-14.
//  Copyright (c) 2014 Wander Siemers. All rights reserved.
//

#import "WSTimelineViewController.h"
#import "WSTimelineTableViewCell.h"
#import "UIColor+WSAppColors.h"
#import "WSProjectViewController.h"
#import "WSProject.h"
#import "WSProjectAnimationController.h"

@interface WSTimelineViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, readonly) NSArray *humanReadableTitles;
@property (nonatomic, readonly) NSArray *projectNames;
@property (nonatomic, readonly) NSArray *smallBackgroundImageNames;
@property (nonatomic, readonly) NSArray *projectImageNames;
@property (nonatomic, copy) NSArray *projects;

@end

@implementation WSTimelineViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.navigationController.navigationBar.barTintColor = [UIColor WSBlueColor];
	self.navigationController.navigationBar.translucent = NO;
	[self setNeedsStatusBarAppearanceUpdate];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	NSMutableArray *projects = [NSMutableArray array];
	for (int i = 0; i < [self numberOfProjects]; i++) {
		NSString *projectName = self.projectNames[i];
		NSString *filePath = [[NSBundle mainBundle] pathForResource:projectName ofType:nil];
		NSError *error;
		NSString *bodyText = [NSString stringWithContentsOfFile:filePath
													   encoding:NSUTF8StringEncoding
														  error:&error];
		
		if (error) {
			NSLog(@"error %@", error);
			[NSException raise:@"Couldn't find text file" format:@"Error %@", error];
			return;
		}
		
		WSProject *project = [[WSProject alloc] initWithTitle:projectName
										   humanReadableTitle:self.humanReadableTitles[i]
										 smallBackgroundImage:[UIImage imageNamed:self.smallBackgroundImageNames[i]]
												 projectImage:[UIImage imageNamed:self.projectImageNames[i]]
													 bodyText:bodyText
												  itunesIdentifier:[self itunesIdentifierForProjectName:projectName]];
		
		[projects addObject:project];
	}
	
	self.projects = projects;
	[self.tableView reloadData];
	
	self.navigationController.delegate = self;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	WSTimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	if (!cell) {
		cell = [[WSTimelineTableViewCell alloc] init];
	}
	
	NSInteger index = indexPath.row;
	WSProject *project = (WSProject *)self.projects[index];
	cell.titleLabel.text = self.humanReadableTitles[indexPath.row];
	cell.backgroundImageView.image = project.smallBackgroundImage;
	NSAssert(cell.backgroundImageView.image != nil, @"Couldn't initialize image");
	cell.titleLabel.textColor = [self tableViewCellTextColorForProjectName:project.title];
	return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
	WSProjectViewController *projectVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
										  instantiateViewControllerWithIdentifier:@"project"];
	
	projectVC.project = self.projects[indexPath.row];
	[self.navigationController pushViewController:projectVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self numberOfProjects];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

- (NSArray *)projectNames
{
	static NSArray *names;
	if (!names) {
		names = @[@"timeout", @"kroeghamster", @"vossius", @"techtalks", @"q42", @"aboutme"];
	}
	return names;
}

- (NSArray *)humanReadableTitles
{
	static NSArray *titles;
	if (!titles) {
		titles = @[@"Time Out", @"Kroeghamster", @"Vossius", @"Tech Talks", @"Q42", @"About me"];
	}
	return titles;
}


- (NSArray *)smallBackgroundImageNames
{
	return self.projectNames;
}

- (NSArray *)projectImageNames
{
	static NSMutableArray *projectImageNames;
	if (!projectImageNames) {
		
		projectImageNames = [NSMutableArray array];
		[self.projectNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			if ([obj isKindOfClass:[NSString class]]) {
				NSString *projectName = (NSString *)obj;
				[projectImageNames addObject:[projectName stringByAppendingString:@"_big"]];
			}
		}];
	}
	return [projectImageNames copy];
}

- (NSInteger)numberOfProjects
{
	return 6;
}

- (UIColor *)tableViewCellTextColorForProjectName:(NSString *)name
{
	if ([name isEqualToString:@"kroeghamster"]) {
		return [UIColor blackColor];
	} else if ([name isEqualToString:@"q42"]) {
		return [UIColor WSGreenColor];
	} else {
		return [UIColor whiteColor];
	}
}

- (NSNumber *)itunesIdentifierForProjectName:(NSString *)name
{
	if ([name isEqualToString:@"timeout"]) {
		return @741597471;
	} else if ([name isEqualToString:@"vossiapp"]) {
		return @793983890;
	}
	return nil;
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
								  animationControllerForOperation:(UINavigationControllerOperation)operation
											   fromViewController:(UIViewController *)fromVC
												 toViewController:(UIViewController *)toVC
{
	WSProjectAnimationController *animationController = [[WSProjectAnimationController alloc] init];
	if (operation == UINavigationControllerOperationPop) {
		animationController.reverse = YES;
	}
	return animationController;
}

@end
