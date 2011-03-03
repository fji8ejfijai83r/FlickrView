//
//  PhotoSpotsListTableViewController.m
//  FlickrView
//
//  Created by HD hiessu on 10-12-29.
//  Copyright 2010 HD. All rights reserved.
//

#import "FlickrFetcher.h"
#import "PhotoSpotsListTableViewController.h"
#import "PhotosListTableViewController.h"
#import "TopPlaceTableViewController.h"
#import "Photo.h"

@implementation PhotoSpotsListTableViewController


#pragma mark -
#pragma mark Initialization



#pragma mark -
#pragma mark protocol
- (id)makeKey:(NSDictionary *)aDic;
{
	return [[aDic objectForKey:@"_text"] substringToIndex:1];
}

- (NSArray *)rawData
{
	return [FlickrFetcher topPlaces];
}


- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	if (![flickrRequest isRunning]) {
		[flickrRequest callAPIMethodWithGET:@"flickr.places.getTopPlacesList" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"7", @"place_type_id", nil]];
	}
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}


- (NSString *)placeInfo:(NSIndexPath *)indexPath
{
	return [[self dataInfo:indexPath] objectForKey:@"_text"];
}

- (NSString *)placeName:(NSIndexPath *)indexPath
{
	NSString *aPlaceInfo = [self placeInfo:indexPath];
	NSRange range = [aPlaceInfo rangeOfString:@","];
	if (range.location == NSNotFound) return aPlaceInfo;
	return [aPlaceInfo substringToIndex:range.location];  
}

-(NSString *)placeDetailInfo:(NSIndexPath *)indexPath
{
	NSString *aPlaceInfo= [self placeInfo:indexPath];
	NSRange range = [aPlaceInfo rangeOfString:@", "];
	if (range.location == NSNotFound) return aPlaceInfo;
	return [aPlaceInfo substringFromIndex:range.location + 2]; 	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"SpotsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:CellIdentifier] autorelease];
    }

    //self.data will perform data setter that load data from web, so far cannot find better way
    if (indexPath.row == 0 && !data)
	{
        cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
		cell.detailTextLabel.text = @"载入中…";
		
		return cell;
    }
    
    if (data > 0) {
        cell.textLabel.text = [self placeName:indexPath];
        cell.detailTextLabel.text = [self placeDetailInfo:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [self.sections objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	return self.sections;
}


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
	PhotosListTableViewController *pltvc= [[PhotosListTableViewController alloc] init];
	pltvc.photoId = [[self dataInfo:indexPath] objectForKey:@"place_id"];
	pltvc.placeName = [self placeInfo:indexPath];
	pltvc.managedObjectContext = self.managedObjectContext;
	pltvc.title = [self placeName:indexPath];
	[self.navigationController pushViewController:pltvc animated:YES];
	[pltvc release];
	
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
}


- (void)dealloc {
    [super dealloc];
}


@end

