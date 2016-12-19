//
//  UIView+HZExtension.m
//  HuiXianxia
//
//  Created by jsfu on 15/6/24.
//  Copyright (c) 2015年 何霄云. All rights reserved.
//

#import "UIView+HZExtension.h"

@implementation UIView (HZExtension)


- (void)setHz_l:(CGFloat)hz_l
{
    CGRect frame = self.frame;
    frame.origin.x = hz_l;
    self.frame = frame;
}

-(CGFloat)hz_r
{
    return self.frame.origin.x + self.frame.size.width;
}

-(CGFloat)hz_b
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)hz_l
{
    return self.frame.origin.x;
}

- (void)setHz_t:(CGFloat)hz_t
{
    CGRect frame = self.frame;
    frame.origin.y = hz_t;
    self.frame = frame;
}

- (CGFloat)hz_t
{
    return self.frame.origin.y;
}

- (void)setHz_w:(CGFloat)hz_w
{
    CGRect frame = self.frame;
    frame.size.width = hz_w;
    self.frame = frame;
}

- (CGFloat)hz_w
{
    return self.frame.size.width;
}

- (void)setHz_h:(CGFloat)hz_h
{
    CGRect frame = self.frame;
    frame.size.height = hz_h;
    self.frame = frame;
}

- (CGFloat)hz_h
{
    return self.frame.size.height;
}

- (void)setHz_size:(CGSize)hz_size
{
    CGRect frame = self.frame;
    frame.size = hz_size;
    self.frame = frame;
}

- (CGSize)hz_size
{
    return self.frame.size;
}

- (void)setHz_origin:(CGPoint)hz_origin
{
    CGRect frame = self.frame;
    frame.origin = hz_origin;
    self.frame = frame;
}

- (CGPoint)hz_origin
{
    return self.frame.origin;
}

// Retrieve and set height, width, top, bottom, left, right
- (CGFloat) height
{
    return self.frame.size.height;
}

- (void) setHeight: (CGFloat) newheight
{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat) width
{
    return self.frame.size.width;
}

- (void) setWidth: (CGFloat) newwidth
{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat) top
{
    return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat) left
{
    return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat) bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottom: (CGFloat) newbottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat) right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setRight: (CGFloat) newright
{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

-(CGFloat)centerY {
    return self.center.y;
}

- (CGFloat)centerX {
    return self.center.x;
}

//获取view的controller
- (UINavigationController *)navigationController
{
    for (UIView * next = [self superview]; next; next = next.superview)
    {
        UIResponder * nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]])
        {
            return (UINavigationController *)nextResponder;
        }
    }
    return nil;
}

-(UIViewController *)viewController
{
    for (UIView * next = [self superview]; next; next = next.superview)
    {
        UIResponder * nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

-(void)roundedWithNum:(int)num
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = num;
}

-(void)removeAllSubViews
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}

- (void)showDebug {
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [[UIColor redColor] CGColor];
}

- (void)showDebugWithColor:(UIColor *)color {
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [color CGColor];
}

- (CGFloat)radioHeightWithBaseWidth:(CGFloat)width height:(CGFloat)height
{
    CGFloat radio = (CGRectGetWidth(self.bounds) - width) / CGRectGetWidth(self.bounds);
    CGFloat radioHeight = radio * height + height;
    return radioHeight;
}

- (UITapGestureRecognizer *)addTapGesTureRecognizerWithTarget:(id)target action:(SEL)selector
{
    [self setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:tap];
    return tap;
}

- (UILongPressGestureRecognizer *)addLongPressGestureRecognizerWithTarget:(id)target action:(SEL)selector
{
    [self setUserInteractionEnabled:YES];
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:tap];
    return tap;
}

- (UIPanGestureRecognizer *)addPanGesTureRecognizerWithTarget:(id)target action:(SEL)selector {
    [self setUserInteractionEnabled:YES];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:pan];
    return pan;
}

//获得屏幕图像
- (UIImage *)imageFromView
{
    
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
- (UIImage *)getNormalImage{
    
//    UIGraphicsBeginImageContext(self.frame.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [self.layer renderInContext:context];
//    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return theImage;
    
    
    //支持retina高分的关键
    if(UIGraphicsBeginImageContextWithOptions != NULL)
        
    {
        //UIImage
        UIGraphicsBeginImageContextWithOptions(self.frame.size, true, 0.0);
        
    } else {
        
        UIGraphicsBeginImageContext(self.frame.size);
        
    }
    
    
    
    //获取图像
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //
    //    NSData *data = UIImagePNGRepresentation(image);
    //    UIImage * tempImage = [UIImage imageWithData:data];
    return image;
}


@end
