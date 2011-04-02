//
//  SearchTableViewController.m
//

#import "SearchTableViewController.h"
#import "SearchResultsTableDataSource.h"
#import "SearchResultsModel.h"
#import "FlickrSearchResultsModel.h"
#import "SearchResult.h"
#import "ForwardingAdapters.h"

@implementation SearchTableViewController

- (id)init {
//- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {

    if ((self = [super init])) {
        self.title = @"Table Example";
        
        // Initialize our TTTableViewDataSource and our TTModel.
        id<TTTableViewDataSource> ds = [SearchResultsTableDataSource dataSourceWithItems:nil];
		FlickrSearchResultsModel *fsrm = [[[FlickrSearchResultsModel alloc] init] autorelease];
		fsrm.delegate = self;

		ds.model = fsrm;        
        // By setting the dataSource property, the model property for this
        // class (SearchTableViewController) will automatically be hooked up 
        // to point at the same model that the dataSource points at, 
        // which we just instantiated above.
        self.dataSource = ds;
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

- (void)loadView
{
    // Create the tableview.
    self.view = [[[UIView alloc] initWithFrame:TTApplicationFrame()] autorelease];
    self.tableView = [[[UITableView alloc] initWithFrame:TTApplicationFrame() style:UITableViewStylePlain] autorelease];
    self.tableView.rowHeight = 80.f;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    
    // Add search bar to top of screen.
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.f, 0.f, TTApplicationFrame().size.width, TT_ROW_HEIGHT)];
    searchBar.delegate = self;
    searchBar.placeholder = @"Image Search";
    self.tabBarController.navigationItem.titleView = searchBar;
    [searchBar release];
}

/////////////////////////////////////////////////////////////////////////////////////
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Configure our TTModel with the user's search terms
    // and tell the TTModelViewController to reload.
    [searchBar resignFirstResponder];
//    [(id<SearchResultsModel>)self.model setSearchTerms:[searchBar text]];
//    [self reload];
//    [self.tableView scrollToTop:YES];
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

#pragma mark -
#pragma mark FlickrSearchResultsModelDelegate
- (NSString *)apiMethod
{
	return @"flickr.contacts.getList";
}

- (NSDictionary *)argumentsForApiMethod
{
	return nil;
}

//- (NSString *)apiMethod
//{
//	return @"flickr.people.getPhotos";
//}
//
//- (NSDictionary *)argumentsForApiMethod
//{
//	return [NSDictionary dictionaryWithObjectsAndKeys:@"me", @"user_id", nil];
//}
@end
