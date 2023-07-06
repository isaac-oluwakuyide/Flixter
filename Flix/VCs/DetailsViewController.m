//
//  DetailsViewController.m
//  Flix
//
//  Created by Isaac Oluwakuyide on 7/2/23.
//

#import "DetailsViewController.h"
#import "MovieViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TrailerViewController.h"
#import "LargePosterViewController.h"

@interface DetailsViewController ()


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchMovieInfo];
}

- (void)fetchMovieInfo  {
    //fetch the backdrop, poster URL links
    NSString *baseURLstring = @"https://image.tmdb.org/t/p/w500";
    
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *posterURLString = self.movie[@"poster_path"];
    
    NSURL *backdropURL = [NSURL URLWithString:[baseURLstring stringByAppendingString:backdropURLString]];
    NSURL *posterURL = [NSURL URLWithString:[baseURLstring stringByAppendingString:posterURLString]];
    
    [self.posterImageView setImageWithURL:posterURL];
    [self.backdropImageView setImageWithURL:backdropURL];
    
    //fetch the movie title and movie description
    self.titleLabel.text = self.movie[@"original_title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    
}
- (IBAction)didTapImage:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"trailerSegue" sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"trailerSegue"]) {
        TrailerViewController *trailerVC = [segue destinationViewController];
        trailerVC.movieID = [self.movie[@"id"] longValue];
        
    }
    else if ([segue.identifier isEqualToString:@"LargePosterSegue"])    {
        LargePosterViewController *largePosterVC = [segue destinationViewController];
        largePosterVC.movie = self.movie;
    }
}


@end
