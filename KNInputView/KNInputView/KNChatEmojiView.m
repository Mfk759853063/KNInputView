//
//  KNChatEmojiView.m
//  Clip-Pro
//
//  Created by kwep_vbn on 2016/12/17.
//  Copyright © 2016年 cqhxz. All rights reserved.
//

#define kKeyboradSize 35
#define kSendButtonWidth 50
#define kSendButtonHeight 35
#define kPading 5
#define kCol 7
#define kRow 4
#define kPageCount (kRow*kCol)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "KNChatEmojiView.h"
#import "EmojiItem.h"

@interface KNChatEmojiView ()<UIScrollViewDelegate>

@property (strong, nonatomic) NSDictionary *faceMap;

@property (strong, nonatomic) UIScrollView *pageScrollView;

@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation KNChatEmojiView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];

    }
    return self;
}

- (void)setup {
    self.clipsToBounds = YES;
    self.faceMap = [NSDictionary dictionaryWithContentsOfFile:
                [[NSBundle mainBundle] pathForResource:@"expressionImage_custom"
                                                ofType:@"plist"]];
    _pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    [_pageScrollView setBackgroundColor:UIColorFromRGB(0xEEEEEE)];
    
    float pages = (_faceMap.allKeys.count / (float)kPageCount);
    pages = ceilf(pages);
    [_pageScrollView setShowsVerticalScrollIndicator:NO];
    [_pageScrollView setShowsHorizontalScrollIndicator:NO];
    [_pageScrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    _pageScrollView.pagingEnabled=YES;
    [_pageScrollView setBounces:NO];
    _pageScrollView.delegate=self;
    
    [self addSubview:_pageScrollView];
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)/2 - 100, CGRectGetMaxY(self.bounds) - 50, 200, 30)];
    [_pageControl setNumberOfPages:pages];
    [_pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
    [_pageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
    [self addSubview:_pageControl];
    
    [self settingEmojiItems];
    
}

#pragma mark  表情布局

- (void)settingEmojiItems
{
    
    int count = 0;
    float pages = (_faceMap.allKeys.count / (float)kPageCount);
    pages = ceilf(pages);
    
    self.pageScrollView.contentSize=CGSizeMake((pages) *CGRectGetWidth(self.bounds), CGRectGetHeight(_pageScrollView.bounds));
    
    int xWidth = CGRectGetWidth(self.bounds)/(kCol);
    int xPading = xWidth - kSendButtonWidth;
    int yHeight = CGRectGetHeight(_pageScrollView.bounds)/(kRow+1);
    int yPading = yHeight - kSendButtonWidth;
    int x=0,y =0;
    
    for (int page =0 ; page<pages; page++) {
        y = 0;
        x = CGRectGetWidth(_pageScrollView.bounds)*page;
        for (int row = 0; row<kRow; row++)
        {
            if (row==0) {
                y = yPading;
            }
            else{
                y += kSendButtonWidth + yPading;
            }
            
            for (int col = 0;col<kCol;col++)
            {
                if (col==0) {
                    x = CGRectGetWidth(_pageScrollView.bounds)*page + xPading;
                }else{
                    x += kSendButtonWidth+xPading;
                }
                count ++;
                if (count == _faceMap.allKeys.count) {
                    return;
                }
                CGRect buttonFrame = CGRectMake(x,y, kSendButtonWidth,
                                                kSendButtonWidth);
                UIButton *objButton = (UIButton *)[self.pageScrollView viewWithTag:count + 100];
                if (objButton) {
                    [objButton setFrame:buttonFrame];
                }
                else{
                    if (count % kPageCount == 0 && count != 0) {
                        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
                        [_pageScrollView addSubview:button];
                        [button setFrame:buttonFrame];
                        [button setImage:[UIImage imageNamed:@"faceDelete"] forState:UIControlStateNormal];
                        [button addTarget:self action:@selector(didSelectDelete:) forControlEvents:UIControlEventTouchUpInside];
                        [button setTag:count+100];
                    }
                    else{
                        EmojiItem *expressionButton =[EmojiItem buttonWithType:UIButtonTypeCustom];
                        [_pageScrollView addSubview:expressionButton];
                        [expressionButton setFrame:buttonFrame];
                        UIImage *image = [UIImage imageNamed:[_faceMap valueForKey:_faceMap.allKeys[count]]] ;
                        [expressionButton setImage:image forState:UIControlStateNormal];
                        [expressionButton setEmojiName:[_faceMap.allKeys objectAtIndex:count]];
                        [expressionButton addTarget:self action:@selector(didSelectEmojiItem:) forControlEvents:UIControlEventTouchUpInside];
                        [expressionButton setTag:count+100];
                        
                    }
                }
                
                
            }
        }
        
    }
    
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.pageScrollView.frame = self.bounds;
    [self reLayoutPageScrollView];
}

- (void)reLayoutPageScrollView
{
    [_pageControl setFrame:CGRectMake(CGRectGetWidth(self.bounds)/2 - 100, CGRectGetMaxY(self.bounds) - 50, 200, 30)];
    [self settingEmojiItems];
    
}

- (void)didSelectEmojiItem:(EmojiItem *)item
{
    NSLog(@"%@",item.emojiName);
}

- (void)didSelectDelete:(UIButton *)buttom
{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [self.pageControl setCurrentPage:offset.x/bounds.size.width];
}


@end
