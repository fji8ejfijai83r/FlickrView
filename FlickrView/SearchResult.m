//
//  SearchResult.m
//
//  Created by Keith Lazuka on 7/23/09.
//  
//

#import "SearchResult.h"


@implementation SearchResult

@synthesize title, bigImageURL, thumbnailURL, bigImageSize;
@synthesize userid;

- (void)dealloc
{
    [title release];
    [bigImageURL release];
    [thumbnailURL release];
    [userid release];
	[super dealloc];
}

@end
