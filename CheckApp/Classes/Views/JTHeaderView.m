//
//  JTHeaderView.m
//  CheckApp
//
//  Created by Joy Tao on 3/5/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTHeaderView.h"
#import "JTDetailViewController.h"
#define RADIUS 2.0f

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
    [[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f] setFill];
    
    // Drawing ImageView Rect
    [self drawThumbViewWithRect:CGRectMake(10.0f, 20.0f, 64.0f, 64.0f)];
    [self drawTextFieldWithRect:CGRectMake(74.0f, 20.0f, 310.0f - 74.0f, 32.0f)];
    [self drawButtonWithRect:CGRectMake(74.0f, 52.0f, 310.0f - 74.0f, 32.0f)];
    

    [self setupButtons:CGRectMake(10.0f, 104.0f, 300.0f, 32.0f)];
    
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
    [pathThumbImg setLineWidth:1.0f];
    [pathThumbImg stroke];
    [pathThumbImg fill];
    
    self.thumbImage = [[UIImageView alloc]initWithFrame:rect];
    self.thumbImage.contentMode = UIViewContentModeScaleToFill;
    self.thumbImage.image = self.object.imagePath ? [UIImage imageWithData:[NSData dataWithContentsOfFile:self.object.imagePath]]:[UIImage imageNamed:@"btn_camera_black"];
//    self.thumbImage.layer.borderColor = [[UIColor darkGrayColor] CGColor];
//    self.thumbImage.layer.borderWidth = 2.0f;
    [self addSubview:self.thumbImage];
    
//    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setFrame:self.thumbImage.frame];
//    [button addTarget:vc action:@selector(activateCamera) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:button];
    
}

- (void) drawTextFieldWithRect:(CGRect)rect
{
    UIBezierPath * pathThumbImg = [UIBezierPath bezierPathWithRoundedRect:rect
                                                        byRoundingCorners:UIRectCornerTopRight
                                                              cornerRadii:CGSizeMake(RADIUS, RADIUS)];
    [pathThumbImg setLineWidth:1.0f];
    [pathThumbImg stroke];
    [pathThumbImg fill];
    
    NSLog(@"drawTextFieldWithRect");
    
    self.titleField = [[UITextField alloc]initWithFrame:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(10.0f, 38.0f, 5.0f, 2.0f))];
    self.titleField.text = self.object.name ? self.object.name : @"";
    self.titleField.placeholder = self.object.name ? @"" : @"(Title)";
    self.titleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.titleField.textAlignment = NSTextAlignmentCenter;
//    [self.titleField setPlaceholder:@"Title"];
    [self.titleField setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    self.titleField.delegate = self;
    [self addSubview:self.titleField];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 20.0f)];
    label.frame = CGRectOffset(label.frame, rect.origin.x + 10.0f , rect.origin.y + 8.0f);
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Arial-ItalicMT" size:14];
    label.text = @"Name:";
    [self addSubview:label];
    
}

- (void) drawButtonWithRect:(CGRect)rect
{
    UIBezierPath * pathThumbImg = [UIBezierPath bezierPathWithRoundedRect:rect
                                                        byRoundingCorners:UIRectCornerBottomRight
                                                              cornerRadii:CGSizeMake(RADIUS, RADIUS)];
    [pathThumbImg setLineWidth:1.0f];
    [pathThumbImg stroke];
    [pathThumbImg fill];
    
    self.categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.categoryButton setFrame:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0.0f, 36.0f, 0.0f, 0.0f))];
    [self.categoryButton addTarget:vc action:@selector(showCategoryList) forControlEvents:UIControlEventTouchUpInside];
    [self.categoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.categoryButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.categoryButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.categoryButton setTitle:_object.category ? _object.category.title : @"(Select a category)" forState:UIControlStateNormal];

    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 20.0f)];
    label.frame = CGRectOffset(label.frame, rect.origin.x + 10.0f , rect.origin.y + 5.0f);
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Arial-ItalicMT" size:14];
    label.text = @"Category:";
    [self addSubview:label];
    
    [self addSubview:self.categoryButton];
    
}

- (void) setupButtons:(CGRect)rect
{
    UIButton * browseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [browseButton setFrame:CGRectMake(rect.origin.x, rect.origin.y, 90.0f, rect.size.height)];
    [browseButton setBackgroundImage:[UIImage imageNamed:@"btn_header_browse"] forState:UIControlStateNormal];
    [browseButton addTarget:vc action:@selector(enlargeImageView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:browseButton];
    
    UIButton * tobuyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tobuyButton setFrame:CGRectMake(browseButton.frame.origin.x + browseButton.frame.size.width + 15.0f, browseButton.frame.origin.y, 90.0f, rect.size.height)];
    [tobuyButton setBackgroundImage:[UIImage imageNamed:@"btn_header_tobuy"] forState:UIControlStateNormal];
    [tobuyButton setBackgroundImage:[UIImage imageNamed:@"btn_header_tobuy_selected"] forState:UIControlStateSelected];
    tobuyButton.tag = 2100;
    [tobuyButton addTarget:vc action:@selector(buttonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tobuyButton];
    
    UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setFrame:CGRectMake(tobuyButton.frame.origin.x + tobuyButton.frame.size.width + 15.0f, tobuyButton.frame.origin.y, 90.0f, rect.size.height)];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"btn_header_delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:vc action:@selector(buttonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.tag = 2200;
    [self addSubview:deleteButton];
    
    if (self.object.toBuy == YES) tobuyButton.selected = YES;
    else tobuyButton.selected = NO;
}


@end
