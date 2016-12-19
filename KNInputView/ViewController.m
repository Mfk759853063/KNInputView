//
//  ViewController.m
//  KNInputView
//
//  Created by kwep_vbn on 2016/12/19.
//  Copyright © 2016年 vbn. All rights reserved.
//

#import "ViewController.h"

#import "KNChatInputView.h"

@interface ViewController ()

@property (strong, nonatomic) UIScrollView *containerScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"输入框";
    self.containerScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.containerScrollView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.view addSubview:self.containerScrollView];
    self.containerScrollView.contentSize = self.view.bounds.size;
    KNChatFunctionItem *item = [KNChatFunctionItem initWithName:@"照片" image:@"btn_zhaopian" target:self sel:@selector(zTaped)];
    
    KNChatInputView *chat = [[KNChatInputView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 54, CGRectGetWidth(self.view.bounds), 54) functions:@[item,item,item,item,item,item] useEmojiKeyboard:YES];
    
    [self.containerScrollView addSubview:chat];
    chat.parentView = self.containerScrollView;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)zTaped {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
