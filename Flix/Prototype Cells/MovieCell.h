//
//  MovieCell.h
//  Flix
//
//  Created by Isaac Oluwakuyide on 7/1/23.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsisLabel;
@property (nonatomic, strong) Movie *movie;

@end

NS_ASSUME_NONNULL_END
