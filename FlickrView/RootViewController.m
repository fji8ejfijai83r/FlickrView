//
//  RootViewController.m
//  FlickrView
//
//  Created by HD hiessu on 11-4-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "FlickrViewAppDelegate.h"
#import "PhotoSpotsListTableViewController.h"
#import "SnapAndRunViewController.h"
#import "UserPhotosTableViewController.h"
#import "UserContactsTableViewController.h"
#import "Three20/Three20.h"
#import "SearchResultsPhotoSource.h"
#import "FlickrSearchResultsModel.h"
#import "ForwardingAdapters.h"
#import "SearchTableViewController.h"
#import "SearchBarController.h"

@interface RootViewController()
- (BOOL)isAuthorized;
- (void)updateUserInterface:(NSNotification *)notification;
- (void)popUpForAuthorize:(NSIndexPath *)indexPath;
@end

@interface rootViewSectionedDataSource : TTSectionedDataSource
@end

@implementation rootViewSectionedDataSource

- (void)tableView:(UITableView *)tableView cell:(UITableViewCell *)cell willAppearAtIndexPath:(NSIndexPath *)indexPath 
{
	if ([cell.textLabel.text isEqual:@"Authorize with Flickr"]) return;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
}

@end


@implementation RootViewController

- (id)init
{
    self = [self initWithStyle:UITableViewStyleGrouped];    
	if (self) {
		self.navigationItem.title = @"Home";
		self.hidesBottomBarWhenPushed = YES;
		self.navigationBarTintColor = nil;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInterface:) name:SnapAndRunShouldUpdateAuthInfoNotification object:nil];
    }
    return self;
} 

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (BOOL)isAuthorized
{
	return [[FlickrViewAppDelegate sharedDelegate].flickrContext.authToken length];
}

- (void)setNavigationTitle
{
	if ([[FlickrViewAppDelegate sharedDelegate].flickrUserName length]) {
		self.navigationItem.title = [FlickrViewAppDelegate sharedDelegate].flickrUserName;
	} else {
		self.navigationItem.title = @"You";
	}
}

- (void)updateUserInterface:(NSNotification *)notification
{
	[self setNavigationTitle];
	[self createModel];
	[self reload];
}


- (void)updateTableLayout {
	self.tableView.contentInset = UIEdgeInsetsMake(TTBarsHeight()+4, 0, 0, 0);
	self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(TTBarsHeight(), 0, 0, 0);
}

- (void)viewDidLoad
{
	[self updateTableLayout];
	[self createModel];
	[self reload];
	[super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self setNavigationTitle];
	self.statusBarStyle = UIStatusBarStyleBlackTranslucent;
	self.navigationBarStyle = UIBarStyleBlackTranslucent;
	self.wantsFullScreenLayout = YES;
	[super viewWillAppear:animated];
}

- (NSArray *)topItems
{
	NSArray *result = [NSArray arrayWithObjects:
						[TTTableTextItem itemWithText:@"Authorize with Flickr" URL:@"/authorize"],
						[TTTableTextItem itemWithText:@"Explore" URL:@"/explore"],
						[TTTableTextItem itemWithText:@"Search" URL:@"/search"],
						//[TTTableTextItem itemWithText:@"Nearby" URL:@"/Nearby"],
						nil];
	if ([self isAuthorized]) {
		NSArray *addItems = [NSArray arrayWithObjects:
				 [TTTableTextItem itemWithText:@"You" URL:@"/you"],
				 [TTTableTextItem itemWithText:@"Contacts" URL:@"/contacts"],
				 [TTTableTextItem itemWithText:@"Upload" URL:@"/upload"],
				 nil];
		return [addItems arrayByAddingObjectsFromArray:
						[result subarrayWithRange:NSMakeRange(1, result.count - 1)]];
	}
	return result;
}

