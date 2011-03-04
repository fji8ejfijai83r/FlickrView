//
//  UserPhotosTableViewController.m
//  FlickrView
//
//  Created by HD hiessu on 11-3-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserTableViewController.h"
#import "FlickrViewAppDelegate.h"

@implementation UserTableViewController

@synthesize flickrRequest = _flickrRequest;
#pragma mark -
#pragma mark View lifecycle

- (NSString *)apiMethod
{
	return nil;
}

- (NSDictionary *)argumentsForApiMethod
{
	return nil;
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
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (![self.flickrRequest isRunning]) {
		[self.flickrRequest callAPIMethodWithGET:[self apiMethod] 
									   arguments:[self argumentsForApiMethod]];	
	}
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

//#define kCustomRowCount 8
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
//{
//	if (self.photosData)
//		return self.photosData.count;
//    else 
//		return kCustomRowCount;
//}



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
	self.flickrRequest = nil;
}


- (void)dealloc {
	[_flickrRequest release];
    [super dealloc];
}


@end

