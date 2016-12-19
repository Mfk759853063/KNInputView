//
//  KPTextView.h
//  KupingGame
//
//  Created by kwep_vbn on 14-10-20.
//  Copyright (c) 2014年 vbn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KNTextView : UITextView

@property(nonatomic,copy) NSString *myPlaceholder;  //文字

@property(nonatomic,strong) UIColor *myPlaceholderColor; //文字颜色

@property(nonatomic,strong)NSString *otherID;

/**
 设置行间距
 */
- (void)setLineSpacing:(CGFloat)spacing;

@end