- (void)createModel
{
	NSArray *topItems = [self topItems];
	NSArray *settingsItems = [NSArray arrayWithObjects:[TTTableTextItem itemWithText:@"Settings" URL:@"/settings/"], nil];

	self.dataSource = [rootViewSectionedDataSource dataSourceWithArrays:@"", topItems, @"", settingsItems, nil];
}

#pragma mark table view delegate stuff
- (void)tableView:(UITableView *)tableView cell:(UITableViewCell *)cell willAppearAtIndexPath:(NSIndexPath *)indexPath 
{
	//if (indexPath.section == 0 && indexPath.row == 0) return;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self updateTableLayout];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)popUpForAuthorize:(NSIndexPath *)indexPath
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" 
													message:@"FlickrView will popup safari to login flickr, please make sure"
												   delegate:self 
										  cancelButtonTitle:@"Cancel" 
										  otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
	//	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	//	cell.textLabel.text = @"Logging in...";
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(buttonIndex != alertView.cancelButtonIndex) {
		NSURL *loginURL = [[FlickrViewAppDelegate sharedDelegate].flickrContext 
						   loginURLFromFrobDictionary:nil requestedPermission:OFFlickrWritePermission];
		[[UIApplication sharedApplication] openURL:loginURL];
	}
}

- (void)showExploreScreen
{
	//UITabBarController *tabBarController = [[UITabBarController alloc] init];
	
	TTThumbsViewController *thumbs = [[MyExploreThumbsViewController alloc] init];
	
	//thumbs.tabBarItem.image = [UIImage imageNamed:@"all.png"];
	thumbs.title = @"Explore";
	
	//tabBarController.viewControllers = [NSArray arrayWithObjects:thumbs, nil];
	//tabBarController.title = @"Explore";
	[self.navigationController pushViewController:thumbs animated:YES];
	[thumbs release];
	//[tabBarController release];
}

- (void)showUploadScreen
{
	SnapAndRunViewController *uvc = [[SnapAndRunViewController alloc] init];
	[self.navigationController pushViewController:uvc animated:YES];
	[uvc release];
}

- (void)showUserScreen
{
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	MyPhotoThumbsViewController *mptvc = [[MyPhotoThumbsViewController alloc] initWithName:@"me"];
	mptvc.title = @"My Photos";
	//mptvc.userName = @"me";
	UserContactsTableViewController *uctvc = [[UserContactsTableViewController alloc] init];
	uctvc.title = @"Contacts";
	tabBarController.viewControllers = [NSArray arrayWithObjects:mptvc, uctvc, nil];
	[self.navigationController pushViewController:tabBarController animated:YES];
	[mptvc release];
	[uctvc release];
	[tabBarController release];
}

- (void)showContactsScreen
{	
	//UITabBarController *tabBarController = [[UITabBarController alloc] init];
	SearchTableViewController *mcrtvc = 
	[[SearchTableViewController alloc] init];
	
	mcrtvc.title = @"Contacts";
	//tabBarController.viewControllers = [NSArray arrayWithObjects:mcrtvc, nil];
	[self.navigationController pushViewController:mcrtvc animated:YES];
	[mcrtvc release];
	//[tabBarController release];
}

- (void)showSearchScreen
{	
	SearchBarController *thumbs = [[SearchBarController alloc] init];
	
	[self.navigationController pushViewController:thumbs animated:YES];
	[thumbs release];	
}

- (void)didSelectObject:(TTTableLinkedItem *)object atIndexPath:(NSIndexPath*)indexPath
{
	if ([object.URL isEqual:@"/authorize"]) {
		[self popUpForAuthorize:indexPath];
	} else if ([object.URL isEqual:@"/explore"]) {
		[self showExploreScreen];
	} else if ([object.URL isEqual:@"/search"]) {
		[self showSearchScreen];
	} else if ([object.URL isEqual:@"/you"]) {
		[self showUserScreen];
	} else if ([object.URL isEqual:@"/contacts"]) {
		[self showContactsScreen];
	} else if ([object.URL isEqual:@"/upload"]) {
		[self showUploadScreen];
	}
	return;
}
@end
