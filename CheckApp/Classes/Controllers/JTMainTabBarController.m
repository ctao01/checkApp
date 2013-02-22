//
//  JTMainTabBarController.m
//  CheckApp
//
//  Created by Joy Tao on 2/22/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTMainTabBarController.h"
#import "JTCategoryViewController.h"

@interface JTMainTabBarController ()

@end

@implementation JTMainTabBarController

- (id)init
{
    self = [super init];
    if (self) {
        
        NSMutableArray * array = [[NSMutableArray alloc]init];
        JTCategoryViewController * vc1 = [[JTCategoryViewController alloc]init];
        UINavigationController * nc1 = [[UINavigationController alloc]initWithRootViewController:vc1];
        nc1.tabBarItem.title = @"Category";
        [array addObject:nc1];
        
        for (int count = 0; count < 4; count++)
        {
            UIViewController * vc = [[UIViewController alloc]init];
            UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:vc];
            vc.title = [NSString stringWithFormat:@"view%i",count];
            
            [array addObject:nc];
        }
        self.viewControllers = [NSArray arrayWithArray:array];
        self.selectedIndex = 0;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
