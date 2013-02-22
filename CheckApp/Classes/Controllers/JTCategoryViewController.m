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

static NSString *CollectionViewCellIdentifier = @"CollectionViewCellIdentifier";

@interface JTCategoryViewController ()
{
    PSUICollectionView * _gridView;
}
@property (nonatomic , retain) NSString * itemName;
@end

@implementation JTCategoryViewController
@synthesize categories;

- (id)initWithNewItemName:(NSString*)name
{
    self = [super init];
    if (self)
    {
        self.itemName = name;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self generateData];
    
    [self createGridView];
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
        NSArray * array = [NSArray arrayWithObjects:@"Meat",@"Vegetable",@"Dairy",@"Beverage",@"Cracker",@"Drug", nil];
        NSArray * tempPeriod = [NSArray arrayWithObjects:[NSNumber numberWithInt:7],
                                [NSNumber numberWithInt:14],
                                [NSNumber numberWithInt:7],
                                [NSNumber numberWithInt:90],
                                [NSNumber numberWithInt:90],
                                [NSNumber numberWithInt:365], nil];
        
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
    NSError *error;
    self.categories = [context executeFetchRequest:fetchRequest error:&error];

}

- (void)createGridView {
    PSUICollectionViewFlowLayout *layout = [[PSUICollectionViewFlowLayout alloc] init];
    
    [layout setMinimumInteritemSpacing:0.0f];
    [layout setMinimumLineSpacing:0.0f];
    
    _gridView = [[PSUICollectionView alloc] initWithFrame:[self.view bounds] collectionViewLayout:layout];
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gridView.delegate = self;
    _gridView.dataSource = self;
    _gridView.backgroundColor = [UIColor colorWithRed:0.135 green:0.341 blue:0.000 alpha:1.000];
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
    cell.backgroundColor = [UIColor redColor];
    cell.titleLabel.text = category.title;
//    cell.label.text = [self formatIndexPath:indexPath];
    
//    // load the image for this cell
//    NSString *imageToLoad = [NSString stringWithFormat:@"%d.JPG", indexPath.row];
//    cell.image.image = [UIImage imageNamed:imageToLoad];
    return cell;
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100.0f, 100.0f);
}

- (UIEdgeInsets)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionView*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake( (self.view.frame.size.height -300.0f)/2 + 44.0f, (self.view.bounds.size.width -300.0f)/2, (self.view.frame.size.height -300.0f)/2, (self.view.bounds.size.width -300.0f)/2);
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
    if (self.tabBarController.selectedIndex == 1)
    {
        JTObject * object = [NSEntityDescription insertNewObjectForEntityForName:@"JTObject"
                                                          inManagedObjectContext:[[JTObjectManager sharedManger] managedObjectContext]];
        NSLog(@"%@",[categories objectAtIndex:indexPath.row]);
        [object setCategory:[categories objectAtIndex:indexPath.item]];
        [object setName:self.itemName];
        [object setBuyInDate:[NSDate date]];
        
        int days = [[[categories objectAtIndex:indexPath.row] period]intValue];
        [object setExpiredDate:[[NSDate date]dateByAddingTimeInterval: 60 * 60 * 24 * days]];
        [object setToBuy:NO];
        [object setToBuyDate:nil];
        [object setImagePath:nil];
        
        NSError *error;
        if (![[[JTObjectManager sharedManger] managedObjectContext] save:&error])
        {
            NSLog(@"Failed to save, error: %@", [error localizedDescription]);
        }
        else
        {
            self.tabBarController.selectedIndex = 0;
            
        }
        
    }
    else if (self.tabBarController.selectedIndex == 0)
    {
//        SMCategoryItemsViewController * vc = [[SMCategoryItemsViewController alloc]initWithStyle:UITableViewStylePlain];
//        
//        SMCategory * category = [categories objectAtIndex:indexPath.row];
//        NSEntityDescription *entity = [NSEntityDescription
//                                       entityForName:@"SMObject" inManagedObjectContext:managedObjectContext];
//        
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//        [fetchRequest setEntity:entity];
//        
//        NSError * error;
//        NSArray * allObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
//        vc.items = [[NSMutableArray alloc]init];
//        for (SMObject * obj in allObjects)
//        {
//            if (obj.category == category)
//                [vc.items addObject:obj];
//        }
//        
//        [self.navigationController pushViewController:vc animated:YES];
//        vc.navigationItem.title = category.title;
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

@end
