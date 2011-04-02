//
//  SearchTableViewController.h
//

#import "FlickrSearchResultsModel.h"

/*
 *      SearchTableViewController
 *      ------------------------
 *
 *  This view controller manages a UITableView that will
 *  display Yahoo or Flickr image search results. 
 *
 */
@interface SearchTableViewController : TTTableViewController 
<UISearchBarDelegate,FlickrSearchResultsModelDelegate>
{
}

@end

