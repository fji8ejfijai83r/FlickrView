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

- (void)didSelectObject:(TTTableLinkedItem *)object atIndexPath:(NSIndexPath*)indexPath
{
	MyPhotoThumbsViewController *mptvc = 
	[[MyPhotoThumbsViewController alloc] initWithName:object.URL];
	[self.navigationController pushViewController:mptvc animated:YES];
	[mptvc release];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (id)init {
//- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {

    if ((self = [super init])) {
        self.title = @"Table Example";
        
//		TTNavigator *navigator = [TTNavigator navigator];
//		navigator.window = self.view.window;
//		TTURLMap *map = navigator.URLMap;
//		
//		[map from:@"tt://SearchTable" 
//			toSharedViewController:[SearchTableViewController class]];
//		[map from:@"tt://SearchTable/(initWithName:)" 
//			toSharedViewController:[MyPhotoThumbsViewController class]];
		
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
    self.tableView.rowHeight = 48.f;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
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

@end
