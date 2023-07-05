//
//  TrailerViewController.m
//  Flix
//
//  Created by Isaac Oluwakuyide on 7/4/23.
//

#import "TrailerViewController.h"

@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSArray *results;



@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //place url into a request and load request into WKWebView
    [self fetchTrailer];
}

- (void) fetchTrailer   {
    //API call
    [self.activityIndicator startAnimating];
    NSString *endpointString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%ld/videos?api_key=d20eedb54811a1d5dbd0291f9af7e839", self.movieID];
    NSURL *endPointURL = [NSURL URLWithString:endpointString];
    NSURLRequest *request = [NSURLRequest requestWithURL:endPointURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil)   {
            [self.activityIndicator stopAnimating];
            NSLog(@"%@", [error localizedDescription]);
            [self showAlert];
        }
        else    {
            //fetch the dictionary from the endpoint
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.results = dataDictionary[@"results"];
            
            
            //filter dictionary for results that are of the 'Trailer' Type
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings)   {
                NSString *type = evaluatedObject[@"type"];
                return [type isEqualToString:@"Trailer"];
            }];
            
            //pick the first element that is a trailer and set the URL String
            self.results = [self.results filteredArrayUsingPredicate:predicate];
            
            NSString *videoBaseURLString = @"https://www.youtube.com/watch?v=";
            NSString *videoKey = self.results[0][@"key"];
            self.urlString = [videoBaseURLString stringByAppendingString:videoKey];
            
            NSURL *url = [NSURL URLWithString:self.urlString];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
            
            [self.webView loadRequest:urlRequest];
        }
        [self.activityIndicator stopAnimating];
    }];
    
    [task resume];
}

-(void) showAlert    {
    //create UIActionAlert
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The Internet connetion seems to be offline" preferredStyle:UIAlertControllerStyleAlert];
    
    //create the "Try Again" Action
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again"
        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Dismiss the alert controller and retry fetching
        [alertController dismissViewControllerAnimated:YES completion:^{
            [self fetchTrailer];
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

@end
