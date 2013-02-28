//
//  JTModalView.h
//  CheckApp
//
//  Created by Joy Tao on 2/24/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTModalView : UIView < UITextFieldDelegate >

@property (nonatomic , retain) UIViewController * viewController;
@property (nonatomic , retain) UITextField * tf;
@property (nonatomic , retain) UIImageView * imgView;
@property (nonatomic , assign) NSString * category;
@end
