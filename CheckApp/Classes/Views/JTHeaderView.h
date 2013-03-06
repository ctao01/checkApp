//
//  JTHeaderView.h
//  CheckApp
//
//  Created by Joy Tao on 3/5/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTObject.h"

@interface JTHeaderView : UIView < UITextFieldDelegate , UITextViewDelegate>
@property (nonatomic , strong) JTObject * object;
@property (nonatomic , assign) UIViewController * viewController;

@property (nonatomic , retain) UIImageView * thumbImage;
@property (nonatomic , strong) UITextField * titleField;

@property (nonatomic , strong) UIButton * categoryButton;
@property (nonatomic , assign) NSString * category;

@end
