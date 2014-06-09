//
//  MovieDetailViewController.m
//  RottenTomatoes
//
//  Created by Helen Tse on 6/5/14.
//  Copyright (c) 2014 Helen Tse. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "Movie.h"
#import "UIImageView+AFNetworking.h"


@interface MovieDetailViewController ()
@property (weak, nonatomic) UILabel *movieTitleLabel;
@property (weak, nonatomic) UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (strong, nonatomic) Movie *movie;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UIView *synopsisOverlay;

@end

@implementation MovieDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    NSURL *url = [NSURL URLWithString:self.movie.posterURL];
    [self.posterView setImageWithURL:url];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    
    
    CGRect rect = [self.movie.synopsis boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
    double textHeight = rect.size.height;
    double overlayHeight = textHeight + 250.0f;
   
    if (self.view.frame.size.height > overlayHeight) {
        overlayHeight = self.view.frame.size.height;
    }

    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"SynopsisOverlay" owner:self options:nil];
    self.synopsisOverlay = [nibViews objectAtIndex:0];
    self.synopsisOverlay.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    self.synopsisOverlay.frame = CGRectMake(0,0, self.view.frame.size.width, overlayHeight);
    
    self.movieTitleLabel = (UILabel *)[self.synopsisOverlay viewWithTag:1000];
    self.synopsisLabel = (UILabel *)[self.synopsisOverlay viewWithTag:1001];
    
    

    [self.scrollView addSubview:self.synopsisOverlay];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, overlayHeight);
    self.scrollView.contentInset = UIEdgeInsetsMake(125, 0, 0, 0);
    self.scrollView.contentOffset = CGPointMake(0.0f, -125.0f);
    
    self.movieTitleLabel.text = self.movie.title;
    self.movieTitleLabel.textColor = [UIColor whiteColor];
    self.synopsisLabel.text = self.movie.synopsis;
    self.synopsisLabel.textColor = [UIColor whiteColor];
    self.synopsisLabel.backgroundColor = [UIColor clearColor];
    self.synopsisLabel.frame = CGRectMake(10,75.0f,self.view.frame.size.width-20, textHeight);
    self.synopsisLabel.numberOfLines = 0;
    self.synopsisLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithMovie:(Movie *)m {
    self.movie = m;
    return self;
}

@end
