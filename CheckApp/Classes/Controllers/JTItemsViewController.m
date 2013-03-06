//
//  JTItemsViewController.m
//  CheckApp
//
//  Created by Joy Tao on 2/22/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTItemsViewController.h"
#import "JTItemsCell.h"
#import "NSString+JTAdditions.h"

#import "JTDetailViewController.h"
@interface JTItemsViewController ()
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
    UIBarButtonItem * editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTable:)];
    self.navigationItem.rightBarButtonItem = editButton;
    self.editing = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"JTObject" inManagedObjectContext:[[JTObjectManager sharedManager]managedObjectContext]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSError * error;
    NSArray * allObjects = [[[JTObjectManager sharedManager]managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    NSLog(@"%i",[allObjects count]);
    items = [[NSMutableArray alloc]init];
    for (JTObject * obj in allObjects)
    {
        if (obj.category.title == self.navigationItem.title)
            [items addObject:obj];
    }
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"expiredDate" ascending:NO];
    [items sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    [self.tableView reloadData];
}

#pragma mark - Editable Table Method

- (void) editTable:(id)sender{
	if(self.editing)
	{
		[super setEditing:NO animated:NO];
		[self.tableView setEditing:NO animated:NO];
		[self.tableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
        self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
        
	}
	else
	{
		[super setEditing:YES animated:YES];
		[self.tableView setEditing:YES animated:YES];
		[self.tableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
        
        UIBarButtonItem * deleteButton = [[UIBarButtonItem alloc]initWithTitle:@"Delete All" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteAllItems)];
        self.navigationItem.leftBarButtonItem = deleteButton;
        
	}
}

- (void) deleteAllItems
{
    for (JTObject * obj in items)
    {
        [[[JTObjectManager sharedManager]managedObjectContext]deleteObject:obj];
    }
    NSError *error;
    if (![[[JTObjectManager sharedManager]managedObjectContext] save:&error])
    {
        NSLog(@"Failed to save, error: %@", [error localizedDescription]);
    }
    else
    {
        [self.items removeAllObjects];
        [self.tableView reloadData];
    }
    
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
                [button setBackgroundImage:[UIImage imageNamed:@"expiredBtn_expired"] forState:UIControlStateDisabled];
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
                [button setBackgroundImage:[UIImage imageNamed:@"toBuyBtn"] forState:UIControlStateNormal];
                
            }
            else
            {
                [object setToBuyDate:[NSDate date]];
                [object setToBuy:YES];
                button.selected = YES;
                [button setBackgroundImage:[UIImage imageNamed:@"toBuyBtn_disable"] forState:UIControlStateSelected];
            }
            
        }
            break;
            
        default:
            break;
    }
    [object setUpdatedDate:[NSDate date]];
    
    NSError *error;
    if (![[[JTObjectManager sharedManager]managedObjectContext] save:&error])
    {
        NSLog(@"Failed to save, error: %@", [error localizedDescription]);
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTObject * object = [items objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    JTItemsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[JTItemsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.tableViewController = self;
    cell.object = object;
    cell.titleLabel.text = object.name;
    cell.dateLabel.text = [NSString stringWithFormat:@"Lastest Update:%@",[NSString dateFormatterShortStyle:object.updatedDate]];
    cell.imageView.image = object.imagePath ? [UIImage imageWithData:[NSData dataWithContentsOfFile:object.imagePath]]:[UIImage imageNamed:@"btn_placeholder_temp"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTObject * object = [items objectAtIndex:indexPath.row];
    JTDetailViewController * vc = [[JTDetailViewController alloc]initWithStyle:UITableViewStyleGrouped withObject:object];
    [self.navigationController pushViewController:vc animated:YES];
    vc.navigationItem.title = @"Details";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath) return UITableViewCellEditingStyleNone;
    else return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        JTObject * object = [items objectAtIndex:indexPath.row];
        [[[JTObjectManager sharedManager]managedObjectContext]deleteObject:object];
        
        NSError *error;
        if (![[[JTObjectManager sharedManager]managedObjectContext] save:&error])
        {
            NSLog(@"Failed to save, error: %@", [error localizedDescription]);
        }
        else
        {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                             withRowAnimation:UITableViewRowAnimationFade];
            [self.items removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }
    }
}

@end
