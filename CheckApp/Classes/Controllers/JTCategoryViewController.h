//
//  JTCategoryViewController.h
//  CheckApp
//
//  Created by Joy Tao on 2/22/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface JTCategoryViewController : UIViewController <PSTCollectionViewDataSource, PSTCollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate , UIAlertViewDelegate , ADBannerViewDelegate>

@property (nonatomic,strong) NSArray * categories;
- (id)initWithNewItemName:(NSString*)name iconImagePath:(NSString*)imagePath;
- (id) initFromViewController:(UIViewController*)vc;

@end
