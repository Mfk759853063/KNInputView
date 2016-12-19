//
//  KNChatInputView.m
//  HXZoffice
//
//  Created by vbn on 16/10/31.
//  Copyright © 2016年 cqhxz. All rights reserved.
//

#import "KNChatInputView.h"
#import "KNChatEmojiView.h"
#import "KNTextView.h"
#define kDefaultToolbarHeight 56
#define kDefaultPanleHeight 258
#define kDefaultTextViewHeight 33

#define SCREEN_WIDTH                              [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT                             [[UIScreen mainScreen]bounds].size.height
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define SINGLE_LINE_WIDTH           (1.0f / [UIScreen mainScreen].scale)

typedef enum : NSUInteger {
    ICChatInputShowTypeUnknown,
    ICChatInputShowTypeFunction = 1,
    ICChatInputShowTypeKeyboard,
    ICChatInputShowTypeEmoji,
} ICChatInputShowType;

@interface KNChatInputView ()

@property (assign, nonatomic) BOOL useEmojiKeyboard;

@property (strong, nonatomic) NSArray *functions;

@property (strong, nonatomic) UIView *toolBarView;

@property (strong, nonatomic) UIButton *changeButton;

@property (strong, nonatomic) UIButton *sendButton;

@property (strong, nonatomic) KNTextView *inputTextView;

@property (strong, nonatomic) UIView *functionPanelView;

@property (strong, nonatomic) KNChatEmojiView *emojiPanelView;

@property (assign, nonatomic) CGRect orgRect;

@property (assign, nonatomic) CGRect keyboardRect;

@property (assign, nonatomic) CGFloat minTextViewHeight;

@property (assign, nonatomic) ICChatInputShowType currentShowType;

@end

@implementation KNChatInputView

- (instancetype)initWithFrame:(CGRect)rect functions:(NSArray<KNChatFunctionItem *> *)functions useEmojiKeyboard:(BOOL)emojiKeyboard {
    self = [super initWithFrame:rect];
    if (self) {
        self.orgRect = rect;
        self.functions = functions;
        self.useEmojiKeyboard = emojiKeyboard;
        [self setup];
    }
    return self;
}

- (void)setup {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangeed:) name:UITextViewTextDidChangeNotification object:nil];
    
    self.minTextViewHeight = kDefaultTextViewHeight;
    self.currentShowType =  ICChatInputShowTypeKeyboard;
    [self addSubview:self.toolBarView];
    [self addSubview:self.functionPanelView];
    if (self.useEmojiKeyboard) {
        [self addSubview:self.emojiPanelView];
    }
    [self layoutSubviews];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.toolBarView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kDefaultToolbarHeight);
    CGFloat inputTextViewWidth = CGRectGetWidth(self.toolBarView.bounds) - (CGRectGetWidth(self.changeButton.frame) + 15 + CGRectGetWidth(self.sendButton.bounds) + 15 + 14 + 15);
    self.inputTextView.frame = CGRectMake(CGRectGetMaxX(self.changeButton.frame) + 15, 8, inputTextViewWidth, kDefaultTextViewHeight);
    CGSize size = [self.inputTextView sizeThatFits:CGSizeMake(inputTextViewWidth, CGFLOAT_MAX)];
    size.height += 5;
    if (size.height < self.minTextViewHeight) {
        size.height = self.minTextViewHeight;
    }
    self.inputTextView.frame = CGRectMake(CGRectGetMaxX(self.changeButton.frame) + 15, 10, inputTextViewWidth, size.height);
    self.toolBarView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(self.inputTextView.frame) + 13);
    [self layoutToolbarLayout];
    self.functionPanelView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBarView.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.functionPanelView.bounds));
    if (self.useEmojiKeyboard) {
        self.emojiPanelView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBarView.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.emojiPanelView.bounds));
    }
}

- (void)layoutSelfFrame {
    CGFloat height = CGRectGetHeight(self.keyboardRect) == 0?kDefaultPanleHeight:CGRectGetHeight(self.keyboardRect);
    height += CGRectGetHeight(self.toolBarView.bounds);
    self.frame = CGRectMake(CGRectGetMinX(self.frame), SCREEN_HEIGHT - height, CGRectGetWidth(self.bounds), height);
}
- (void)layoutToolbarLayout {
    self.changeButton.frame = CGRectMake(14, 12, 26, 26);
    self.sendButton.frame = CGRectMake(CGRectGetMaxX(self.bounds) - (14+44), 6, 44, 38);
}

