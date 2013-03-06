//
//  JTHeaderView.m
//  CheckApp
//
//  Created by Joy Tao on 3/5/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTHeaderView.h"
#import "JTDetailViewController.h"
#define RADIUS 8.0f

@interface JTHeaderView ()
{
    JTDetailViewController * vc;
}

@end

@implementation JTHeaderView
@synthesize viewController;

@synthesize thumbImage;
@synthesize titleField = _titleField;
@synthesize categoryButton;
@synthesize category = _category;
@synthesize object = _object;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        vc = (JTDetailViewController*)self.viewController;
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
}
#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Getter/Setter

- (void) setCategory:(NSString *)newCategory
{
    if (_category == newCategory) return;
    NSLog(@"newCategory:%@",newCategory);
    _category = newCategory;
    [self.categoryButton setTitle:_category forState:UIControlStateNormal];
    [self.categoryButton layoutIfNeeded];
}

- (void) setObject:(JTObject *)newObject
{
    NSLog(@"headerView:%@",newObject);
    if (_object == newObject) return;
    _object = newObject;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void) drawRect:(CGRect)rect
{
    [[UIColor lightGrayColor] setStroke];
    [[UIColor whiteColor] setFill];
    
    // Drawing ImageView Rect
    [self drawThumbViewWithRect:CGRectMake(10.0f, 15.0f, 90.0f, 90.0f)];
    [self drawTextFieldWithRect:CGRectMake(100.0f, 15.0f, 210.0f, 45.0f)];
    [self drawButtonWithRect:CGRectMake(100.0f, 60.0f, 210.0f, 45.0f)];
    
//    self.layer.masksToBounds = NO;
//    self.layer.shadowColor = [[UIColor blackColor]CGColor];
//    self.layer.shadowOffset = CGSizeMake(3.0f, 5.0f);
//    self.layer.shadowOpacity = 0.7;
}

- (void) drawThumbViewWithRect:(CGRect)rect
{
    UIBezierPath * pathThumbImg = [UIBezierPath bezierPathWithRoundedRect:rect
                                                        byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopLeft
                                                              cornerRadii:CGSizeMake(RADIUS, RADIUS)];
    [pathThumbImg setLineWidth:4.0f];
    [pathThumbImg stroke];
    [pathThumbImg fill];
    
    self.thumbImage = [[UIImageView alloc]initWithFrame:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f))];
    self.thumbImage.contentMode = UIViewContentModeScaleToFill;
    self.thumbImage.image = self.object.imagePath ? [UIImage imageWithData:[NSData dataWithContentsOfFile:self.object.imagePath]]:[UIImage imageNamed:@"btn_camera_black"];
    self.thumbImage.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.thumbImage.layer.borderWidth = 2.0f;
    [self addSubview:self.thumbImage];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:self.thumbImage.frame];
    [button addTarget:vc action:@selector(activateCamera) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
}

- (void) drawTextFieldWithRect:(CGRect)rect
{
    UIBezierPath * pathThumbImg = [UIBezierPath bezierPathWithRoundedRect:rect
                                                        byRoundingCorners:UIRectCornerTopRight
                                                              cornerRadii:CGSizeMake(RADIUS, RADIUS)];
    [pathThumbImg setLineWidth:4.0f];
    [pathThumbImg stroke];
    [pathThumbImg fill];
    
    NSLog(@"drawTextFieldWithRect");
    
    self.titleField = [[UITextField alloc]initWithFrame:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(10.0f, 2.0f, 5.0f, 2.0f))];
    self.titleField.text = self.object.name ? self.object.name : @"";
    self.titleField.placeholder = self.object.name ? @"" : @"(Title)";
    self.titleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.titleField.textAlignment = NSTextAlignmentCenter;
//    [self.titleField setPlaceholder:@"Title"];
    [self.titleField setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    self.titleField.delegate = self;
    [self addSubview:self.titleField];
    
}

- (void) drawButtonWithRect:(CGRect)rect
{
    UIBezierPath * pathThumbImg = [UIBezierPath bezierPathWithRoundedRect:rect
                                                        byRoundingCorners:UIRectCornerBottomRight
                                                              cornerRadii:CGSizeMake(RADIUS, RADIUS)];
    [pathThumbImg setLineWidth:4.0f];
    [pathThumbImg stroke];
    [pathThumbImg fill];
    
    self.categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.categoryButton setFrame:rect];
    [self.categoryButton addTarget:vc action:@selector(showCategoryList) forControlEvents:UIControlEventTouchUpInside];
    [self.categoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.categoryButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    [self.categoryButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.categoryButton setTitle:_object.category ? _object.category.title : @"(Select a category)" forState:UIControlStateNormal];

    
    [self addSubview:self.categoryButton];
    
}


@end
