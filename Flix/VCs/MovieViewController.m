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
#import "MovieAPIManager.h"

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
    MovieAPIManager *manager = [MovieAPIManager new];
    [manager fetchNowPlaying:^(NSArray *movies, NSError *error) {
        if (error != nil)   {
            [self.activityIndicator stopAnimating];
            NSLog(@"%@", [error localizedDescription]);
            [self showAlert];
        }
        else{
            self.posts = movies;
            self.filteredPosts = self.posts;
            
            //reload the table view data
            [self.tableView reloadData];
        }
    }];
    [self.activityIndicator stopAnimating];
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
