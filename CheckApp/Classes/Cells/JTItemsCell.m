//
//  JTItemsCell.m
//  CheckApp
//
//  Created by Joy Tao on 3/4/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTItemsCell.h"
#import "JTItemsViewController.h"

@interface JTItemsCell ()

@end

@implementation JTItemsCell
@synthesize tableViewController;
@synthesize object = _object;
@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;
@synthesize iconImageView = _iconImageView;

- (void) setObject:(JTObject *)object
{
    if (_object == object) return;
    [_object release];
    _object = [object retain];
    
//    NSTimeInterval diff = [_object.expiredDate timeIntervalSinceDate:[NSDate date]];
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSDayCalendarUnit
                                                                   fromDate:[NSDate date] toDate: _object.expiredDate options: 0];
    UIButton * button1 = (UIButton*)[self viewWithTag:1001];
    UIButton * button2 = (UIButton*)[self viewWithTag:1002];

    if (button1)
    {
        [button1 setTitle:[NSString stringWithFormat:@"%i days",[components day]] forState:UIControlStateNormal];
    }
    //    button1.titleLabel.text = [NSString stringWithFormat:@"%f days",diff/86400];
    if (button2)
    {
        if (_object.toBuy == NO) button2.selected = NO;
        else button2.selected = YES;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        JTItemsViewController * vc = (JTItemsViewController*)self.tableViewController;
        
        // Expire Date
        
        UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * btn1Image;
        if (self.object.expired == NO)
        {
            btn1Image = [UIImage imageNamed:@"btn_expired"];
            [button1 setBackgroundImage:btn1Image forState:UIControlStateNormal];
        }
        else
        {
            btn1Image = [UIImage imageNamed:@"expiredBtn_expired"];
            [button1 setBackgroundImage:btn1Image forState:UIControlStateSelected];
        }
        [button1 setFrame:CGRectMake(10.0f, 65.0f, btn1Image.size.width, btn1Image.size.height)];
        
        [button1 setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 24.0f, 5.0, 5.0)];
        button1.titleLabel.font = [UIFont systemFontOfSize:12];
        
        button1.tag = 1001;
        [button1 addTarget:vc action:@selector(buttonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
        
        // To-Buy List
        
        UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * btn2Image;
        
        btn2Image = [UIImage imageNamed:@"toBuyBtn"];
        [button2 setFrame:CGRectMake(button1.frame.origin.x + button1.frame.size.width + 18, button1.frame.origin.y , btn2Image.size.width, btn2Image.size.height)];
        [button2 setBackgroundImage:btn2Image forState:UIControlStateNormal];
        [button2 setBackgroundImage:[UIImage imageNamed:@"toBuyBtn_disable"] forState:UIControlStateSelected];
        button2.tag = 1002;
        [button2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button2 addTarget:vc action:@selector(buttonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
        
        // Delete Button
        
        UIButton * button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * btn3Image = [UIImage imageNamed:@"deleteBtn"];
        [button3 setFrame:CGRectMake(button2.frame.origin.x + button2.frame.size.width + 18, button2.frame.origin.y , btn3Image.size.width, btn3Image.size.height)];
        [button3 setBackgroundImage:btn3Image forState:UIControlStateNormal];
        button3.tag = 1003;
        [button3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button3 addTarget:vc action:@selector(buttonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:button1];
        [self addSubview:button2];
        [self addSubview:button3];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(64.0f, self.imageView.frame.origin.y, 200.0f, 32.0f)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, 32.0f, 200.0f, 24.0f)];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:12];

        [self addSubview:_titleLabel];
        [self addSubview:_dateLabel];
        
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10.0f, 0.0f, 44.0f, 44.0f);
    self.imageView.center = CGPointMake(self.imageView.center.x, 60.0f / 2.0f);
    self.imageView.backgroundColor = [UIColor whiteColor];
    
    self.imageView.layer.shadowOpacity = 0.7f;
    self.imageView.layer.shadowRadius = 2.0f;
    self.imageView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    
    self.imageView.layer.masksToBounds = NO;
    self.imageView.layer.shadowPath = [self renderPaperCurl:self.imageView];
    
}

- (void) drawRect:(CGRect)rect
{
    UIBezierPath * path = [UIBezierPath bezierPath];
    CGPoint startOfLine = CGPointMake(10.0f, 60.0f);
    CGPoint endOfLine = CGPointMake(rect.origin.x + rect.size.width - 20.0f, 60.0f);
    
    [path moveToPoint:startOfLine];
    [path addLineToPoint:endOfLine];
    
    [[UIColor redColor] setStroke];
    [path stroke];
    
}

- (CGPathRef)renderPaperCurl:(UIView*)imgView
{
    CGSize size = self.imageView.bounds.size;
    CGFloat curlFactor = 6.0f;
    CGFloat shadowDepth = 3.0f;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0f, 0.0f)];
    [path addLineToPoint:CGPointMake(size.width, 0.0f)];
    [path addLineToPoint:CGPointMake(size.width, size.height + shadowDepth)];
    [path addCurveToPoint:CGPointMake(0.0f, size.height + shadowDepth)
            controlPoint1:CGPointMake(size.width - curlFactor, size.height + shadowDepth - curlFactor)
            controlPoint2:CGPointMake(curlFactor, size.height + shadowDepth - curlFactor)];
    
    return path.CGPath;
}

- (void) drawImageViewShadow:(CGRect)rect
{
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor blackColor] setStroke];
    [path stroke];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (void) dealloc
{
    [super dealloc];
}

@end
