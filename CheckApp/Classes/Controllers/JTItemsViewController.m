//
//  JTItemsViewController.m
//  CheckApp
//
//  Created by Joy Tao on 2/22/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTItemsViewController.h"
#import "JTItemsCell.h"
#import "JTItemGroupedCell.h"
#import "NSString+JTAdditions.h"

#import "JTDetailViewController.h"

@interface JTItemsViewController ()
{
    NSIndexPath * beDeletedIndexPath;
}

@end

@implementation JTItemsViewController
@synthesize items;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem * deleteButton = [[UIBarButtonItem alloc]initWithTitle:@"Delete All" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllItems)];
    self.navigationItem.rightBarButtonItem = deleteButton;
//    self.editing = NO;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:62.0f/255.0f green:62.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self generateCoreData];

}
- (void) generateCoreData
{
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"JTObject" inManagedObjectContext:[[JTObjectManager sharedManager]managedObjectContext]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSError * error;
    NSArray * allObjects = [[[JTObjectManager sharedManager]managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    items = [[NSMutableArray alloc]init];
    for (JTObject * obj in allObjects)
    {
        if ( (obj.expiredDate != nil ) && (obj.category.title == self.navigationItem.title))
            [items addObject:obj];
    }
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"expiredDate" ascending:NO];
    [items sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [self.tableView reloadData];
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0f];

    
}

- (void) refresh
{
    [self generateCoreData];

}

- (void) deleteAllItems
{
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"Delete All Items" message:@"After you delete all items, all data will be removed from database." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay", nil];
    [av show];
}

#pragma mark -

- (void)buttonTapped:(id)sender event:(UIEvent *)event
{
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:[[[event touchesForView:sender] anyObject] locationInView:self.tableView]];
    JTObject * object = [items objectAtIndex:indexPath.row];
    UIButton * button = (UIButton*)sender;
    
    switch (button.tag) {
        case 1001:
        {
            if (button.enabled)
            {
                button.enabled = NO;
                [button setTitle:@"" forState:UIControlStateDisabled];
                [button setBackgroundImage:[UIImage imageNamed:@"btn_expired"] forState:UIControlStateDisabled];
                object.expiredDate = [NSDate date];
                object.expired = YES;
            }
//            else
//            {
//                button.selected = NO;
//                [button setBackgroundImage:[UIImage imageNamed:@"btn_expired"] forState:UIControlStateNormal];
//                int days = [object.category.period intValue];
//                object.expiredDate = [[NSDate date]dateByAddingTimeInterval: 60 * 60 * 24 * days];
//                object.expired = NO;
//            }
        }
            break;
        case 1002:
        {
            
            if (button.selected)
            {
                [object setToBuyDate:nil];
                [object setToBuy:NO];
                button.selected = NO;
                [button setBackgroundImage:[UIImage imageNamed:@"btn_toBuy_normal"] forState:UIControlStateNormal];
                
            }
            else
            {
                [object setToBuyDate:[NSDate date]];
                [object setToBuy:YES];
                button.selected = YES;
                [button setBackgroundImage:[UIImage imageNamed:@"btn_toBuy_selected"] forState:UIControlStateSelected];
            }
            
        }
            break;
        case 1003:
        {
            beDeletedIndexPath = indexPath;
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Would you like to delete the item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure", nil];
            [alertView show];
        }
        default:
            break;
    }
    [object setUpdatedDate:[NSDate date]];
    NSError *error;
    if (![[[JTObjectManager sharedManager]managedObjectContext] save:&error])
        NSLog(@"Failed to save, error: %@", [error localizedDescription]);

}

#pragma mark - UIAlertView 

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        if (alertView.title == @"Delete All Items")
        {
            for (JTObject * obj in items)
            {
                [[[JTObjectManager sharedManager]managedObjectContext]deleteObject:obj];
            }
            NSError *error;
            if (![[[JTObjectManager sharedManager]managedObjectContext] save:&error])
                NSLog(@"Failed to save, error: %@", [error localizedDescription]);
            else
            {
                [self.items removeAllObjects];
                [self.tableView reloadData];
            }
        }
        else
        {
            [[[JTObjectManager sharedManager]managedObjectContext]deleteObject:[items objectAtIndex:beDeletedIndexPath.section]];
            NSError *error;
            if (![[[JTObjectManager sharedManager]managedObjectContext] save:&error])
                NSLog(@"Failed to save, error: %@", [error localizedDescription]);
            else
            {
//                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:beDeletedIndexPath.section]  withRowAnimation:UITableViewRowAnimationFade];
                [items removeObject:[items objectAtIndex:beDeletedIndexPath.section]];
                [self.tableView reloadData];
            }

        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
//    return 1;
    return [items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    return [items count];
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTObject * object = [items objectAtIndex:indexPath.section];
    
    static NSString *CellIdentifier = @"Cell";
    JTItemGroupedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[JTItemGroupedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    cell.tableViewController = self;
    cell.object = object;
    cell.titleLabel.text = object.name;
    cell.dateLabel.text = [NSString stringWithFormat:@"Lastest Update:%@",[NSString dateFormatterShortStyle:object.updatedDate]];
    cell.imageView.image = object.imagePath ? [UIImage imageWithData:[NSData dataWithContentsOfFile:object.imagePath]]:[UIImage imageNamed:@"btn_placeholder_temp"];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTObject * object = [items objectAtIndex:indexPath.section];
    JTDetailViewController * vc = [[JTDetailViewController alloc]initWithStyle:UITableViewStyleGrouped withObject:object];
    [self.navigationController pushViewController:vc animated:YES];
    vc.navigationItem.title = @"Details";
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        JTObject * object = [items objectAtIndex:indexPath.row];
//        [[[JTObjectManager sharedManager]managedObjectContext]deleteObject:object];
//        
//        NSError *error;
//        if (![[[JTObjectManager sharedManager]managedObjectContext] save:&error])
//        {
//            NSLog(@"Failed to save, error: %@", [error localizedDescription]);
//        }
//        else
//        {
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
//                             withRowAnimation:UITableViewRowAnimationFade];
//            [self.items removeObjectAtIndex:indexPath.row];
//            [self.tableView reloadData];
//        }
//    }
//}

@end
