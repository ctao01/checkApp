//
//  JTMainTabBarController.h
//  CheckApp
//
//  Created by Joy Tao on 2/22/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTObject.h"
#import "JTModalView.h"

@interface JTMainTabBarController : UITabBarController < UINavigationControllerDelegate, UIImagePickerControllerDelegate , UITabBarControllerDelegate , UIAlertViewDelegate >
@property (nonatomic , retain) JTObject * object;
@property (nonatomic , retain) JTModalView * modalView;

@end
