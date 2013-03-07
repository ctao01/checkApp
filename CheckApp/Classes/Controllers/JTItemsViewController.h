//
//  JTItemsViewController.h
//  CheckApp
//
//  Created by Joy Tao on 2/22/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTPullRefreshTableViewController.h"

@interface JTItemsViewController : JTPullRefreshTableViewController <UIAlertViewDelegate>

@property (nonatomic , retain) NSMutableArray * items;
@end
