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
    [self.posterImageView setImageWithURL:self.movie.posterURL];
    [self.backdropImageView setImageWithURL:self.movie.backdropURL];
    
    //fetch the movie title and movie description
    self.titleLabel.text = self.movie.title;
    self.synopsisLabel.text = self.movie.overview;
    
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
        trailerVC.movieID = self.movie.movie_ID;
        
    }
    else if ([segue.identifier isEqualToString:@"LargePosterSegue"])    {
        LargePosterViewController *largePosterVC = [segue destinationViewController];
        largePosterVC.movie = self.movie;
    }
}


@end
