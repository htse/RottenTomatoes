//
//  MovieListViewController.m
//  RottenTomatoes
//
//  Created by Helen Tse on 6/5/14.
//  Copyright (c) 2014 Helen Tse. All rights reserved.
//

#import "MovieListViewController.h"
#import "MovieCell.h"
#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Movie.h"
#import "MBProgressHUD.h"

@interface MovieListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) UILabel *networkErrorLabel;

@end

@implementation MovieListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Movies";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchMovies];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    self.tableView.rowHeight = 125;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableViewCell *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
                       
    NSDictionary *movie = self.movies[indexPath.row];
    cell.movieTitleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    
    NSString *thumbnailURL = movie[@"posters"][@"thumbnail"];
    NSURL *url = [NSURL URLWithString:thumbnailURL];
    [cell.posterView setImageWithURL:url];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MovieDetailViewController *mdvc = nil;
    
    NSDictionary *selectedMovie = self.movies[indexPath.row];
  
    Movie *movie = [[Movie alloc] init];
    movie.title = selectedMovie[@"title"];
    movie.synopsis = selectedMovie[@"synopsis"];
    movie.posterURL = selectedMovie[@"posters"][@"original"];
    
    mdvc = [[MovieDetailViewController alloc] initWithMovie:movie];
    mdvc.title = movie.title;

    [self.navigationController pushViewController:mdvc animated:YES];
    
}

- (void)handleRefresh:(UIRefreshControl *)refreshControl
{

    [self fetchMovies];
    [refreshControl endRefreshing];

}

- (void)fetchMovies {
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=5jqzy2rtqccwjp2kmuedjzbr";
    self.movies = nil;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (connectionError == nil) {
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = object[@"movies"];
        }
        
        if (connectionError != nil || self.movies == nil) {
            self.networkErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 30.0)];
            self.networkErrorLabel.text = @"Network Error";
            self.networkErrorLabel.textColor = [UIColor whiteColor];
            self.networkErrorLabel.textAlignment = NSTextAlignmentCenter;
            self.networkErrorLabel.backgroundColor = [UIColor darkGrayColor];
            [self.tableView addSubview:self.networkErrorLabel];
            
            [self performSelector:@selector(removeNetworkError) withObject:nil afterDelay:2.0];
        }
        else {
            [self.tableView reloadData];
        }
    }];
}

- (void)removeNetworkError{
    [self.networkErrorLabel removeFromSuperview];
}


@end
