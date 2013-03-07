//
//  JTItemGroupedCell.m
//  CheckApp
//
//  Created by Joy Tao on 3/6/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTItemGroupedCell.h"
#import "JTButtonsLayerView.h"
#import "JTItemsViewController.h"

@implementation JTItemGroupedCell
@synthesize tableViewController;
@synthesize object = _object;
@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        // Initialization code
        NSLog(@"Initialization code");
        float deviceOS = [[[UIDevice currentDevice] systemVersion] floatValue];
        self.backgroundView = [[UIImageView alloc]init];
        self.selectedBackgroundView = [[UIImageView alloc]init];
        UIImage * backgroundImage ;
        if (deviceOS >= 5.0f) backgroundImage = [[UIImage imageNamed:@"bg_item_cell_x80"] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 2, 40, 2)];
        else backgroundImage = [[UIImage imageNamed:@"bg_item_cell_x80"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0];
        ((UIImageView *)self.backgroundView).image = backgroundImage;
        
        JTButtonsLayerView * buttonsView = [[JTButtonsLayerView alloc]initWithFrame:CGRectMake(0.0f, 50.0f, self.contentView.bounds.size.width - 20.0f, 30.0f)];
        [buttonsView setCell:self];
        [self.contentView addSubview:buttonsView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(64.0f, self.contentView.frame.origin.y + 2, 200.0f, 32.0f)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, 28.0f, 200.0f, 18.0f)];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:12];
        
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_dateLabel];
        
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10.0f, -2.0f, 44.0f, 44.0f);
    self.imageView.center = CGPointMake(self.imageView.center.x, 50.0f / 2.0f);
    self.imageView.backgroundColor = [UIColor whiteColor];
    
    self.imageView.layer.shadowOpacity = 0.7f;
    self.imageView.layer.shadowRadius = 2.0f;
    self.imageView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    
    self.imageView.layer.masksToBounds = NO;
//    self.imageView.layer.shadowPath = [self renderPaperCurl:self.imageView];
    
//    UIButton * button1 = (UIButton*)[self viewWithTag:1001];
//    UIButton * button2 = (UIButton*)[self viewWithTag:1002];
//    UIButton * button3 = (UIButton*)[self viewWithTag:1003];

//}
}

#pragma mark -

- (void) setTitleOnButtons:(id)sender
{
    UIButton * btn = (UIButton*)sender;
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSDayCalendarUnit
                                                                   fromDate:[NSDate date] toDate: self.object.expiredDate options: 0];
    if (btn.tag == 1001)
    {
        if (self.object.expired == YES)
        {
            [btn setEnabled:NO];
            [btn setTitle:@"" forState:UIControlStateDisabled];
        }
        else
        {
            NSInteger days = [components day];
            if (days >= 365) [btn setTitle:[NSString stringWithFormat:@"%@ years",[NSNumber numberWithDouble:floor([components day]/365)]] forState:UIControlStateNormal];
            else if (days < 365 && days >= 30) [btn setTitle:[NSString stringWithFormat:@"%@ months",[NSNumber numberWithDouble:floor([components day]/30)]] forState:UIControlStateNormal];
            else [btn setTitle:[NSString stringWithFormat:@"%i days",[components day]] forState:UIControlStateNormal];
        }
    }
    else if (btn.tag == 1002)
    {
        if (self.object.toBuy == NO) btn.selected = NO;
        else btn.selected = YES;
    }
}

- (void) setObject:(JTObject *)object
{
    if (_object == object) return;
    _object = object;
    
    NSLog(@"%@",object);
//    //    NSTimeInterval diff = [_object.expiredDate timeIntervalSinceDate:[NSDate date]];
//    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSDayCalendarUnit
//                                                                   fromDate:[NSDate date] toDate: _object.expiredDate options: 0];
//    UIButton * button1 = (UIButton*)[self viewWithTag:1001];
//    UIButton * button2 = (UIButton*)[self viewWithTag:1002];
//    
//    if (button1)
//    {
//        if (_object.expired == YES)
//        {
//            [button1 setEnabled:NO];
//            [button1 setTitle:@"" forState:UIControlStateDisabled];
//        }
//        else
//        {
//            NSInteger days = [components day];
//            if (days >= 365) [button1 setTitle:[NSString stringWithFormat:@"%@ yrs",[NSNumber numberWithDouble:floor([components day]/365)]] forState:UIControlStateNormal];
//            else if (days < 365 && days >= 30) [button1 setTitle:[NSString stringWithFormat:@"%@ mos",[NSNumber numberWithDouble:floor([components day]/30)]] forState:UIControlStateNormal];
//            else [button1 setTitle:[NSString stringWithFormat:@"%i days",[components day]] forState:UIControlStateNormal];
//        }
//    }
//    if (button2)
//    {
//        if (_object.toBuy == NO) button2.selected = NO;
//        else button2.selected = YES;
//    }
}

