//
//  JTItemGroupedCell.h
//  CheckApp
//
//  Created by Joy Tao on 3/6/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTItemGroupedCell : UITableViewCell

@property (nonatomic, retain) UIViewController * tableViewController;
@property (nonatomic , retain) JTObject * object;

@property (nonatomic, retain) UILabel * titleLabel;
@property (nonatomic, retain) UILabel * dateLabel;
@property (nonatomic, retain) UIImageView * iconImageView;

- (void) drawSeperateLine:(CGRect)rect;
- (void) setupExpiredButton:(CGRect)rect;
- (void) setupButtons:(CGRect)rect;


@end
