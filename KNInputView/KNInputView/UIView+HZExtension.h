//
//  UIView+HZExtension.h
//  HuiXianxia
//
//  Created by jsfu on 15/6/24.
//  Copyright (c) 2015年 何霄云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HZExtension)

//设置Y坐标
@property (assign, nonatomic) CGFloat hz_t;
//得到控件坐下点的坐标
@property (assign, nonatomic) CGFloat hz_b;
//X点的坐标
@property (assign, nonatomic) CGFloat hz_l;
//得到控件右上角的坐标
@property (assign, nonatomic) CGFloat hz_r;
//设置控件宽度
@property (assign, nonatomic) CGFloat hz_w;
//设置控件高度
@property (assign, nonatomic) CGFloat hz_h;
//设置控件大小
@property (assign, nonatomic) CGSize hz_size;
//设置控件起点坐标
@property (assign, nonatomic) CGPoint hz_origin;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;
@property CGFloat centerY;
@property CGFloat centerX;

- (UIImage *)imageFromView;
- (UIImage *)getNormalImage;

- (UINavigationController *)navigationController;

- (UIViewController *) viewController;

- (void)roundedWithNum:(int)num;

-(void)removeAllSubViews;

- (void)showDebug;

- (void)showDebugWithColor:(UIColor *)color;

- (UIView*)findFirstResponderBeneathView:(UIView*)view;

- (CGFloat)radioHeightWithBaseWidth:(CGFloat)width height:(CGFloat)height;

- (UITapGestureRecognizer *)addTapGesTureRecognizerWithTarget:(id)target action:(SEL)selector;

- (UILongPressGestureRecognizer *)addLongPressGestureRecognizerWithTarget:(id)target action:(SEL)selector;
- (UIPanGestureRecognizer *)addPanGesTureRecognizerWithTarget:(id)target action:(SEL)selector;
@end
