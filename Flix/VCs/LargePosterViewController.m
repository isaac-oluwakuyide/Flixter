//
//  LargePosterViewController.m
//  Flix
//
//  Created by Isaac Oluwakuyide on 7/5/23.
//

#import "LargePosterViewController.h"
#import "UIKit+AFNetworking.h"

@interface LargePosterViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *largeImageView;

@end

@implementation LargePosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchImages];
}

- (void) fetchImages    {
    //load the low res before the high res image

    NSURLRequest *smallRequest = [NSURLRequest requestWithURL:self.movie.smallURL];
    NSURLRequest *largeRequest = [NSURLRequest requestWithURL:self.movie.largeURL];
    
    
    [self.largeImageView setImageWithURLRequest:smallRequest
                               placeholderImage:nil
        success:^(NSURLRequest *request, NSHTTPURLResponse *imageResponse, UIImage *image) {
        
            // smallImageResponse will be nil if the smallImage is already available in cache (might want to do something smarter in that case).
            self.largeImageView.alpha = 0.0;
            self.largeImageView.image = image;
                
            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.3 animations:^{
                self.largeImageView.alpha = 1.0;
                }
                completion:^(BOOL finished) {
                    //only submit 1 request at a time, so set image with url similarly to above, but you have a placeholder image now
                    [self.largeImageView setImageWithURLRequest:largeRequest placeholderImage:image success:^(NSURLRequest *request, NSHTTPURLResponse *imageResponse, UIImage *goodImage){
                        self.largeImageView.image = goodImage;
                    } failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error){
                        NSLog(@"%@", [error localizedDescription]);
                    }];
                }
            ];
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
            NSLog(@"%@", [error localizedDescription]);
        }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
