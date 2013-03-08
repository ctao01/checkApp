//
//  JTToBuyItemCell.m
//  CheckApp
//
//  Created by Joy Tao on 3/6/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTToBuyItemCell.h"

@implementation JTToBuyItemCell
@synthesize dateLabel = _dateLabel, titleLabel = _titleLabel, categoryLabel = _categoryLabel;
@synthesize iconImageView = _iconImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        float deviceOS = [[[UIDevice currentDevice] systemVersion] floatValue];
        self.backgroundView = [[UIImageView alloc]init];
        self.selectedBackgroundView = [[UIImageView alloc]init];
        UIImage * backgroundImage ;
        if (deviceOS >= 5.0f) backgroundImage = [[UIImage imageNamed:@"bg_tobuyitem_cell"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 2, 30, 2)];
        else backgroundImage = [[UIImage imageNamed:@"bg_tobuyitem_cell"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0];
        ((UIImageView *)self.backgroundView).image = backgroundImage;
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(65.0f, self.contentView.frame.origin.y + 3, 200.0f, 24.0f)];
        _titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor darkGrayColor];

        _categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, 20.0f, 200.0f, 18.0f)];
        _categoryLabel.font = [UIFont fontWithName:@"ArialMT" size:14];
        _categoryLabel.backgroundColor = [UIColor clearColor];
        _categoryLabel.textColor = [UIColor grayColor];

        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, 36.0f, 200.0f, 18.0f)];
        _dateLabel.font = [UIFont fontWithName:@"ArialMT" size:14];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textColor = [UIColor grayColor];

        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_categoryLabel];
        [self.contentView addSubview:_dateLabel];
        
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
//        _iconImageView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_iconImageView];
        
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    _iconImageView.center = CGPointMake(5 + _iconImageView.frame.size.width / 2, (self.contentView.frame.origin.y + self.contentView.frame.size.height) /2);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
