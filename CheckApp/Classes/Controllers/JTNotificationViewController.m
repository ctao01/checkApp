//
//  JTNotificationViewController.m
//  CheckApp
//
//  Created by Joy Tao on 3/8/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTNotificationViewController.h"

@interface JTNotificationViewController ()
@property (nonatomic , retain) NSMutableArray * collections;
@end

@implementation JTNotificationViewController
@synthesize collections;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self generateData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) generateData
{
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"JTObject" inManagedObjectContext:[[JTObjectManager sharedManager]managedObjectContext]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSError * error;
    NSArray * allObjects = [[[JTObjectManager sharedManager]managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    collections = [[NSMutableArray alloc]init];
    for (JTObject * obj in allObjects)
    {
        NSDateComponents *components = [[NSCalendar currentCalendar] components: NSDayCalendarUnit
                                                                       fromDate:obj.toBuyDate toDate:[NSDate date]  options: 0];
        if (obj.expired == YES || ([components day]>= 14.0f) )
            [collections addObject:obj];
    }
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"expiredDate" ascending:NO];
    [collections sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [self.tableView reloadData];
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0f];
}

- (void) refresh
{
    [self generateData];
}

#pragma mark - UITableView Data Source

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.collections count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTObject * object = [self.collections objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.textLabel.text = object.name;
    cell.detailTextLabel.text = object.category.title;
    
    return cell;
}

#pragma mark - UITableView Delegate


@end
