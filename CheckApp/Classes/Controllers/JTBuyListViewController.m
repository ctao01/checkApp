//
//  JTBuyListViewController.m
//  CheckApp
//
//  Created by Joy Tao on 2/22/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTBuyListViewController.h"
#import "JTDetailViewController.h"
#import "JTToBuyItemCell.h"
#import "NSString+JTAdditions.h"
@interface JTBuyListViewController ()
{
    NSArray * keys; 
}
@property (nonatomic , retain) NSMutableArray * toBuyItems;

@end

@implementation JTBuyListViewController
@synthesize toBuyItems;

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
//    keys = [NSArray arrayWithObjects:@"Recently",@"Days Ago",@"Week Ago",@"Month Ago",@"Earlier", nil];
    UIBarButtonItem * editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTable:)];
    self.navigationItem.rightBarButtonItem = editButton;
    self.editing = NO;
    
    self.navigationItem.title = @"To-Buy List";
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:62.0f/255.0f green:62.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self generateToBuyData];

}


#pragma mark - Pre-Load Data

- (void) scheduleCheckUpdate
{
    [self performSelectorInBackground:@selector(generateToBuyData) withObject:nil];
}

- (void) generateToBuyData
{    
    NSEntityDescription * entity = [NSEntityDescription
                                   entityForName:@"JTObject" inManagedObjectContext:[[JTObjectManager sharedManager]managedObjectContext]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSError * error;
    NSArray * allObjects = [[[JTObjectManager sharedManager]managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
//    self.toBuyItems = [[NSMutableDictionary alloc]initWithObjectsAndKeys:array,@"Recently",array,@"Days Ago",array,@"Week Ago",array,@"Month Ago",array,@"Earlier", nil];
    self.toBuyItems = [[NSMutableArray alloc]init];
    for (JTObject * obj in allObjects)
    {
        if (obj.toBuy == YES)
        {
            [self.toBuyItems addObject:obj];
//            NSDateComponents * components = [[NSCalendar currentCalendar] components: NSSecondCalendarUnit
//                                                                           fromDate:obj.toBuyDate toDate:[NSDate date] options: 0];
//            NSInteger seconds = [components second];
//            if (seconds > 0 && seconds <= seconds * 60 * 24)
//                [self.toBuyItems setObject:[[self.toBuyItems objectForKey:@"Recently"] arrayByAddingObject:obj] forKey:@"Recently"];
//            else if (seconds > seconds * 60 * 24 && seconds <= seconds * 60 * 24 * 7)
//                [self.toBuyItems setObject:[[self.toBuyItems objectForKey:@"Days Ago"] arrayByAddingObject:obj] forKey:@"Days Ago"];
//            else if (seconds > seconds * 60 * 24 * 7 && seconds <= seconds * 60 * 60 * 24 * 30)
//                [self.toBuyItems setObject:[[self.toBuyItems objectForKey:@"Week Ago"] arrayByAddingObject:obj] forKey:@"Week Ago"];
//            else if (seconds > seconds * 60 * 24 * 30 && seconds <= seconds * 60 * 60 * 24 * 90)
//                [self.toBuyItems setObject:[[self.toBuyItems objectForKey:@"Month Ago"] arrayByAddingObject:obj] forKey:@"Month Ago"];
//            else
//                [self.toBuyItems setObject:[[self.toBuyItems objectForKey:@"Earlier"] arrayByAddingObject:obj] forKey:@"Earlier"];
        }
        NSLog(@"toBuyItems:%@",self.toBuyItems);
    }
    [self.tableView reloadData];
//    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void) refresh
{
    [self generateToBuyData];
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0f];

}

#pragma mark - Editable Table Method

- (void) editTable:(id)sender{
	if(self.editing)
	{
		[super setEditing:NO animated:NO];
		[self.tableView setEditing:NO animated:NO];
		[self.tableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
//        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
//        UIBarButtonItem * addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addToBuyItem)];
//        self.navigationItem.rightBarButtonItem = addButton;
        self.navigationItem.leftBarButtonItem = nil;
        
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
    for (JTObject * object in self.toBuyItems)
    {
        object.toBuy = NO;
        object.toBuyDate = nil;
        NSError *error;
        if (![[[JTObjectManager sharedManager]managedObjectContext] save:&error])
        {
            NSLog(@"Failed to save, error: %@", [error localizedDescription]);
        }
        else
        {
            [self.toBuyItems removeAllObjects];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
//    return [keys count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    NSArray * array = [self.toBuyItems objectForKey:[keys objectAtIndex:section]];
//    return [array count];
    return [self.toBuyItems count];
//    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    JTToBuyItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[JTToBuyItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    // Configure the cell...
    JTObject * obj = [self.toBuyItems objectAtIndex:indexPath.row];
    cell.titleLabel.text = obj.name;
    cell.categoryLabel.text = [obj.category title];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@ Added",[NSString dateFormatterShortStyle:obj.toBuyDate]];
    cell.iconImageView.image = obj.imagePath ? [UIImage imageWithData:[NSData dataWithContentsOfFile:obj.imagePath]]:[UIImage imageNamed:@"btn_placeholder_temp"];

    return cell;
}


#pragma mark - Table view delegate

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    else return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        JTObject * object = [self.toBuyItems objectAtIndex:indexPath.row];
        object.toBuy = NO;
        object.toBuyDate = nil;
        NSError *error;
        if (![[[JTObjectManager sharedManager]managedObjectContext] save:&error])
        {
            NSLog(@"Failed to save, error: %@", [error localizedDescription]);
        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                   withRowAnimation:UITableViewRowAnimationFade];
        [self.toBuyItems removeObjectAtIndex:indexPath.row];
    }
}


//- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if ([[self.toBuyItems objectForKey:[keys objectAtIndex:section]] count] > 0 ) return [keys objectAtIndex:section];
//    else return nil;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
