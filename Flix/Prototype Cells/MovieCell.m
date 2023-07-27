//
//  MovieCell.m
//  Flix
//
//  Created by Isaac Oluwakuyide on 7/1/23.
//

#import "MovieCell.h"
#import "UIKit+AFNetworking.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setMovie:self.movie];

    // Configure the view for the selected state
}

- (void) setMovie:(Movie *)movie {
    // Since we're replacing the default setter, we have to set the underlying private storage _movie ourselves.
    // _movie was an automatically declared variable with the @propery declaration.
    // You need to do this any time you create a custom setter.
    _movie = movie;
    if (movie)  {
        //set up the imageView
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:_movie.posterURL];
        
        
        
        [self.posterImageView setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image){
            
            // imageResponse will be nil if the image is cached
            if (imageResponse) {
                self.posterImageView.alpha = 0.0;
                self.posterImageView.image = image;
                
                //Animate UIImageView back to alpha 1 over 0.3sec
                [UIView animateWithDuration:0.3 animations:^{
                    self.posterImageView.alpha = 1.0;
                }];
            }
            else{
                self.posterImageView.image = image;
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error)    {
            NSLog(@"%@", [error localizedDescription]);
        }];
        
        //set up the movie title and synopsis
        self.movieTitleLabel.text = movie.title;
        self.movieSynopsisLabel.text = movie.overview;
    }
    
    self.movieTitleLabel.text = self.movie.title;
    self.movieSynopsisLabel.text = self.movie.overview;
    
//    self.posterImageView.image = nil;
    
}

@end
