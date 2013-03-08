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
    
    UIDatePicker * picker;

}

@end

@implementation JTDetailViewController
@synthesize object = _object;

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
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:62.0f/255.0f green:62.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
    
    NSLog(@"%@",self.object);
    
    headerView = [[JTHeaderView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 140.0f)];
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
        label.textColor = [UIColor whiteColor];
        label.tag = 5000;
        [footerView addSubview:label];
    }
    else
    {
        UIBarButtonItem * cancel = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered  target:self action:@selector(cancel)];
        self.navigationItem.leftBarButtonItem = cancel;
    }
    
    self.tableView.tableFooterView = footerView;
    
    CGRect bounds = [[UIScreen mainScreen]bounds];
    picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0.0f, bounds.size.height - 250.0f -44.0f, bounds.size.width, 250.0f +44.0f)];
    picker.datePickerMode = UIDatePickerModeDate;
    
    NSDate * oneHourAheadDate = [[NSDate date] dateByAddingTimeInterval:60 * 60];
    picker.date = oneHourAheadDate;
    [picker addTarget:self action:@selector(changeDateReminder:) forControlEvents:UIControlEventValueChanged];
    [picker setBackgroundColor:[UIColor clearColor]];
    picker.hidden = YES;
    [self.view addSubview:picker];
    
}

#pragma mark -

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
        [self.object setUpdatedDate:[NSDate date]];
        [self.object setExpiredDate:self.object.expiredDate];  // TODO:
        [self.object setExpired:NO];
        [self.object setToBuy:self.object.toBuy];
        [self.object setToBuyDate:self.object.toBuyDate];
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

#pragma mark - Date Picker Mehtod

- (void)changeDateReminder:(id)sender
{
//    UIDatePicker * dPicker = (UIDatePicker*)sender;
//    
//    [self.tableView reloadData];
//    [self.object setExpiredDate:dPicker.date];
}

- (void) doneDatePicker
{
    [picker setHidden:YES];
    UIBarButtonItem * save = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveItem)];
    self.navigationItem.rightBarButtonItem = save;
    self.navigationItem.leftBarButtonItem = nil;
    
    [self.object setExpiredDate:picker.date];
    [self.tableView reloadData];
    
}

- (void) cancelDatePicker
{
    [picker setHidden:YES];
    UIBarButtonItem * save = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveItem)];
    self.navigationItem.rightBarButtonItem = save;
    self.navigationItem.leftBarButtonItem = nil;
}

#pragma mark - JTHeaderView Button Actions

- (void) activateCamera
{
    UIImagePickerController * imgPicker = [[UIImagePickerController alloc]init];
    imgPicker.delegate =self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imgPicker.allowsEditing = NO;
    
    [self presentViewController:imgPicker animated:YES completion:^{
//        [self dismissDatePicker];
    }];
}

-(void) showCategoryList
{
    JTCategoryViewController * vc1 = [[JTCategoryViewController alloc]initFromViewController:self];
    UINavigationController * nc1 = [[UINavigationController alloc]initWithRootViewController:vc1];
    vc1.navigationItem.title = @"Select A Category";
    
    [self presentViewController:nc1 animated:YES completion:^{
    }];
}


- (void) enlargeImageView
{
    CGRect screenRect = self.view.frame;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 4.0f, 4.0f)];
    imageView.center = self.view.center;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tag = 7000;
    [self.view addSubview:imageView];
    
    [UIView animateWithDuration:0.8f
                          delay:0.0f
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, screenRect.size.width * 0.8f, screenRect.size.height * 0.8f);
                         imageView.center = CGPointMake(screenRect.size.width / 2, screenRect.size.height /2);
                         [imageView setImage:self.object.imagePath ? [UIImage imageWithData:[NSData dataWithContentsOfFile:self.object.imagePath]]:[UIImage imageNamed:@"btn_camera_black"]];
                         imageView.backgroundColor = [UIColor whiteColor];
                     }
                     completion:^(BOOL finished){
                         UIImage * image = [UIImage imageNamed:@"btn_close_red_center"];
                         UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                         [button setFrame:CGRectMake(0.0f, 0.0f, image.size.width, image.size.height)];
                         [button setCenter:CGPointMake(imageView.frame.origin.x, imageView.frame.origin.y)];
                         [button setBackgroundImage:image forState:UIControlStateNormal];
                         [button addTarget:self action:@selector(closeLargeView) forControlEvents:UIControlEventTouchUpInside];
                         button.tag = 7001;
                         [self.view addSubview:button];
                     }];
}