- (void)layoutFunctionItems {
    [self.functionPanelView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    NSInteger rowCount = SCREEN_WIDTH >= 414 ? 5:4;
    CGFloat leftPadding = SCREEN_WIDTH >= 414 ? 30:20;
    
    CGFloat itemPadding = ((SCREEN_WIDTH - leftPadding*2)/(rowCount)) - 51;
    itemPadding+=itemPadding/rowCount;
    for (int i = 0; i<self.functions.count; i++) {
        int row = i / rowCount;
        int col = i % rowCount;
        UIButton *button = [self createFunctionButtonWithItem:self.functions[i]];
        [self.functionPanelView addSubview:button];
        button.frame = CGRectMake(leftPadding + 51*col+itemPadding * col, 71*row, 51, 71);
    }
}

- (UIButton *)createFunctionButtonWithItem:(KNChatFunctionItem *)item {
    UIButton *button = [[UIButton alloc] init];
    [button addTarget:item.target action:item.selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:item.itemName forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:item.itemImageName] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return button;
}

#pragma mark keyboardNotification

- (void)keyboardWillShow:(NSNotification*)notification {
    self.currentShowType = ICChatInputShowTypeKeyboard;
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardRect = keyboardRect;
    [self.changeButton setImage:[UIImage imageNamed:@"btn_zengjia"] forState:UIControlStateNormal];
    [self layoutSubviews];
    [self layoutSelfFrame];
    NSLog(@"%@",NSStringFromCGRect(self.frame));
}

- (void)keyboardWillHide:(NSNotification*)notification {

    [self layoutSubviews];
    self.frame = self.orgRect;
    
}

#pragma mark - target

- (void)changeStyle:(UIButton *)button {
    if (self.useEmojiKeyboard) {
        if (self.currentShowType == ICChatInputShowTypeKeyboard) {
            [self showPannel];
            self.currentShowType = ICChatInputShowTypeFunction;
            [self.changeButton setImage:[UIImage imageNamed:@"board_emoji"] forState:UIControlStateNormal];
        } else if (self.currentShowType == ICChatInputShowTypeFunction) {
            [self showEmojiPannel];
            self.currentShowType = ICChatInputShowTypeEmoji;
            [self.changeButton setImage:[UIImage imageNamed:@"btn_jianpan"] forState:UIControlStateNormal];
        } else if (self.currentShowType == ICChatInputShowTypeEmoji) {
            [self showKeyboard];
            self.currentShowType = ICChatInputShowTypeKeyboard;
            [self.changeButton setImage:[UIImage imageNamed:@"btn_zengjia"] forState:UIControlStateNormal];
        }
    } else {
        if (self.currentShowType == ICChatInputShowTypeKeyboard) {
            [self showPannel];
            self.currentShowType = ICChatInputShowTypeFunction;
            [self.changeButton setImage:[UIImage imageNamed:@"btn_jianpan"] forState:UIControlStateNormal];
        } else if (self.currentShowType == ICChatInputShowTypeFunction) {
            [self showKeyboard];
            self.currentShowType = ICChatInputShowTypeKeyboard;
            [self.changeButton setImage:[UIImage imageNamed:@"btn_zengjia"] forState:UIControlStateNormal];
        }
    }
    
}

- (void)showPannel {
    if (self.useEmojiKeyboard) {
        self.emojiPanelView.hidden = YES;
    }
    self.functionPanelView.hidden = NO;
    [self.inputTextView resignFirstResponder];
    CGFloat pannelHeight = 0;
    if (CGRectGetHeight(self.keyboardRect) != 0) {
        pannelHeight = CGRectGetHeight(self.keyboardRect);
    } else {
        pannelHeight = kDefaultPanleHeight;
    }
    
    self.functionPanelView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBarView.bounds), CGRectGetWidth(self.bounds), pannelHeight);
    [self layoutSubviews];
    self.frame = self.orgRect;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutSelfFrame];
    } completion:nil];
    
    [self layoutFunctionItems];
    

}

