//
//  JTCategoryItemCell.m
//  CheckApp
//
//  Created by Joy Tao on 2/22/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTCategoryItemCell.h"

static UIEdgeInsets ContentInsets = { .top = 8, .left = 4, .right = 4, .bottom = 0 };
static CGFloat SubTitleLabelHeight = 32;

@implementation JTCategoryItemCell
@synthesize iconImageView = _iconImageView;
@synthesize titleLabel = _titleLabel;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        UIView *background = [[UIView alloc] init];
//        background.backgroundColor = [UIColor colorWithRed:0.109 green:0.419 blue:0.000 alpha:1.000];
//        self.selectedBackgroundView = background;
        
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.backgroundColor = [UIColor grayColor];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor blackColor];
        
        [self.contentView addSubview:_iconImageView];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat imageHeight = CGRectGetHeight(self.bounds) - ContentInsets.top - SubTitleLabelHeight - ContentInsets.bottom;
    CGFloat imageWidth = CGRectGetWidth(self.bounds) - ContentInsets.left - ContentInsets.right;
    
    _iconImageView.frame = CGRectMake(ContentInsets.left, ContentInsets.top, imageWidth, imageHeight);
    _titleLabel.frame = CGRectMake(ContentInsets.left, CGRectGetMaxY(_iconImageView.frame), imageWidth, SubTitleLabelHeight);
}

@end
