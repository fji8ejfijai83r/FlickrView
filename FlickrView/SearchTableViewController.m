//
//  SearchTableViewController.m
//

#import "SearchTableViewController.h"
#import "SearchResultsTableDataSource.h"
#import "SearchResultsModel.h"
#import "FlickrSearchResultsModel.h"
#import "SearchResult.h"
#import "ForwardingAdapters.h"


//- (void)createSearchBar
//{
//	if (self.searchKey.length) {
//		if (self.tableView && !self.tableView.tableHeaderView) {
//			UISearchBar *searchBar = [[[UISearchBar alloc] init] autorelease];
//			[[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//			self.searchDisplayController.searchResultsDelegate = self;
//			self.searchDisplayController.searchResultsDataSource = self;
//			self.searchDisplayController.delegate = self;
//			searchBar.frame = CGRectMake(0, 0, 0, 38);
//			self.tableView.tableHeaderView = searchBar;
//		}
//	} else {
//		self.tableView.tableHeaderView = nil;
//	}
//}
//
//- (void)setSearchKey:(NSString *)aKey
//{
//	[searchKey release];
//	searchKey = [aKey copy];
//	[self createSearchBar];
//}
@interface PhotoItem : NSObject <TTPhoto>
{
    NSString *caption;
    NSString *imageURL;
    NSString *thumbnailURL;
    id <TTPhotoSource> photoSource;
    CGSize size;
    NSInteger index;
}
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSString *thumbnailURL;
+ (id)itemWithImageURL:(NSString*)imageURL thumbImageURL:(NSString*)thumbImageURL caption:(NSString*)caption size:(CGSize)size;
@end

@implementation SearchTableViewController


- (TTPhotoViewController*)createPhotoViewController {
	return [[[TTPhotoViewController alloc] init] autorelease];
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath;
{
	//NSLog(@"%@", object);
	SearchResult *result = [[(id<SearchResultsModel>)self.model results] objectAtIndex:indexPath.row];
	id<TTPhoto> photo = [PhotoItem itemWithImageURL:result.bigImageURL thumbImageURL:result.thumbnailURL caption:result.title size:result.bigImageSize];
	TTPhotoViewController *controller = [self createPhotoViewController];
	//controller.realModel = (id<SearchResultsModel>)self.model;
	controller.centerPhoto = photo;
	controller.photoSource = (id<SearchResultsModel>)self.model ;
	[self.tabBarController.navigationController pushViewController:controller animated:YES];
}


- (id)init
{
    if ((self = [super init])) {
        self.title = @"Table Example";
        
        // Initialize our TTTableViewDataSource and our TTModel.
        id<TTTableViewDataSource> ds = [SearchResultsTableDataSource dataSourceWithItems:nil];
        ds.model = [[[FlickrSearchResultsModel alloc] init] autorelease];
        
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
@end
