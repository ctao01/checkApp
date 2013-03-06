//
//  JTModalView.m
//  CheckApp
//
//  Created by Joy Tao on 2/24/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTModalView.h"
#import "JTMainTabBarController.h"

#define RADIUS 4.0f
#define CONSTANT 50.0f

@interface JTModalView ()
{
    JTMainTabBarController * tbc;
    UIButton * catBtn;
}

@end

@implementation JTModalView

@synthesize viewController;
@synthesize tf;
@synthesize imgView;
@synthesize category =_category;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        tbc = (JTMainTabBarController*)self.viewController;
    }
    return self;
}

#pragma mark - Getter/Setter

- (void) setCategory:(NSString *)newCategory
{
    if (_category == newCategory) return;
    NSLog(@"newCategory:%@",newCategory);
    _category = newCategory;
    [catBtn setTitle:_category forState:UIControlStateNormal];
    [catBtn layoutIfNeeded];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Draw Function

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGRect frame = CGRectMake(0.0f, 0.0f, CONSTANT * 5, 160.0f);
    frame.origin = CGPointMake((rect.size.width - frame.size.width) / 2 ,
                               (rect.size.height - frame.size.height) / 2);
    
    [self drawTheCenterRect:frame];
    
    CGRect innerFrame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(20.0f, 10.0f, 20.0f, 10.0f));
    CGRect topFrame = UIEdgeInsetsInsetRect(innerFrame, UIEdgeInsetsMake(0.0f, 0.0f, innerFrame.size.height * 1 / 3, 0.0f));
    CGRect lowerFrame = UIEdgeInsetsInsetRect(innerFrame, UIEdgeInsetsMake(innerFrame.size.height * 2 / 3, 0.0f, 0.0f, 0.0f));

    [self drawThumbViewWithRect:CGRectMake(topFrame.origin.x, topFrame.origin.y, 80.0f, 80.0f)];
    [self attachConfirmButtonsWithRect:lowerFrame];
    
    UIImage * image = [UIImage imageNamed:@"btn_close_red_center"];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0.0f, 0.0f, image.size.width, image.size.height)];
    [button setCenter:CGPointMake(frame.origin.x, frame.origin.y)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:tbc action:@selector(cancelCreating) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];

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
    
    self.imgView = [[UIImageView alloc]initWithFrame:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f))];
    self.imgView.contentMode = UIViewContentModeScaleToFill;
    self.imgView.image = [UIImage imageNamed:@"btn_camera_black"];
    self.imgView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.imgView.layer.borderWidth = 2.0f;
    [self addSubview:self.imgView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:self.imgView.frame];
    [button addTarget:tbc action:@selector(activateCamera) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];

    /*UIImage * image = [UIImage imageNamed:@"btn_camera"];
    UIButton * cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraBtn setFrame:CGRectMake(0.0f, 0.0f, image.size.width, image.size.height)];
    [cameraBtn setCenter:CGPointMake(self.imgView.frame.origin.x + self.imgView.frame.size.width,
                                     self.imgView.frame.origin.y + self.imgView.frame.size.height)];
    [cameraBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    [self addSubview:cameraBtn];*/
    
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

    tf = [[UITextField alloc]initWithFrame:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(10.0f, 2.0f, 5.0f, 2.0f))];
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tf.textAlignment = NSTextAlignmentCenter;
    [tf setPlaceholder:@"Title"];
    [tf setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:14]];
    tf.delegate = self;
    [self addSubview:tf];
    
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
    
    catBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [catBtn setFrame:rect];
    [catBtn addTarget:tbc action:@selector(showCategoryList) forControlEvents:UIControlEventTouchUpInside];
    [catBtn setTitle:@"(Select A Category)" forState:UIControlStateNormal];
    [catBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [catBtn.titleLabel setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:14]];
    [catBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    
    [self addSubview:catBtn];
}

- (void) attachConfirmButtonsWithRect:(CGRect)rect
{
    CGRect buttonRect = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(10.0f, 25.0f, 0.0f, 25.0f));
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:buttonRect];
    [btn1 setFrame:CGRectOffset(btn1.frame, 0.0f, 5.0f)];
    
    UIImage * originalImage = [UIImage imageNamed:@"btn_modal"];
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                           (buttonRect.size.width - originalImage.size.width)/2,
                                           0.0f,
                                           (buttonRect.size.width - originalImage.size.width)/2);
    originalImage = [originalImage resizableImageWithCapInsets:insets];
    [btn1 setBackgroundImage:originalImage forState:UIControlStateNormal];
    [btn1 setTitle:@"Add New Item" forState:UIControlStateNormal];
//    btn1.backgroundColor = [UIColor colorWithRed:64.0f/255.0f green:204.0f/255.0f blue:127.0f/255.0f alpha:1.0f];
    [btn1 addTarget:tbc action:@selector(completeCreating) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn1];
    
    
//    UIView * v1 = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 30.0f)];
//    v1.frame = CGRectOffset(v1.frame, rect.origin.x + rect.size.width/4 - v1.frame.size.width/2, rect.origin.y);
//    v1.backgroundColor = [UIColor colorWithRed:64.0f/255.0f green:204.0f/255.0f blue:127.0f/255.0f alpha:1.0f];
//    NSLog(@"%@",NSStringFromCGRect(v1.frame));
    
//    CGRect buttonFrame = CGRectMake(0.0f, 0.0f, 80.0f, 30.0f);
//    
//    UIImage *originalImage = [UIImage imageNamed:@"modalButton_green"];
//    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 40.0f, 0.0f, 40.0f);
//    UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:insets];
//    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn1 setFrame:buttonFrame];
//     [btn1 setFrame:CGRectOffset(btn1.frame, rect.origin.x + rect.size.width/4 - btn1.frame.size.width/2, rect.origin.y)];
//    [btn1 setBackgroundImage:stretchableImage forState:UIControlStateNormal];
//    [btn1 setTitle:@"Add" forState:UIControlStateNormal];
//    
//    
//    UIView * v2 = [[UIView alloc]initWithFrame:btn1.frame];
//    v2.center = CGPointMake(btn1.center.x + rect.size.width/2, v2.center.y);
//    v2.backgroundColor = [UIColor redColor];
//
//    
//    [self addSubview:btn1];
//    [self addSubview:v2];
}

@end
