//
//  MovieViewController.m
//  Flix
//
//  Created by Isaac Oluwakuyide on 7/1/23.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIKit+AFNetworking.h"
#import "DetailsViewController.h"
#import "LargePosterViewController.h"
#import "Movie.h"

@interface MovieViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>
@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSArray *filteredPosts;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    //set up the search bar
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.navigationItem.titleView = self.searchController.searchBar;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchResultsUpdater = self;
    
    // Sets this view controller as presenting view controller for the search interface
    self.definesPresentationContext = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = 150;
    [self fetchDictionary];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
}

- (void) fetchDictionary{
    //API call
    [self.activityIndicator startAnimating];
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=d20eedb54811a1d5dbd0291f9af7e839"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil)   {
            [self.activityIndicator stopAnimating];
            NSLog(@"%@", [error localizedDescription]);
            [self showAlert];
        }
        else    {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            // Get the array of movies
            NSArray *dictionaries = dataDictionary[@"results"];
            self.posts = [Movie moviesWithDictionaries:dictionaries];
            self.filteredPosts = self.posts;
            
            // Reload your table view data
            [self.tableView reloadData];
        }
    }];
    [self.activityIndicator stopAnimating];
    [task resume];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self fetchDictionary];
    [refreshControl endRefreshing];
}

//shows a UIActionAlert when the fetch request times out
-(void) showAlert    {
    //create UIActionAlert
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The Internet connetion seems to be offline" preferredStyle:UIAlertControllerStyleAlert];
    
    //create the "Try Again" Action
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Dismiss the alert controller and retry fetching
        [alertController dismissViewControllerAnimated:YES completion:^{
            [self fetchDictionary];
        }];
    }];
    
    //add the try again action to the action alert
    [alertController addAction:tryAgainAction];
    
    //Present the alert
    [self presentViewController:alertController animated:YES completion:nil];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Pass the selected object to the new view controller.
    
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    
    Movie *movie = self.filteredPosts[indexPath.row];

    
    // Get the new view controller using [segue destinationViewController].
    if ([segue.identifier isEqualToString:@"cellToPosterSegue"]) {
        LargePosterViewController *largePosterVC = [segue destinationViewController];
        largePosterVC.movie = movie;
    }   else{
        DetailsViewController *detailsVC = [segue destinationViewController];
        detailsVC.movie = movie;
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCell *movieCell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    
    movieCell.movie = self.filteredPosts[indexPath.row];

    return movieCell;
}



-(NSString *)fetchPosterPath:(NSString *)posterPath  {
    NSString *baseURLstring = @"https://image.tmdb.org/t/p/w500";
    return [baseURLstring stringByAppendingString:posterPath];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredPosts.count;
}

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    
    if(searchText)  {
        //if statement just in case the search text is all the way backspaced, checks whether a movie title contains searchText
        if (searchText.length > 0)    {
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
                NSString *movieTitle = evaluatedObject[@"title"];
                return [movieTitle containsString:searchText];
            }];
            self.filteredPosts = [self.posts filteredArrayUsingPredicate:predicate];
        }
        else    {
            self.filteredPosts = self.posts;
        }
        
        [self.tableView reloadData];
    }
    [self.tableView reloadData];
}

@end
