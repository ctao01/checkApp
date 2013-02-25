//
//  JTModalView.m
//  CheckApp
//
//  Created by Joy Tao on 2/24/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTModalView.h"
#define RADIUS 4.0f
#define CONSTANT 50.0f

@implementation JTModalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGRect frame = CGRectMake(0.0f, 0.0f, CONSTANT * 5, CONSTANT*4);
    frame.origin = CGPointMake((rect.size.width - frame.size.width) / 2 ,
                               (rect.size.height - frame.size.height) / 2);
    
    [self drawTheCenterRect:frame];
    
    CGRect innerFrame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(20.0f, 10.0f, 20.0f, 10.0f));
    CGRect topFrame = UIEdgeInsetsInsetRect(innerFrame, UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f));
    CGRect lowerFrame = UIEdgeInsetsInsetRect(innerFrame, UIEdgeInsetsMake(120.0f, 0.0f, 0.0f, 0.0f));

    [self drawThumbViewWithRect:CGRectMake(topFrame.origin.x, topFrame.origin.y, 80.0f, 80.0f)];
    [self attachTwoButtonsWithRect:lowerFrame];

}

- (void) drawTheCenterRect:(CGRect)rect
{
    UIBezierPath * centerRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:RADIUS];
    
    [[UIColor colorWithRed:64.0f/255.0f green:141.0f/255.0f blue:204.0f/255.0f alpha:1.0f] setFill];
//    [[UIColor colorWithRed:193.0f/255.0f green:204.0f/255.0f blue:205.0f/255.0f alpha:1.0f] setFill];

    [[UIColor whiteColor]setStroke];
    
    [centerRect setLineWidth:5.0f];
    [centerRect stroke];
    [centerRect fill];
}


- (void) drawThumbViewWithRect:(CGRect)rect
{
    UIBezierPath * pathThumbImg = [UIBezierPath bezierPathWithRoundedRect:rect
                                                        byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopLeft
                                                              cornerRadii:CGSizeMake(RADIUS/2, RADIUS/2)];
    [[UIColor lightGrayColor] setStroke];
    [[UIColor whiteColor] setFill];
    [pathThumbImg setLineWidth:2.0f];
    [pathThumbImg stroke];
    [pathThumbImg fill];
    
    UIImageView * img = [[UIImageView alloc]initWithFrame:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f))];
    img.backgroundColor = [UIColor redColor];
    [self addSubview:img];
    
    [self drawTitleTextFieldWithRect:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, 150.0f, 40.0f)];
}

- (void) drawTitleTextFieldWithRect:(CGRect)rect
{
    UIBezierPath * pathThumbImg = [UIBezierPath bezierPathWithRoundedRect:rect
                                                        byRoundingCorners:UIRectCornerTopRight
                                                              cornerRadii:CGSizeMake(RADIUS/2, RADIUS/2)];
    [[UIColor lightGrayColor] setStroke];
    [[UIColor whiteColor] setFill];
    [pathThumbImg setLineWidth:2.0f];
    [pathThumbImg stroke];
    [pathThumbImg fill];
    [self drawCategoryTextFieldWithRect:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, 150.0f, 40.0f)];

    
}

- (void) drawCategoryTextFieldWithRect:(CGRect)rect
{
    UIBezierPath * pathThumbImg = [UIBezierPath bezierPathWithRoundedRect:rect
                                                        byRoundingCorners:UIRectCornerBottomRight
                                                              cornerRadii:CGSizeMake(RADIUS/2, RADIUS/2)];
    [[UIColor lightGrayColor] setStroke];
    [[UIColor whiteColor] setFill];
    [pathThumbImg setLineWidth:2.0f];
    [pathThumbImg stroke];
    [pathThumbImg fill];
}

- (void) attachTwoButtonsWithRect:(CGRect)rect
{
//    UIView * v1 = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 30.0f)];
//    v1.frame = CGRectOffset(v1.frame, rect.origin.x + rect.size.width/4 - v1.frame.size.width/2, rect.origin.y);
//    v1.backgroundColor = [UIColor colorWithRed:64.0f/255.0f green:204.0f/255.0f blue:127.0f/255.0f alpha:1.0f];
//    NSLog(@"%@",NSStringFromCGRect(v1.frame));
    
    CGRect buttonFrame = CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
    
    UIImage *originalImage = [UIImage imageNamed:@"modalButton_green"];
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 40.0f, 0.0f, 40.0f);
    UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:insets];
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:buttonFrame];
     [btn1 setFrame:CGRectOffset(btn1.frame, rect.origin.x + rect.size.width/4 - btn1.frame.size.width/2, rect.origin.y)];
    [btn1 setBackgroundImage:stretchableImage forState:UIControlStateNormal];
    [btn1 setTitle:@"Add" forState:UIControlStateNormal];
    
    
    UIView * v2 = [[UIView alloc]initWithFrame:btn1.frame];
    v2.center = CGPointMake(btn1.center.x + rect.size.width/2, v2.center.y);
    v2.backgroundColor = [UIColor redColor];

    
    [self addSubview:btn1];
    [self addSubview:v2];
}

@end
