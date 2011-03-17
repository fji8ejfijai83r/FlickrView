//
//  HomePageTableViewController.m
//  FlickrView
//
//  Created by HD hiessu on 11-3-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "HomePageTableViewController.h"
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


enum {
    beforeRowAuthorize,
    beforeRowExplore,
    beforeRowNearyby,
    beforeRowSearch
};

enum {
	afterRowYou,
	afterRowContacts,
	afterRowUpload,
	afterRowExplore,
	afterRowNearby,
	afterRowSearch
};


@interface HomePageTableViewController (PrivateMethods)
- (BOOL)isAuthorized;
- (void)updateUserInterface:(NSNotification *)notification;
@end

@implementation HomePageTableViewController
@synthesize showList = _showList;

- (id)init
{
    self = [self initWithStyle:UITableViewStyleGrouped];    
	if (self) {
        // Custom initialization
        self.navigationItem.title = @"Flick View";
		
    }
    return self;
}

#pragma mark -
#pragma mark GETTER method, will call using self.xxx
- (NSArray *)showList
{
	if (!_showList) {
		_showList = [[NSArray alloc] initWithObjects:
					 @"Authorize with Flickr", @"Explore", @"Nearby", @"Search", nil];
	}
	return _showList;
}

- (void)dealloc
{
    [_showList release];
	[super dealloc];
}

- (BOOL)isAuthorized
{
	return [[FlickrViewAppDelegate sharedDelegate].flickrContext.authToken length];
}
- (void)updateUserInterface:(NSNotification *)notification
{
	if ([self isAuthorized]) {
		_showList = [[NSArray alloc] initWithObjects:@"You", @"Contacts", @"Upload", @"Eplore", @"Nearby", @"Search", nil];
	}
	if ([[FlickrViewAppDelegate sharedDelegate].flickrUserName length]) {
		self.navigationItem.title = [FlickrViewAppDelegate sharedDelegate].flickrUserName;
	}
	else {
		self.navigationItem.title = @"You";
	}
	[self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInterface:) name:SnapAndRunShouldUpdateAuthInfoNotification object:nil];
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.showList = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationItem.title = [FlickrViewAppDelegate sharedDelegate].flickrUserName;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
#define SECTION_0	0

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (SECTION_0 == section) 
		return self.showList.count;
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if (indexPath.section == 0) {
		cell.textLabel.text = [self.showList objectAtIndex:indexPath.row];
		if ([cell.textLabel.text isEqual:@"Authorize with Flickr"]) return cell;	
	} else {
		cell.textLabel.text = @"Settings";
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    
    return cell;
}

- (void)popUpForAuthorize:(NSIndexPath *)indexPath
{
	//	[[[UIAlertView alloc] initWithTitle:@"Notice" 
	//								 message:@"Flickr" 
	//								delegate:nil 
	//					   cancelButtonTitle:@"Cancel" 
	//					   otherButtonTitles:@"OK"] show];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	cell.textLabel.text = @"Logging in...";
	NSURL *loginURL = [[FlickrViewAppDelegate sharedDelegate].flickrContext 
					   loginURLFromFrobDictionary:nil requestedPermission:OFFlickrWritePermission];
	[[UIApplication sharedApplication] openURL:loginURL];
}

- (void)showExploreScreen
{
	[[TTURLRequestQueue mainQueue] setMaxContentLength:0];
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	SearchResultsPhotoSource *photoSource = [[SearchResultsPhotoSource alloc] 
					   initWithModel:[[[FlickrSearchResultsModel alloc] init] autorelease]];
	[photoSource load:TTURLRequestCachePolicyDefault more:NO];
	TTThumbsViewController *thumbs = [[MyThumbsViewController alloc] initForPhotoSource:photoSource];
	//SearchTableViewController *thumbs = [[SearchTableViewController alloc] init];
	thumbs.tabBarItem.image = [UIImage imageNamed:@"all.png"];
	thumbs.title = @"Top Rated";
	//psltv.managedObjectContext = self.managedObjectContext;
	//psltv.flickrContext = [FlickrViewAppDelegate sharedDelegate].flickrContext;
	tabBarController.viewControllers = [NSArray arrayWithObjects:thumbs, nil];
	tabBarController.title = @"Explore";
	[self.navigationController pushViewController:tabBarController animated:YES];
	[thumbs release];
	[tabBarController release];
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
	UserPhotosTableViewController *uptvc = [[UserPhotosTableViewController alloc] init];
	uptvc.title = @"Photos";
	uptvc.userName = @"me";
	UserContactsTableViewController *uctvc = [[UserContactsTableViewController alloc] init];
	uctvc.title = @"Contacts";
	tabBarController.viewControllers = [NSArray arrayWithObjects:uptvc, uctvc, nil];
	[self.navigationController pushViewController:tabBarController animated:YES];
	[uptvc release];
	[uctvc release];
	[tabBarController release];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.navigationItem.title = @"Home";
	if ([self isAuthorized] && indexPath.section == 0) {
		switch (indexPath.row) {
			case afterRowYou:
				[self showUserScreen];
				break;
			case afterRowContacts:
				break;
			case afterRowUpload:
				[self showUploadScreen];
				break;
			case afterRowExplore:
				[self showExploreScreen];
				break;
		}
	} 
	if (![self isAuthorized] && indexPath.section == 0) {
		switch (indexPath.row) {
			case beforeRowAuthorize:
				[self popUpForAuthorize:indexPath];
				break;
			case beforeRowExplore:
				[self showExploreScreen];
				break;
		}
	}
}

@end
