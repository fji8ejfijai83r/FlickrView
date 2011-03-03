//
//  PhotosListTableViewController.m
//  FlickrView
//
//  Created by HD hiessu on 10-12-30.
//  Copyright 2010 HD. All rights reserved.
//

#import "PhotosListTableViewController.h"
#import "PhotoViewController.h"
#import "TopPlaceTableViewController.h"
#import "FlickrFetcher.h"
#import "Photo.h"

@interface PhotosListTableViewController()

@property (copy) NSString *thumbnailURL;
@property (retain) NSMutableDictionary *imageDataDB;

@end

@implementation PhotosListTableViewController

static NSTimeInterval aTimeNowInternal;


@synthesize photoId, placeName;
@synthesize thumbnailURL, imageDataDB;


- (id)makeKey:(NSDictionary *)aDic
{
	NSTimeInterval seconds = aTimeNowInternal - [[aDic objectForKey:@"dateupload"] doubleValue];
	int hours = seconds / 3600 + 1;
	return [NSNumber numberWithInt:hours];
}

- (NSArray *)rawData
{
	return [FlickrFetcher photosAtPlace:photoId];
}

- (id)init
{
	if ((self = [super init])) {
		aTimeNowInternal = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
		imageDataDB = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSString *)photoTitle:(NSIndexPath *)indexPath
{
	NSDictionary *photoInfo = [self dataInfo:indexPath];
	return [photoInfo objectForKey:@"title"];
}

- (NSString *)photoDescription:(NSIndexPath *)indexPath
{
	NSDictionary *photoInfo = [self dataInfo:indexPath];
	return [[photoInfo objectForKey:@"description"] objectForKey:@"_content"];
}

- (void)processThumbnailWithBlock:(NSIndexPath *)indexPath
{
	NSDictionary *photoInfo = [self dataInfo:indexPath];
	NSString *localPhotoId = [photoInfo objectForKey:@"id"];
	NSData *localImageData = [imageDataDB objectForKey:localPhotoId];
	if (localImageData) return;
	NSString *url = 
	[FlickrFetcher urlStringForPhotoWithFlickrInfo:photoInfo format:FlickrFetcherPhotoFormatSquare];
	dispatch_queue_t downloadQueue = dispatch_queue_create("thumbnail dowoloader", NULL);
	dispatch_async(downloadQueue, ^{
		NSData *imageData = [FlickrFetcher imageDataForPhotoWithURLString:url];
		if (imageData) [imageDataDB setObject:imageData forKey:localPhotoId];
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
		});
	});
	dispatch_release(downloadQueue);
}

#pragma mark -
#pragma mark addPhoto using CoreData
- (Photo *)addPhoto:(NSDictionary *)aPhotoInfo
{
	return [Photo photoWithFlickrData:aPhotoInfo withPlaceName:self.placeName inManagedObjectContext:self.managedObjectContext]; 
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PhotoCell";
    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    
    if (indexPath.row == 0 && !self.data)
	{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
        if (cell == nil)
		{
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
										   reuseIdentifier:PlaceholderCellIdentifier] autorelease];   
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
		cell.detailTextLabel.text = @"载入中…";
		
		return cell;
    }

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    if (data > 0) {
        NSString *aPhotoTitle = [self photoTitle:indexPath];
        NSString *aPhotoDetail = [self photoDescription:indexPath];
        if (aPhotoTitle.length == 0 && aPhotoDetail.length == 0) 
            aPhotoTitle = [NSString stringWithString:@"UnKnown"];
        cell.textLabel.text = aPhotoTitle;
        cell.detailTextLabel.text = aPhotoDetail;
        
        NSDictionary *photoInfo = [self dataInfo:indexPath];
        NSString *localPhotoId = [photoInfo objectForKey:@"id"];
        NSData *localImageData = [imageDataDB objectForKey:localPhotoId];
        if (!localImageData) {
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
                [self processThumbnailWithBlock:indexPath];
            }
            cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
        } else {
            cell.imageView.image = [UIImage imageWithData:localImageData];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *titleForHeader;
	if (!self.sections) return NULL;
    int hours = [[self.sections objectAtIndex:section] intValue];
	if (hours == 1) {
		titleForHeader = [NSString stringWithString:@"Right now"];
	} else {
		titleForHeader = [NSString stringWithFormat:@"%d hours ago", hours];
	}
	return titleForHeader;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
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
	PhotoViewController *pvc = [[PhotoViewController alloc] init];
	pvc.photo = [self addPhoto:[self dataInfo:indexPath]];
	//pvc.title = [self photoTitle:indexPath];
	//if (self.pvc.view.window == nil) {
	[self.navigationController pushViewController:pvc animated:YES];
    //}
	[pvc release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)loadImagesForOnscreenRows
{
    if ([data count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
            [self processThumbnailWithBlock:indexPath];
        }
    }
}
#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}



- (void)dealloc {
    //[pvc release];
	[imageDataDB release];
	[placeName release];
	[photoId release];
	[thumbnailURL release];
    [super dealloc];
}

@end

