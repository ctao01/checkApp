//
//  JTMainTabBarController.m
//  CheckApp
//
//  Created by Joy Tao on 2/22/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTMainTabBarController.h"
#import "JTCategoryViewController.h"
#import "JTBuyListViewController.h"

#import "NSString+JTAdditions.h"

@interface JTMainTabBarController ()
{
    UIImage * originImage;
    NSUInteger currentIndex;
}
- (void) addCenterButtonWithImage:(UIImage*)buttonImage;
@end

@implementation JTMainTabBarController

- (id)init
{
    self = [super init];
    if (self) {
        
        self.delegate = self;
        
        NSMutableArray * array = [[NSMutableArray alloc]init];
        JTCategoryViewController * vc1 = [[JTCategoryViewController alloc]init];
        UINavigationController * nc1 = [[UINavigationController alloc]initWithRootViewController:vc1];
        nc1.tabBarItem.title = @"Category";
        [array addObject:nc1];
        
        JTBuyListViewController * vc2 = [[JTBuyListViewController alloc]initWithStyle:UITableViewStylePlain];
        UINavigationController * nc2 = [[UINavigationController alloc]initWithRootViewController:vc2];
        nc2.tabBarItem.title = @"To-Buy List";
        [array addObject:nc2];
        
        for (int count = 0; count < 3; count++)
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
    
    [self addCenterButtonWithImage:[UIImage imageNamed:@"cameraTabBarItem"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Capture Method

- (void) addCenterButtonWithImage:(UIImage *)buttonImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(activateCamera) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [self.view addSubview:button];
}

- (void)activateCamera
{    
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate =self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = NO;
    
    [self presentViewController:picker animated:YES completion:^{
        [self setSelectedIndex:2];
    }];
}

#pragma mark - UITabBarController Delegate 

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController == [tabBarController.viewControllers objectAtIndex:1])
    {
        UINavigationController * nc = (UINavigationController*)viewController;
        JTBuyListViewController * vc = [nc.viewControllers objectAtIndex:0];
        [vc generateToBuyData];
    }

    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    currentIndex = self.selectedIndex;
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    originImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"Title" message:@"Please enter the name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av show];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        NSString * imagePath = [NSString imagePathWithItemName:[alertView textFieldAtIndex:0].text];
        NSData * pngData = UIImagePNGRepresentation(originImage);
        [pngData writeToFile:imagePath atomically:YES];
        NSLog(@"%@",imagePath);
        
        JTCategoryViewController * vc = [[JTCategoryViewController alloc]initWithNewItemName:[alertView textFieldAtIndex:0].text iconImagePath:imagePath];
        [self dismissViewControllerAnimated:YES completion:^{
            UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:vc];
            [[self.viewControllers objectAtIndex:2] presentViewController:nc animated:YES completion:^{
                [self setSelectedIndex:currentIndex];
            }];
            originImage = nil;
            NSLog(@"completion");
         }];

//        UINavigationController * nc = (UINavigationController*)[self.viewControllers objectAtIndex:2];
//        [nc pushViewController:vc animated:YES];
    }
}

@end