- (void)showEmojiPannel {
    self.functionPanelView.hidden = YES;
    self.emojiPanelView.hidden =NO;
    [self.inputTextView resignFirstResponder];
    CGFloat pannelHeight = 0;
    if (CGRectGetHeight(self.keyboardRect) != 0) {
        pannelHeight = CGRectGetHeight(self.keyboardRect);
    } else {
        pannelHeight = kDefaultPanleHeight;
    }
    
    self.emojiPanelView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBarView.bounds), CGRectGetWidth(self.bounds), pannelHeight);
    [self layoutSubviews];
    self.frame = self.orgRect;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutSelfFrame];
    } completion:nil];
    [self.emojiPanelView layoutSubviews];
    [self.changeButton setImage:[UIImage imageNamed:@"btn_jianpan"] forState:UIControlStateNormal];
}

- (void)showKeyboard{
    [self.inputTextView becomeFirstResponder];
    
    self.functionPanelView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBarView.frame), CGRectGetWidth(self.bounds), 0);
    [self layoutFunctionItems];
    if (self.useEmojiKeyboard) {
        self.emojiPanelView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBarView.frame), CGRectGetWidth(self.bounds), 0);
    }
    
}

- (void)sendAction:(UIButton *)button {
    self.inputTextView.text = @"";
    [self layoutSubviews];
    [self dismiss];
}

- (void)textChangeed:(UITextView *)sender {
    [self layoutSubviews];
    [self layoutSelfFrame];
}

- (void)dismiss{
    [self.inputTextView resignFirstResponder];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.functionPanelView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBarView.frame), CGRectGetWidth(self.bounds), 0);
        if (self.useEmojiKeyboard) {
            self.emojiPanelView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBarView.frame), CGRectGetWidth(self.bounds), 0);
        }
        self.frame = self.orgRect;
    } completion:^(BOOL finished) {
        
    }];
    
}


#pragma mark - getter && setter

- (UIView *)toolBarView
{
    if (!_toolBarView) {
        _toolBarView = [[UIView alloc] init];
        _toolBarView.backgroundColor = [UIColor whiteColor];
        [_toolBarView addSubview:self.changeButton];
        [self.changeButton setImage:[UIImage imageNamed:@"btn_zengjia"] forState:UIControlStateNormal];
        [_toolBarView addSubview:self.inputTextView];
        [_toolBarView addSubview:self.sendButton];
    }
    return _toolBarView;
}

- (UIButton *)changeButton
{
    if (!_changeButton) {
        _changeButton = [[UIButton alloc] init];
        _changeButton.backgroundColor = [UIColor whiteColor];
        [_changeButton addTarget:self action:@selector(changeStyle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeButton;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [[UIButton alloc] init];
        _sendButton.backgroundColor = RGBCOLOR(76, 215, 100);
        _sendButton.layer.cornerRadius=5;
        _sendButton.titleLabel.textColor = [UIColor whiteColor];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (KNTextView *)inputTextView
{
    if (!_inputTextView) {
        _inputTextView = [[KNTextView alloc] init];
        _inputTextView.textContainerInset = UIEdgeInsetsMake(5, 0, 5, 0);
        _inputTextView.backgroundColor = [UIColor whiteColor];
        _inputTextView.layer.borderColor = [UIColor grayColor].CGColor;
        _inputTextView.layer.borderWidth = SINGLE_LINE_WIDTH;
        _inputTextView.layer.cornerRadius = 3;
        _inputTextView.scrollEnabled = NO;
        _inputTextView.myPlaceholder = @"点击回复";
    }
    return _inputTextView;
}

- (UIView *)functionPanelView
{
    if (!_functionPanelView) {
        _functionPanelView = [[UIView alloc] init];
        _functionPanelView.backgroundColor = [UIColor whiteColor];
    }
    return _functionPanelView;
}

- (KNChatEmojiView *)emojiPanelView
{
    if (!_emojiPanelView) {
        _emojiPanelView = [[KNChatEmojiView alloc] init];
    }
    return _emojiPanelView;
}

@end


#pragma mark - ICChatFunctionItem Class

@implementation KNChatFunctionItem

+ (instancetype)initWithName:(NSString *)name image:(NSString *)image target:(id)target sel:(SEL)selector {
    KNChatFunctionItem *item = [[KNChatFunctionItem alloc] init];
    item.itemName = name;
    item.itemImageName = image;
    item.target = target;
    item.selector = selector;
    return item;
}

@end
