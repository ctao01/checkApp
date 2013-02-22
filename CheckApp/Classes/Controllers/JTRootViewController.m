//
//  JTRootViewController.m
//  CheckApp
//
//  Created by Joy Tao on 2/22/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTRootViewController.h"
#import "JTMainTabBarController.h"

@interface JTRootViewController ()
{
    UIActivityIndicatorView *activityIndicator;
}
- (void) goToMainScreen;
@end

@implementation JTRootViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    activityIndicator.center = CGPointMake(self.view.center.x, self.view.center.y + 120.0f);
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [self performSelector:@selector(goToMainScreen) withObject:nil afterDelay:3.0];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) goToMainScreen
{
    JTMainTabBarController * tbc = [[JTMainTabBarController alloc]init];
    [self presentViewController:tbc animated:NO completion:^{
        [activityIndicator stopAnimating];
    }];
}


@end