#pragma mark - Drawing Function

- (void) drawSeperateLine:(CGRect)rect
{
    NSLog(@"drawSeperateLine");
    
    [[UIColor lightGrayColor] setStroke];
    
    CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width, startPoint.y);
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [path stroke];
    [path setLineWidth:2.0f];
}

- (void) setupExpiredButton:(CGRect)rect
{
    [[UIColor lightGrayColor] setStroke];
    UIBezierPath * firstPath = [UIBezierPath bezierPath];
    [firstPath moveToPoint:CGPointMake(rect.origin.x + rect.size.width / 3, rect.origin.y)];
    [firstPath addLineToPoint:CGPointMake(rect.origin.x + rect.size.width / 3, rect.origin.y + rect.size.height)];
    [firstPath stroke];
    [firstPath setLineWidth:3.0f];

    CGRect outterFrame = CGRectMake(rect.origin.x, 50.0f, rect.size.width / 3, rect.size.height);
    CGRect innerFrame = UIEdgeInsetsInsetRect(outterFrame, UIEdgeInsetsMake(5.0f, 3.0f, 5.0f, 2.0f));
    UIButton * button = [[UIButton alloc]initWithFrame:innerFrame];
    button.tag = 1001;
    [button setBackgroundImage:[UIImage imageNamed:@"btn_expireDays"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_expired"] forState:UIControlStateDisabled];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(8.0f, 15.0f, 5.0, 5.0)];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
//    button.titleLabel.textColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    JTItemsViewController * vc = (JTItemsViewController*)self.tableViewController;
    [button addTarget:vc action:@selector(buttonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:button];
    [self setTitleOnButtons:button];
}

- (void) setupButtons:(CGRect)rect
{
    JTItemsViewController * vc = (JTItemsViewController*)self.tableViewController;
    
    [[UIColor lightGrayColor] setStroke];
    UIBezierPath * firstPath = [UIBezierPath bezierPath];
    [firstPath moveToPoint:CGPointMake(rect.origin.x + rect.size.width * 2 / 3, rect.origin.y)];
    [firstPath addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * 2 / 3, rect.origin.y + rect.size.height)];
    [firstPath stroke];
    [firstPath setLineWidth:3.0f];
    
    CGRect outterFrame = CGRectMake(rect.origin.x + rect.size.width / 3, 50.0f, rect.size.width / 3, rect.size.height);
    CGRect innerFrame = UIEdgeInsetsInsetRect(outterFrame, UIEdgeInsetsMake(5.0f, 3.0f, 5.0f, 2.0f));
    NSLog(@"%@",NSStringFromCGRect(innerFrame));
    UIButton * buyButton = [[UIButton alloc]initWithFrame:innerFrame];
    buyButton.tag = 1002;
    [buyButton setBackgroundImage:[UIImage imageNamed:@"btn_toBuy_normal"] forState:UIControlStateNormal];
    [buyButton setBackgroundImage:[UIImage imageNamed:@"btn_toBuy_selected"] forState:UIControlStateSelected];
    [buyButton addTarget:vc action:@selector(buttonTapped:event:) forControlEvents:UIControlEventTouchUpInside];

    CGRect outterRect = CGRectMake(outterFrame.origin.x + outterFrame.size.width, outterFrame.origin.y, rect.size.width / 3, rect.size.height);
    CGRect innerRect = UIEdgeInsetsInsetRect(outterRect, UIEdgeInsetsMake(5.0f, 3.0f, 5.0f, 2.0f));
    UIButton * trashButton = [[UIButton alloc]initWithFrame:innerRect];
    trashButton.tag = 1003;
    [trashButton addTarget:vc action:@selector(buttonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    [trashButton setBackgroundImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];

    [self.contentView addSubview:buyButton];
    [self.contentView addSubview:trashButton];
    
    [self setTitleOnButtons:buyButton];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}



@end
