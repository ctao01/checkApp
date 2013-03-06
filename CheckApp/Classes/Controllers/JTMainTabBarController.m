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
#import "UIImage+JTAdditions.h"


@interface JTMainTabBarController ()
{
    UIImage * originImage;
    NSUInteger currentIndex;
    
//    UIView * view;
    
}
- (void) addCenterButtonWithImage:(UIImage*)buttonImage;
@end

@implementation JTMainTabBarController
@synthesize object;
@synthesize modalView;

- (id)init
{
    self = [super init];
    if (self) {
        
        self.delegate = self;
        
        NSMutableArray * array = [[NSMutableArray alloc]init];
        JTCategoryViewController * vc1 = [[JTCategoryViewController alloc]init];
        UINavigationController * nc1 = [[UINavigationController alloc]initWithRootViewController:vc1];
        vc1.navigationItem.title = @"Category";
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

//- (void) viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    NSLog(@"viewWillAppear:%@",[self.object.category title]);
//    [self.modalView setCategory:[self.object.category title]];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Call Form Modal View

-(void) showCategoryList
{
    JTCategoryViewController * vc1 = [[JTCategoryViewController alloc]initFromViewController:self];
//    JTCategoryViewController * vc1 = [[JTCategoryViewController alloc]initWithCurrentObject:self.object];
    UINavigationController * nc1 = [[UINavigationController alloc]initWithRootViewController:vc1];
    vc1.navigationItem.title = @"Select A Category";
    
    [self presentViewController:nc1 animated:YES completion:^{}];
    
}

- (void) cancelCreating
{
    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         [self.modalView setFrame:CGRectMake(self.modalView.frame.origin.x, self.modalView.frame.origin.y - self.modalView.frame.size.height, self.modalView.frame.size.width, self.modalView.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         UIView * view = [self.view viewWithTag:1020];
                         if (view) [view removeFromSuperview];
                     }];
    self.object = nil;
}

- (void) completeCreating
{
    [self.object setName:self.modalView.tf.text];
    if (self.object.name == nil || self.object.category == nil)
    {
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"Warning!" message:@"You have to add the title and category for your new item." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    
    else
    {
        int days = [[(JTCategory*)self.object.category period]intValue];
        [self.object setUpdatedDate:[NSDate date]];
        [self.object setExpiredDate:[[NSDate date]dateByAddingTimeInterval: 60 * 60 * 24 * days]];
        [self.object setExpired:NO];
        [self.object setToBuy:NO];
        [self.object setToBuyDate:nil];
//        [self.object setImagePath:nil];
        
        NSError *error;
        if (![[[JTObjectManager sharedManager] managedObjectContext] save:&error])
        {
            NSLog(@"Failed to save, error: %@", [error localizedDescription]);
        }
        else
        {
            NSLog(@"object:%@",self.object);
            NSLog(@"object.category.title%@",self.object.category.period);
            
        }
        [UIView animateWithDuration:0.4f
                              delay:0.0f
                            options: UIViewAnimationCurveEaseIn
                         animations:^{
                             [self.modalView setFrame:CGRectMake(self.modalView.frame.origin.x, self.modalView.frame.origin.y - self.modalView.frame.size.height, self.modalView.frame.size.width, self.modalView.frame.size.height)];
                         }
                         completion:^(BOOL finished){
                             UIView * view = [self.view viewWithTag:1020];
                             if (view) [view removeFromSuperview];
                         }];
    }
}

#pragma mark - Capture Method

- (void) addCenterButtonWithImage:(UIImage *)buttonImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(activateCamera) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(addNewItem) forControlEvents:UIControlEventTouchUpInside];

    
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

- (void) addNewItem
{
    self.object = [NSEntityDescription insertNewObjectForEntityForName:@"JTObject"
                                                inManagedObjectContext:[[JTObjectManager sharedManager] managedObjectContext]];
    
    [self.object setImagePath:nil];
    
    UIView * overlayView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    overlayView.opaque = NO;
    overlayView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.75f];
    overlayView.tag = 1020;
    
    self.modalView = [[JTModalView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [self.modalView setFrame:CGRectMake(self.modalView.frame.origin.x, self.modalView.frame.origin.y - self.modalView.frame.size.height, self.modalView.frame.size.width, self.modalView.frame.size.height)];
    self.modalView.opaque = NO;
    self.modalView.backgroundColor = [UIColor clearColor];
    self.modalView.viewController = self;
    [overlayView addSubview:self.modalView];
    [self.view addSubview:overlayView];
    
    [UIView animateWithDuration:0.8f
                          delay:0.0f
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.modalView.frame = [[UIScreen mainScreen]bounds];
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
    /*self.modalView = [[JTModalView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.modalView.opaque = NO;
    self.modalView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.75f];
    self.modalView.viewController = self;
    self.modalView.tag = 1020;
    [self.view addSubview:self.modalView];*/
}


- (void)activateCamera
{    
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate =self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = NO;
    
    [self presentViewController:picker animated:YES completion:^{
//        [self setSelectedIndex:2];
    }];
}

#pragma mark - UITabBarController Delegate 

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
//    if (viewController == [tabBarController.viewControllers objectAtIndex:1])
//    {
//        UINavigationController * nc = (UINavigationController*)viewController;
//        JTBuyListViewController * vc = [nc.viewControllers objectAtIndex:0];
//        [vc generateToBuyData];
//    }

    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    currentIndex = self.selectedIndex;
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    originImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage * rotatedImage = [UIImage scaleAndRotateImage:image];
    [self.object setImagePath:[NSString imagePathWithItemName:self.object.name]];
    NSData * pngData = UIImagePNGRepresentation(rotatedImage);
    [pngData writeToFile:self.object.imagePath atomically:YES];
    
    self.selectedIndex = currentIndex;
//    self.object = [NSEntityDescription insertNewObjectForEntityForName:@"JTObject"
//                                                inManagedObjectContext:[[JTObjectManager sharedManager] managedObjectContext]];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        /*[UIView animateWithDuration:0.8f
                              delay:0.0f
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             view.center = self.view.center;
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                         }];

        self.modalView = [[JTModalView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        self.modalView.opaque = NO;
        self.modalView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.75f];
        self.modalView.viewController = self;
        self.modalView.tag = 1020;
        [self.view addSubview:self.modalView];*/
        [self.modalView.imgView setImage:image];
        [self.modalView.imgView layoutIfNeeded];
    }];
    
    
    

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
        
//        NSString * imagePath = [NSString imagePathWithItemName:[alertView textFieldAtIndex:0].text];
//        NSData * pngData = UIImagePNGRepresentation(originImage);
//        [pngData writeToFile:imagePath atomically:YES];
//        NSLog(@"%@",imagePath);
//        
//        JTCategoryViewController * vc = [[JTCategoryViewController alloc]initWithNewItemName:[alertView textFieldAtIndex:0].text iconImagePath:imagePath];
//        [self dismissViewControllerAnimated:YES completion:^{
//            UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:vc];
//            [[self.viewControllers objectAtIndex:2] presentViewController:nc animated:YES completion:^{
//                [self setSelectedIndex:currentIndex];
//            }];
//            originImage = nil;
//            NSLog(@"completion");
//         }];
//
////        UINavigationController * nc = (UINavigationController*)[self.viewControllers objectAtIndex:2];
////        [nc pushViewController:vc animated:YES];
    }
}

@end
