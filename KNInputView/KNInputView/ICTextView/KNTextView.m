//
//  UIPlaceHolderTextView.m
//  CAFC
//
//  Created by vbn on 14-3-18.
//
//

#import "KNTextView.h"
#import "UIView+HZExtension.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface KNTextView()

@property (nonatomic,weak) UILabel *placeholderLabel;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation KNTextView

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - Properties

///////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - Initialization

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
//        [self setTextContainerInset:UIEdgeInsetsMake(0, 10, 10, 6)];
        UILabel *placeholderLabel = [[UILabel alloc]init];//添加一个占位label
        
        placeholderLabel.backgroundColor= [UIColor clearColor];
        
        placeholderLabel.numberOfLines=0; //设置可以输入多行文字时可以自动换行
        
        [self addSubview:placeholderLabel];
        
        self.dataDetectorTypes = UIDataDetectorTypeAll;
        
        self.placeholderLabel= placeholderLabel; //赋值保存
        
        self.myPlaceholderColor= [UIColor lightGrayColor]; //设置占位文字默认颜色
        
        self.font= [UIFont systemFontOfSize:15]; //设置默认的字体
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textChangedNotification:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
    }
    return self;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]){
//        [self setTextContainerInset:UIEdgeInsetsMake(0, 14, 10, 14)];
        UILabel *placeholderLabel = [[UILabel alloc]init];//添加一个占位label
        
        placeholderLabel.backgroundColor= [UIColor clearColor];
        
        placeholderLabel.numberOfLines=0; //设置可以输入多行文字时可以自动换行
        
        [self addSubview:placeholderLabel];
        
        self.dataDetectorTypes = UIDataDetectorTypeAll;
        
        self.placeholderLabel= placeholderLabel; //赋值保存
        
        self.myPlaceholderColor= [UIColor lightGrayColor]; //设置占位文字默认颜色
        
        self.font= [UIFont systemFontOfSize:15]; //设置默认的字体
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textChangedNotification:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.placeholderLabel.hz_t=self.textContainerInset.top; //设置UILabel 的 y值
    
    self.placeholderLabel.hz_l=self.textContainerInset.left+2;//设置 UILabel 的 x 值
    
    self.placeholderLabel.hz_w=self.hz_w-self.placeholderLabel.hz_l*2.0;
    CGSize maxSize =CGSizeMake(self.placeholderLabel.width,MAXFLOAT);
    if ([self.myPlaceholder length]>0) {
        self.placeholderLabel.height= [self.myPlaceholder boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeholderLabel.font} context:nil].size.height;
    }
    
    if (!CGSizeEqualToSize(self.bounds.size, [self intrinsicContentSize])) {
        [self invalidateIntrinsicContentSize];
    }
}

- (CGSize)intrinsicContentSize
{
    CGSize intrinsicContentSize = self.contentSize;
    
    // iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        intrinsicContentSize.width += (self.textContainerInset.left + self.textContainerInset.right ) / 2.0f;
        intrinsicContentSize.height += (self.textContainerInset.top + self.textContainerInset.bottom) / 2.0f;
    }
    
    return intrinsicContentSize;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textChangedNotification:(NSNotification *)notification {
    self.placeholderLabel.hidden = self.hasText;
}
//

- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

- (void)setMyPlaceholder:(NSString*)myPlaceholder{
    
    _myPlaceholder= [myPlaceholder copy];
    
    //设置文字
    
    self.placeholderLabel.text= myPlaceholder;
    
    //重新计算子控件frame
    
    [self setNeedsLayout];
    
}

- (void)setMyPlaceholderColor:(UIColor*)myPlaceholderColor{
    
    _myPlaceholderColor= myPlaceholderColor;
    
    //设置颜色
    
    self.placeholderLabel.textColor= myPlaceholderColor;
    
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    [super setTextContainerInset:textContainerInset];
}

- (void)setFont:(UIFont*)font{
    
    [super setFont:font];
    
    self.placeholderLabel.font= font;
    
    //重新计算子控件frame
    
    [self setNeedsLayout];
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChangedNotification:nil];
}

- (void)setLineSpacing:(CGFloat)spacing {
    if (!self.textColor) {
        self.textColor = [UIColor blackColor];
    }
    //    textview 改变字体的行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = spacing;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:self.font,
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName:self.textColor
                                 };
    self.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
}

@end
