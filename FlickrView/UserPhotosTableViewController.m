//
//  UserPhotosTableViewController.m
//  FlickrView
//
//  Created by HD hiessu on 11-3-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserPhotosTableViewController.h"
#import "FlickrViewAppDelegate.h"

@interface UserPhotosTableViewController()
@property (nonatomic, retain) NSArray *photosData;
@property (nonatomic, retain) OFFlickrAPIRequest *flickrRequest;
@end

@implementation UserPhotosTableViewController

@synthesize userName = _userName;
@synthesize photosData = _photosData;
@synthesize flickrRequest = _flickrRequest;
#pragma mark -
#pragma mark View lifecycle

- (NSString *)apiMethod
{
	return @"flickr.people.getPhotos";
}

- (NSDictionary *)argumentsForApiMethod
{
	return [NSDictionary dictionaryWithObjectsAndKeys:@"me", @"user_id", nil];
}

- (id)init
{
	if ((self = [super init])) {
		_flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[FlickrViewAppDelegate sharedDelegate].flickrContext];
		[_flickrRequest setDelegate:self];
	}
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	self.tabBarController.navigationItem.title = self.userName;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

#define kCustomRowCount 8
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (self.photosData)
		return self.photosData.count;
    else 
		return kCustomRowCount;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"photoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:CellIdentifier] autorelease];
    }
	
    //self.data will perform data setter that load data from web, so far cannot find better way
	if (!self.photosData && indexPath.row == 0)
	{
        cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.detailTextLabel.text = @"载入中…";
		return cell;
	}
    if (self.photosData) {
        NSDictionary *photoDict = [self.photosData objectAtIndex:indexPath.row];
		NSString *title = [photoDict objectForKey:@"title"];
		if (![title length]) {
			title = @"No title";
		}
		cell.textLabel.text = title;
		cell.detailTextLabel.text = nil;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		//NSURL *photoURL = [flickrContext photoSourceURLFromDictionary:photoDict size:OFFlickrSmallSquareSize];

    }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[super viewDidLoad];
	self.userName = nil;
	self.photosData = nil;
	self.flickrRequest = nil;
}


- (void)dealloc {
	[_userName release];
	[_photosData release];
	[_flickrRequest release];
    [super dealloc];
}

#pragma mark -
#pragma mark OFFlickrAPIRequestDelegate
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSArray *rawPhotosData = [inResponseDictionary valueForKeyPath:@"photos.photo"];
	self.photosData = rawPhotosData;
	[self.tableView reloadData];
	
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
	NSLog(@"%s", inError);
}

@end

