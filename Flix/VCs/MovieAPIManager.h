//
//  MovieAPIManager.h
//  Flix
//
//  Created by Isaac Oluwakuyide on 7/28/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieAPIManager : NSObject

@property (nonatomic, strong) NSURLSession *session;

-(void)fetchNowPlaying:(void(^)(NSArray *movies, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
