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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            if (button.selected)
            {
                button.selected = NO;
                [button setBackgroundImage:[UIImage imageNamed:@"btn_expired"] forState:UIControlStateNormal];
                object.expiredDate = nil;
                object.expired = NO;
            }
            else
            {
                button.selected = YES;
                [button setTitle:@"" forState:UIControlStateSelected];
                [button setBackgroundImage:[UIImage imageNamed:@"expiredBtn_expired"] forState:UIControlStateSelected];
                object.expiredDate = [NSDate date];
                object.expired = YES;
            }
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
    if (![[[JTObjectManager sharedManger]managedObjectContext] save:&error])
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
    return 90.0f;
}
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
