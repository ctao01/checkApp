//
//  JTCategoryViewController.h
//  CheckApp
//
//  Created by Joy Tao on 2/22/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTCategoryViewController : UIViewController <PSTCollectionViewDataSource, PSTCollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate , UIAlertViewDelegate>

@property (nonatomic,strong) NSArray * categories;
- (id)initWithNewItemName:(NSString*)name iconImagePath:(NSString*)imagePath;

@end
