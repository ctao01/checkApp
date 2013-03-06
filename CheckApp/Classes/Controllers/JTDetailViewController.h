//
//  JTDetailViewController.h
//  CheckApp
//
//  Created by Joy Tao on 3/5/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTDetailViewController : UITableViewController < UIImagePickerControllerDelegate , UINavigationControllerDelegate >
@property (nonatomic , retain) JTObject * object;

- (id)initWithStyle:(UITableViewStyle)style withObject:(JTObject*)object;

@end
