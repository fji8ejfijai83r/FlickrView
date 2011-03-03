//
//  TopPlaceTableViewController.m
//  Flickr V beta 0.2
//
//  Created by HD hiessu on 11-1-15.
//  Copyright 2011 HD. All rights reserved.
//

#import "TopPlaceTableViewController.h"
#import "FlickrFetcher.h"
#import "ObjectiveFlickr.h"
#import "FlickrAPIKey.h"

#define kCustomRowCount     8

@implementation TopPlaceTableViewController

@synthesize data, sections;
@synthesize managedObjectContext;
@synthesize flickrContext;

#pragma mark -
#pragma mark Initialization



#pragma mark -
#pragma mark protocol

NSString *TableViewUpdateNotification = @"TableViewUpdateNotification";

- (id)init
{
	if ((self = [super init])) {
		flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OBJECTIVE_FLICKR_SAMPLE_API_KEY sharedSecret:OBJECTIVE_FLICKR_SAMPLE_API_SHARED_SECRET];
		flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
		[flickrRequest setDelegate:self];
	}
	return self;
}

- (id)makeKey:(NSDictionary *)aDic;
{
	return nil;
}

- (NSArray *)rawData
{
	return nil;
}

- (NSDictionary *)makeTableViewData
{
	NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionary];
	NSArray *rawData = [self rawData];
	//NSLog(@"%@", rawData);

	for (id aData in rawData) {
		id key = [self makeKey:aData];
		// if an array already exists in the name index dictionary
		// simply add the element to it, otherwise create an array
		// and add it to the name index dictionary with the letter as the key
		NSMutableArray *existingArray;
		if ((existingArray = [tempDictionary objectForKey:key])) {
			[existingArray addObject:aData];
		} else {
			NSMutableArray *tempArray = [NSMutableArray array];
			[tempDictionary setObject:tempArray forKey:key];
			[tempArray addObject:aData];
		}
	}
	return tempDictionary;
}

- (NSDictionary *)makeTableViewDataEx:(NSArray *)rawData
{
	NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionary];
	for (id aData in rawData) {
		id key = [self makeKey:aData];
		// if an array already exists in the name index dictionary
		// simply add the element to it, otherwise create an array
		// and add it to the name index dictionary with the letter as the key
		NSMutableArray *existingArray;
		if ((existingArray = [tempDictionary objectForKey:key])) {
			[existingArray addObject:aData];
		} else {
			NSMutableArray *tempArray = [NSMutableArray array];
			[tempDictionary setObject:tempArray forKey:key];
			[tempArray addObject:aData];
		}
	}
	return tempDictionary;
}

#pragma mark -
- (NSMutableDictionary *)data
{
	if (!data) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        dispatch_queue_t downloader = dispatch_queue_create("data downloader", NULL);
		dispatch_async(downloader, ^{
			data = [[self makeTableViewData] retain];
			dispatch_async(dispatch_get_main_queue(), ^{
				[[self tableView] reloadData];
				[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			});
		});
	dispatch_release(downloader);
	}
	return data;
}

- (NSArray *)sections
{
    if (!sections) {
		sections = [[[data allKeys] sortedArrayUsingSelector:@selector(compare:)] retain];
	}
	return sections;
}

#pragma mark -
#pragma mark View lifecycle


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return self.sections ? self.sections.count : 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSArray *dataInSection = [data objectForKey:[self.sections objectAtIndex:section]];
    
    int count = dataInSection.count;
    
    if (count == 0)
        count = kCustomRowCount;
    
    return count;
}


- (NSDictionary *)dataInfo:(NSIndexPath *)indexPath
{
	NSArray *placesInSection = [self.data objectForKey:[self.sections objectAtIndex:indexPath.section]];
	return [placesInSection objectAtIndex:indexPath.row];
}

- (void)updateTableView
{
	[[self tableView] reloadData];
}

- (void)viewDidLoad
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(updateTableView) 
												 name:TableViewUpdateNotification 
											   object:nil];
}

- (void)viewDidUnload
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:TableViewUpdateNotification
												  object:nil];
}

- (void)dealloc {
	[flickrContext release];
	[flickrRequest release];
	[data release];
	[sections release];
    [super dealloc];
}

#pragma mark -
#pragma mark OFFlickrAPIRequestDelegate
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSArray *rawData = [[inResponseDictionary objectForKey:@"places"] objectForKey:@"place"];
	//NSLog(@"%@", rawData);
	[data release];
	data = [[self makeTableViewDataEx:rawData] retain];
	//[[NSNotificationCenter defaultCenter] postNotificationName:TableViewUpdateNotification object:self];
	[self updateTableView];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
	NSLog(@"%s", inError);
}

@end

