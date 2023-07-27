//
//  MovieGridViewController.h
//  Flix
//
//  Created by Isaac Oluwakuyide on 7/2/23.
//

#import <UIKit/UIKit.h>
#import "MovieViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface MovieGridViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *movieGridCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;



@end

NS_ASSUME_NONNULL_END
