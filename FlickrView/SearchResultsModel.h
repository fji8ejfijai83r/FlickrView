//
//  SearchResultsModel.h
//  FlickrView
//
//  Created by HD hiessu on 11-3-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Three20/Three20.h>

@protocol SearchResultsModel <TTModel>

@property (nonatomic, readonly) NSArray *results;                           // A list of domain objects constructed by the model after parsing the web service's HTTP response. In this case, it is a list of SearchResult objects.
@property (nonatomic, readonly) NSUInteger totalResultsAvailableOnServer;   // The total number of results available on the server (but not necessarily downloaded) for the current model configuration's search query.

@end
