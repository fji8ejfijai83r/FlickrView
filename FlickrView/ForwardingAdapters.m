//
//  ForwardingAdapters.m
//  TTRemoteExamples
//
//  Created by Keith Lazuka on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ForwardingAdapters.h"
#import "SearchResultsPhotoSource.h"
#import "SearchResultsModel.h"
#import "FlickrSearchResultsModel.h"

@implementation MyPhotoViewController

@synthesize realModel;

- (void)setModel:(id<TTModel>)m { [super setModel:realModel]; }

- (void)dealloc
{
	[realModel release];
	[super dealloc];
}

@end

@implementation MyThumbsViewController

- (id)initForPhotoSource:(SearchResultsPhotoSource *)source;
{
	return [self init];
}

- (id)init
{
	if ((self = [super init])) {
		FlickrSearchResultsModel *fsrm = [[[FlickrSearchResultsModel alloc] init] autorelease];
		fsrm.delegate = self;
		SearchResultsPhotoSource *source = [[SearchResultsPhotoSource alloc] 
					initWithModel:fsrm];
		realModel = [[source underlyingModel] retain];
		self.photoSource = source;
	}
	return self;
}

- (void)dealloc
{
	[realModel release];
	//[[TTURLCache sharedCache] removeAll:YES];
	[super dealloc];
}

- (void)setModel:(id<TTModel>)m { [super setModel:realModel]; }

- (TTPhotoViewController*)createPhotoViewController
{
	MyPhotoViewController *vc = [[[MyPhotoViewController alloc] init] autorelease];
	vc.realModel = realModel;
	return vc;
}

- (id<TTTableViewDataSource>)createDataSource {
	return [[[MyThumbsDataSource alloc] initWithPhotoSource:_photoSource delegate:self] autorelease];
}

#pragma mark -
#pragma mark FlickrSearchResultsModelDelegate
- (NSString *)apiMethod
{
	return @"flickr.interestingness.getList";
}

- (NSDictionary *)argumentsForApiMethod
{
	return nil;
}
@end


@implementation MySearchThumbsViewController

- (id)initForPhotoSource:(SearchResultsPhotoSource *)source
{
	if ((self = [super init])) {		
		realModel = [[source underlyingModel] retain];
		self.photoSource = source;
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

@end

@implementation MyThumbsDataSource

- (id<TTModel>)model
{
	return [(SearchResultsPhotoSource*)_photoSource underlyingModel];
}

@end
