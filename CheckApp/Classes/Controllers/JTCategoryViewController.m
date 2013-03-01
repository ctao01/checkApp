//
//  JTCategoryViewController.m
//  CheckApp
//
//  Created by Joy Tao on 2/22/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTCategoryViewController.h"
#import "JTObjectManager.h"
#import "JTCategory.h"
#import "JTObject.h"
#import "JTCategoryItemCell.h"

#import "JTItemsViewController.h"
#import "JTMainTabBarController.h"

#define Minimum_Interitem_Spacing 3.0f
#define Minimum_Line_Spacing 5.0f

#define iPhone5_Screen_Height 568.0f
#define iPhone4_Screen_Height 480.0f
//#define DEVICE_OS [[[UIDevice currentDevice] systemVersion] intValue]

static NSString *CollectionViewCellIdentifier = @"CollectionViewCellIdentifier";
static float rgbcolor(value)
{
    return value/255.0f;
}

@interface JTCategoryViewController ()
{
    PSUICollectionView * _gridView;
    
    ADBannerView * adView;
}
@property (nonatomic , retain) NSString * itemName;
@property (nonatomic , retain) NSString * itemImagePath;
@property (nonatomic , retain) JTMainTabBarController * tbc;
@end

@implementation JTCategoryViewController
@synthesize categories;

- (id)initWithNewItemName:(NSString*)name iconImagePath:(NSString*)imagePath
{
    self = [super init];
    if (self)
    {
        self.itemName = name;
        self.itemImagePath = imagePath;
    }
    return self;
}

- (id) initFromViewController:(UIViewController*)vc
{
    self = [super init];
    if (self)
        self.tbc = (JTMainTabBarController*)vc;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    if (self.itemImagePath || self.itemName) self.navigationItem.title = @"Choose Category";
//    else self.navigationItem.title = @"Category";
	[self generateData];
    [self createGridView];
    
    adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
//    adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierLandscape];
//    adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    [self.view addSubview:adView];
    adView.delegate = self;
    adView.frame = CGRectOffset(adView.frame, 0, self.view.frame.size.height - 44 - 49 - 50.0f ); //TODO:define
    self.view.backgroundColor = [UIColor colorWithRed:rgbcolor(215) green:rgbcolor(211) blue:rgbcolor(202) alpha:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) generateData
{
    JTObjectManager * manager = [JTObjectManager sharedManger];
    NSManagedObjectContext * context = [manager managedObjectContext];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        NSLog(@"HasLaunchedOnce");
        
    }
    else
    {
        NSArray * array = [NSArray arrayWithObjects:@"Frozen",@"Fresh",@"Dairy",@"Beverage",@"Crackers",@"Pharmacy",@"Canned", @"Sauces",@"Other", nil];
        NSArray * tempPeriod = [NSArray arrayWithObjects:[NSNumber numberWithInt:7],
                                [NSNumber numberWithInt:10],
                                [NSNumber numberWithInt:7],
                                [NSNumber numberWithInt:90],
                                [NSNumber numberWithInt:120],
                                [NSNumber numberWithInt:365],
                                [NSNumber numberWithInt:365],
                                [NSNumber numberWithInt:365],
                                [NSNumber numberWithInt:365*10],nil];
        
        for (int i = 0; i < [array count]; i++)
        {
            JTCategory * category = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"JTCategory"
                                     inManagedObjectContext:context];
            category.title = [array objectAtIndex:i];
            category.period = [tempPeriod objectAtIndex:i];
            
        }
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"JTCategory" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                      ascending:YES
                                                       selector:@selector(localizedCaseInsensitiveCompare:)];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
    NSError *error;
    self.categories = [context executeFetchRequest:fetchRequest error:&error];
}

- (void)createGridView {
    PSUICollectionViewFlowLayout *layout = [[PSUICollectionViewFlowLayout alloc] init];
    
    [layout setMinimumInteritemSpacing:Minimum_Interitem_Spacing];
    [layout setMinimumLineSpacing:Minimum_Line_Spacing];
    
    
    _gridView = [[PSUICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gridView.delegate = self;
    _gridView.dataSource = self;
    _gridView.backgroundColor  = [UIColor clearColor];

    [_gridView registerClass:[JTCategoryItemCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    
    [self.view addSubview:_gridView];
}

- (void)toggleAllowsMultipleSelection:(UIBarButtonItem *)item {
    _gridView.allowsMultipleSelection = !_gridView.allowsMultipleSelection;
    item.title = _gridView.allowsMultipleSelection ? @"Single-Select" : @"Multi-Select";
}

#pragma mark -
#pragma mark Collection View Data Source

- (NSString *)formatIndexPath:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"{%ld,%ld}", (long)indexPath.row, (long)indexPath.section];
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JTCategory * category = [self.categories objectAtIndex:indexPath.item];
    
    JTCategoryItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor redColor];
    cell.titleLabel.text = category.title;
//    cell.label.text = [self formatIndexPath:indexPath];
    
//    // load the image for this cell
//    NSString *imageToLoad = [NSString stringWithFormat:@"%d.JPG", indexPath.row];
//    cell.image.image = [UIImage imageNamed:imageToLoad];
    return cell;
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ( [UIScreen mainScreen].bounds.size.height == 568.0) return CGSizeMake(100.0f, 100.0f);
    else return CGSizeMake(100.0f * iPhone4_Screen_Height / iPhone5_Screen_Height, 100.0f * iPhone4_Screen_Height / iPhone5_Screen_Height);
}

- (UIEdgeInsets)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionView*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    float size, interItemSpace,topInset;
    
    if ([UIScreen mainScreen].bounds.size.height == 568.0)
    {
        size = 100.0f;
        interItemSpace = Minimum_Interitem_Spacing;
        topInset = 40.0f;
    }
    else
    {
        size = 100.0f * iPhone4_Screen_Height / iPhone5_Screen_Height;
        interItemSpace = Minimum_Interitem_Spacing * iPhone5_Screen_Height / iPhone4_Screen_Height;
        topInset = 20.0f;
    }
    
    return UIEdgeInsetsMake(topInset,
                            (self.view.bounds.size.width - size*3 - interItemSpace * 2)/2,
                            0.0f,
                            (self.view.bounds.size.width - size*3-  interItemSpace * 2)/2);
}

- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.categories count];
}

#pragma mark -
#pragma mark Collection View Delegate

- (void)collectionView:(PSTCollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Delegate cell %@ : HIGHLIGHTED", [self formatIndexPath:indexPath]);
}

- (void)collectionView:(PSTCollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Delegate cell %@ : UNHIGHLIGHTED", [self formatIndexPath:indexPath]);
}

- (void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.itemImagePath || self.itemName)
    if ([self.navigationItem.title isEqualToString:@"Select A Category"])
    {
        JTObject * object = [NSEntityDescription insertNewObjectForEntityForName:@"JTObject"
                                                          inManagedObjectContext:[[JTObjectManager sharedManger] managedObjectContext]];
//        NSLog(@"%@",[categories objectAtIndex:indexPath.row]);
//        [object setCategory:[categories objectAtIndex:indexPath.item]];
        [self.tbc.object setCategory:[categories objectAtIndex:indexPath.item]];
        [self dismissViewControllerAnimated:YES completion:^{
//            [self.tbc.modalView.catBtn setTitle:[[categories objectAtIndex:indexPath.item] title] forState:UIControlStateNormal];
//            [self.tbc.modalView setNeedsDisplay];
            [self.tbc.modalView setCategory:[[categories objectAtIndex:indexPath.item] title]];
        }];
//        [object setName:self.itemName];
//        [object setBuyInDate:[NSDate date]];
//
//        int days = [[[categories objectAtIndex:indexPath.row] period]intValue];
//        [object setExpiredDate:[[NSDate date]dateByAddingTimeInterval: 60 * 60 * 24 * days]];
//        [object setToBuy:NO];
//        [object setToBuyDate:nil];
//        [object setImagePath:self.itemImagePath];
//        
//        NSError *error;
//        if (![[[JTObjectManager sharedManger] managedObjectContext] save:&error])
//        {
//            NSLog(@"Failed to save, error: %@", [error localizedDescription]);
//        }
//        else
//        {
////            [self.tabBarController setSelectedIndex:0];
////            [self dismissViewControllerAnimated:YES completion:^{}];
//            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Done" message:@"The item has been saved" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
//            [alertView show];
//            
//        }
        
    }
    else
    {
        
        JTItemsViewController * vc = [[JTItemsViewController alloc]initWithStyle:UITableViewStylePlain];
        
        JTCategory * category = [categories objectAtIndex:indexPath.row];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"JTObject" inManagedObjectContext:[[JTObjectManager sharedManger]managedObjectContext]];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        
        NSError * error;
        NSArray * allObjects = [[[JTObjectManager sharedManger]managedObjectContext] executeFetchRequest:fetchRequest error:&error];
        vc.items = [[NSMutableArray alloc]init];
        for (JTObject * obj in allObjects)
        {
            if (obj.category == category)
                [vc.items addObject:obj];
        }
        
        [self.navigationController pushViewController:vc animated:YES];
        vc.navigationItem.title = category.title;
    }
}

- (void)collectionView:(PSTCollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Delegate cell %@ : DESELECTED", [self formatIndexPath:indexPath]);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Check delegate: should cell %@ highlight?", [self formatIndexPath:indexPath]);
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Check delegate: should cell %@ be selected?", [self formatIndexPath:indexPath]);
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Check delegate: should cell %@ be deselected?", [self formatIndexPath:indexPath]);
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark - UIAlertView Delegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - ADBannerView Delegate

- (void)bannerViewWillLoadAd:(ADBannerView *)banner
{
    
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"bannerViewDidLoadAd");
//    [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
//    // banner is invisible now and moved out of the screen on 50 px
//    banner.frame = CGRectOffset(banner.frame, 0, -50);
//    [UIView commitAnimations];
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"didFailToReceiveAdWithError:%@",error);

}
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    BOOL shouldExecuteAction = YES;
    if (!willLeave && shouldExecuteAction)
    {
        // stop all interactive processes in the app
        // [video pause];
        // [audio pause];
    }
    return shouldExecuteAction;
}
- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    
}

@end
