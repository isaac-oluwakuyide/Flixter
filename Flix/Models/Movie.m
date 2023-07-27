//
//  Movie.m
//  Flix
//
//  Created by Isaac Oluwakuyide on 7/25/23.
//

#import "Movie.h"

@implementation Movie

- (nonnull id)initWithDictionary:(nonnull NSDictionary *)dictionary {
    self = [super init];
    NSString *baseURLstring = @"https://image.tmdb.org/t/p/w500";
    
    NSString *backdropURLString = dictionary[@"backdrop_path"];
    NSString *posterURLString = dictionary[@"poster_path"];
    
    self.backdropURL = [NSURL URLWithString:[baseURLstring stringByAppendingString:backdropURLString]];
    self.posterURL = [NSURL URLWithString:[baseURLstring stringByAppendingString:posterURLString]];
    
    //load the low res before the high res image
    NSString *urlSmallString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w45%@", posterURLString];
    NSString *urlLargeString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/original%@", posterURLString];
    NSURL *smallURL = [NSURL URLWithString:urlSmallString];
    NSURL *largeURL = [NSURL URLWithString:urlLargeString];
    
    self.title = dictionary[@"title"];
    self.movie_ID = [dictionary[@"id"] longValue];
    self.overview = dictionary[@"overview"];

    return self;
}

+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries{
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dictionaries)  {
        Movie *movie = [[Movie alloc] init];
        movie = [movie initWithDictionary:dictionary];
        [movies addObject:movie];
    }
    //cast to an NSArray
    return [movies copy];
    
}

@end
