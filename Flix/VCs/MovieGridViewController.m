//
//  MovieGridViewController.m
//  Flix
//
//  Created by Isaac Oluwakuyide on 7/2/23.
//

#import "MovieGridViewController.h"
#import "MovieViewController.h"
#import "MovieGridCollectionCell.h"
#import "UIKit+AFNetworking.h"

@interface MovieGridViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSArray *posts;


@end

@implementation MovieGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.movieGridCollectionView.dataSource = self;
    self.movieGridCollectionView.delegate = self;
    

    
    //set up refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self fetchDictionary];
    [self.movieGridCollectionView insertSubview:refreshControl atIndex:0];
    
}

-(void) beginRefresh:(UIRefreshControl *)refreshControl    {
    [self fetchDictionary];
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
            self.posts = dataDictionary[@"results"];
            
            // Reload your table view data
            [self.movieGridCollectionView reloadData];
        }
    }];
    [self.activityIndicator stopAnimating];
    [task resume];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MovieGridCollectionCell *movieCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieGridCollectionCell" forIndexPath:indexPath];
    
    //fetch movie poster
    NSDictionary *movie = self.posts[indexPath.row];
    if(movie)   {
        NSString *posterPath = movie[@"poster_path"];
        NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
        NSString *fullPosterURL = [baseURLString stringByAppendingString:posterPath];
        [movieCollectionCell.posterImageView setImageWithURL:[NSURL URLWithString: fullPosterURL]];
    }

    //set image size
    CGRect imageFrame = movieCollectionCell.posterImageView.frame;
    imageFrame.size.width = 95;
    imageFrame.size.height = 142.5;
    movieCollectionCell.posterImageView.frame = imageFrame;

    return movieCollectionCell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

-(void) viewDidLayoutSubviews{
    self.flowLayout.minimumLineSpacing = 5;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath   {
    
    return CGSizeMake(95, 142.5);
}


@end
