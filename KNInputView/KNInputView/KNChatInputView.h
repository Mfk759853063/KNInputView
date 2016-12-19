//
//  KNChatInputView.h
//  HXZoffice
//
//  Created by vbn on 16/10/31.
//  Copyright © 2016年 cqhxz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KNChatFunctionItem;

@interface KNChatInputView : UIView

@property (weak, nonatomic) UIView *parentView;

- (instancetype)initWithFrame:(CGRect)rect functions:(NSArray<KNChatFunctionItem *> *)functions useEmojiKeyboard:(BOOL)emojiKeyboard;

@end

@interface KNChatFunctionItem : NSObject

@property (copy, nonatomic) NSString *itemName;

@property (strong, nonatomic) NSString *itemImageName;

@property (strong, nonatomic) id target;

@property (nonatomic) SEL selector;

+ (instancetype)initWithName:(NSString *)name image:(NSString *)image target:(id)target sel:(SEL)selector;

@end
