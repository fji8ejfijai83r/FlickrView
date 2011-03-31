//
//  ForwardingAdapters.h
//  TTRemoteExamples
//
//  Created by Keith Lazuka on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Three20/Three20.h"
#import "FlickrSearchResultsModel.h"

/*
 *  HACK:
 *
 *      The TTModel system does not expect that your TTPhotoSource implementation
 *      is actually forwarding to another object that implements the TTModel aspect
 *      of the TTPhotoSource protocol. So we must ensure that the TTModelViewController's
 *      notion of what its model is matches the object that it will receive
 *      via the TTModelDelegate messages.
 */

@class SearchResultsPhotoSource;

@interface MyPhotoViewController : TTPhotoViewController
{
	id <TTModel> realModel;
}
@property (nonatomic,retain) id <TTModel> realModel;
@end

@interface MyBaseThumbsViewController : TTThumbsViewController
{
	id <TTModel> realModel;
}

@end

@interface MyThumbsViewController : MyBaseThumbsViewController <FlickrSearchResultsModelDelegate>

@end


@interface MyExploreThumbsViewController : MyThumbsViewController

@end

@interface MyPhotoThumbsViewController : MyThumbsViewController

@end

@interface MyContactsRecentThumbsViewController : MyThumbsViewController


@end

@interface MySearchThumbsViewController : MyBaseThumbsViewController 

- (id)initForPhotoSource:(SearchResultsPhotoSource *)source;

@end


@interface MyThumbsDataSource : TTThumbsDataSource
{}
@end