- (void) closeLargeView
{
    UIView * imageView = [self.view viewWithTag:7000];
    UIView * btnView = [self.view viewWithTag:7001];
    
    [UIView animateWithDuration:0.8f
                          delay:0.0f
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                     }
                     completion:^(BOOL finished){
                         if (imageView) [imageView removeFromSuperview];
                         if (btnView) [btnView removeFromSuperview];
                     }];
    
    
}

- (void)buttonTapped:(id)sender event:(UIEvent *)event
{
    UIButton * button = (UIButton*)sender;
    
    switch (button.tag) {
        case 2100:
        {
            
            if (button.selected)
            {
                [self.object setToBuyDate:nil];
                [self.object setToBuy:NO];
                button.selected = NO;
                [button setBackgroundImage:[UIImage imageNamed:@"btn_header_tobuy"] forState:UIControlStateNormal];
                
            }
            else
            {
                [self.object setToBuyDate:[NSDate date]];
                [self.object setToBuy:YES];
                button.selected = YES;
                [button setBackgroundImage:[UIImage imageNamed:@"btn_header_tobuy_selected"] forState:UIControlStateSelected];
            }
            UILabel * label = (UILabel *)[self.view viewWithTag:5000];
            label.text = [NSString stringWithFormat:@"Lastest Update:\n%@",[NSString dateFormatterLongStyle:self.object.updatedDate]];
            [label layoutIfNeeded];
            
        }
            break;
        case 1003:
        {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Would you like to delete the item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure", nil];
            [alertView show];
        }
        default:
            break;
    }
    [self.object setUpdatedDate:[NSDate date]];
    
}

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
//    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    if (switchControl.on) NSLog(@"Add To Calendar");
    else NSLog(@"remove form calendar");
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
        
        JTHeaderView * view = (JTHeaderView*)[self.view viewWithTag:4000];
        [view.thumbImage setImage:image];
        [view.thumbImage layoutIfNeeded];
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
    else if (indexPath.row == 1)
    {
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        [switchView setOn:NO animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    cell.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    cell.backgroundView = [[UIImageView alloc]init];
    UIImage * backgroundImage ;
    float deviceOS = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (deviceOS >= 5.0f)
    {
        if (indexPath.row == 0)backgroundImage = [[UIImage imageNamed:@"bg_tobuyitem_cell_top"] resizableImageWithCapInsets:UIEdgeInsetsMake(22, 3, 22, 3)];
        else if (indexPath.row == 1) backgroundImage = [[UIImage imageNamed:@"bg_tobuyitem_cell_bottom"] resizableImageWithCapInsets:UIEdgeInsetsMake(22, 3, 22, 3)];
    }
    else backgroundImage = [[UIImage imageNamed:@"bg_tobuyitem_cell"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0];
    ((UIImageView *)cell.backgroundView).image = backgroundImage;
    ((UIImageView *)cell.backgroundView).backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 )
    {
        if (indexPath.row == 0)
        {
            [picker setHidden:NO];
            
            UIBarButtonItem * doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDatePicker)];
            self.navigationItem.rightBarButtonItem = doneBtn;
            
            UIBarButtonItem * cancelBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDatePicker)];
            self.navigationItem.leftBarButtonItem = cancelBtn;
        }
//        else if (indexPath.row == 1) [picker setHidden:YES];
    }
}

@end
