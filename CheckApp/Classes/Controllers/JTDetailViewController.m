//
//  JTDetailViewController.m
//  CheckApp
//
//  Created by Joy Tao on 3/5/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTDetailViewController.h"
#import "JTHeaderView.h"
#import "NSString+JTAdditions.h"
#import "UIImage+JTAdditions.h"
#import "JTCategoryViewController.h"

@interface JTDetailViewController ()
{
    JTHeaderView * headerView;
    UIView * footerView;
}

@end

@implementation JTDetailViewController
@synthesize object = _object;

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (id)initWithStyle:(UITableViewStyle)style withObject:(JTObject*)object
{
    self = [super initWithStyle:style];
    if (self)
    {
        if (object == nil)
            _object = [NSEntityDescription insertNewObjectForEntityForName:@"JTObject"
                                                     inManagedObjectContext:[[JTObjectManager sharedManager] managedObjectContext]];
        else _object = object;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem * save = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveItem)];
    self.navigationItem.rightBarButtonItem = save;
    
    NSLog(@"%@",self.object);
    
    headerView = [[JTHeaderView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 120.0f)];
    headerView.viewController = self;
    headerView.object = self.object;
    headerView.tag = 4000;
    
    self.tableView.tableHeaderView = headerView;

    footerView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 100.0f)];
    footerView.backgroundColor = [UIColor clearColor];
    
    if (self.object.updatedDate != nil)
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 280.0f, 60.0f)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.numberOfLines = 0;
        label.text = [NSString stringWithFormat:@"Lastest Update:\n%@",[NSString dateFormatterLongStyle:self.object.updatedDate]];
        label.center = footerView.center;
        label.font = [UIFont fontWithName:@"Arial-ItalicMT" size:14];
        label.tag = 5000;
        [footerView addSubview:label];
    }
    else
    {
        UIBarButtonItem * cancel = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered  target:self action:@selector(cancel)];
        self.navigationItem.leftBarButtonItem = cancel;
    }
    
    self.tableView.tableFooterView = footerView;
}

- (void) saveItem
{
    [self.object setName:headerView.titleField.text];
    [self.object setCategory:self.object.category];
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
        if (self.object.imagePath == nil) [self.object setImagePath:nil];
        
        NSError *error;
        if (![[[JTObjectManager sharedManager] managedObjectContext] save:&error])
        {
            NSLog(@"Failed to save, error: %@", [error localizedDescription]);
        }
        else [self.navigationController popViewControllerAnimated:YES];

    }
}

- (void) cancel
{
    self.object = nil;
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (void)activateCamera
{
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate =self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = NO;
    
    [self presentViewController:picker animated:YES completion:^{
    }];
}

-(void) showCategoryList
{
    JTCategoryViewController * vc1 = [[JTCategoryViewController alloc]initFromViewController:self];
    UINavigationController * nc1 = [[UINavigationController alloc]initWithRootViewController:vc1];
    vc1.navigationItem.title = @"Select A Category";
    
    [self presentViewController:nc1 animated:YES completion:^{}];
    
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage * rotatedImage = [UIImage scaleAndRotateImage:image];
    [self.object setImagePath:[NSString imagePathWithItemName:self.object.name]];
    NSData * pngData = UIImagePNGRepresentation(rotatedImage);
    [pngData writeToFile:self.object.imagePath atomically:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellAccessoryNone;
    if (indexPath.row == 0){
        cell.textLabel.text = @"Expire Date";
        cell.detailTextLabel.text = [NSString dateFormatterMediumStyleWithoutTime:self.object.expiredDate];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
