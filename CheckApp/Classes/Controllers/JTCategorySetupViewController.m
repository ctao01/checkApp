//
//  JTCategorySetupViewController.m
//  CheckApp
//
//  Created by Joy Tao on 4/11/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTCategorySetupViewController.h"

@interface JTCategorySetupViewController ()
@property (nonatomic , strong) NSArray * categories;
@property (nonatomic , strong) JTCategory * selectedCategory;
@end

@implementation JTCategorySetupViewController
@synthesize categories, selectedCategory;

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
    NSManagedObjectContext * context = [[JTObjectManager sharedManager] managedObjectContext];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    JTCategory * category = [self.categories objectAtIndex:indexPath.row];
    cell.textLabel.text = category.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ days",[category.period stringValue]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCategory = [self.categories objectAtIndex:indexPath.row];
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:self.selectedCategory.title message:@"Cange the period" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av show];
}

#pragma UIAlertViewDelegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        self.selectedCategory.period = [f numberFromString: [[alertView textFieldAtIndex:0] text]];
        NSError *error;
        if (![[[JTObjectManager sharedManager]managedObjectContext] save:&error])
            NSLog(@"Failed to save, error: %@", [error localizedDescription]);
        else
        {
            [self.tableView reloadData];
            self.selectedCategory = nil;
        }
    }
}


@end
