//
//  JTNavigationController.m
//  CheckApp
//
//  Created by Joy Tao on 3/6/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTNavigationController.h"

@interface JTNavigationController ()

@end

@implementation JTNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:64/255.0f green:158/255.0f blue:226.0f/255.0f alpha:1.0f]];
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                                                              UITextAttributeTextColor,
                                                              [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
                                                              UITextAttributeTextShadowColor,
                                                              [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], 
                                                              UITextAttributeTextShadowOffset, 
                                                              [UIFont fontWithName:@"Arial-BoldMT" size:0.0f],
                                                              UITextAttributeFont, 
                                                              nil]];
    }
    return self;
}
@end
