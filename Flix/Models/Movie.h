//
//  Movie.h
//  Flix
//
//  Created by Isaac Oluwakuyide on 7/25/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *posterURL;
@property (nonatomic) long movie_ID;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSURL *backdropURL;
@property (nonatomic, strong) NSURL *smallURL;
@property (nonatomic, strong) NSURL *largeURL;

-(id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
