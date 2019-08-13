//
//  DXLiveKeyboardView.m
//  Doxuewang
//
//  Created by doxue_ios on 2018/3/23.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import "DXLiveKeyboardView.h"

@interface DXLiveKeyboardView () <UITextViewDelegate>

@property (nonatomic, strong) UIButton *emojiButton;

@property (nonatomic, strong) NSDictionary *text2keyDic;

@property (strong, nonatomic) UIButton *sendButton;

@end

@implementation DXLiveKeyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = live_bottomViewBgColor;
        
        [self addSubview:self.KeyboardTextView];
        
        [self addSubview:self.emojiButton];
        [self.emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-7);
            make.left.equalTo(self).offset(15);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
//        NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"RtSDK" ofType:@"bundle"]];
//        _key2fileDic = [NSDictionary dictionaryWithContentsOfFile:[resourceBundle pathForResource:@"key2file" ofType:@"plist"]];
//        _text2keyDic = [NSDictionary dictionaryWithContentsOfFile:[resourceBundle pathForResource:@"text2key" ofType:@"plist"]];
        
//        self.emojiCollectionView = [[GHEmojiCollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 216) emijiPlistFileName:@"text2file" inBundle:resourceBundle];
//
//        @weakify(self);
//        //获取图片并显示
//        [self.emojiCollectionView setEmojiCollectionViewBlock:^(UIImage *emojiImage, NSString *emojiText)
//         {
//             @strongify(self);
//             [self.KeyboardTextView insertText:emojiText];
//
//         }];
//
        [self addSubview:self.sendButton];
        [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10.5);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(22.5);
        }];
    }
    return self;
}

- (UITextView *)KeyboardTextView
{
    if (!_KeyboardTextView) {
        _KeyboardTextView = [[UITextView alloc] init];
        _KeyboardTextView.frame = CGRectMake(60, 7 , IPHONE_WIDTH - 74, 30);
        _KeyboardTextView.layer.borderWidth = 0.5;
        _KeyboardTextView.returnKeyType = UIReturnKeySend;
        _KeyboardTextView.layer.borderColor = live_bottomViewBorderColor.CGColor;
        _KeyboardTextView.font = [UIFont systemFontOfSize:14.0];
        _KeyboardTextView.backgroundColor = live_tableViewBgColor;
        _KeyboardTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        CGFloat topMargin = 7.5;
        _KeyboardTextView.contentInset = UIEdgeInsetsMake(topMargin, 0, 0, 0);
    }
    return _KeyboardTextView;
}

- (UIButton *)emojiButton
{
    if (!_emojiButton) {
        _emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emojiButton setImage:[UIImage imageNamed:@"live_emoji"] forState:UIControlStateNormal];
        [_emojiButton addTarget:self action:@selector(emojiButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiButton;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:dominant_BlockColor forState:UIControlStateNormal];
        _sendButton.hidden = YES;
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (void)sendAction:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(didSelectSendButton)]) {
        [_delegate didSelectSendButton];
    }
}

- (void)emojiButton:(id)sender
{
//    if ([self.KeyboardTextView.inputView isEqual:self.emojiCollectionView]) {
//        self.KeyboardTextView.inputView = nil;
//        [self.emojiButton setImage:[UIImage imageNamed:@"live_emoji"] forState:UIControlStateNormal];
//        _sendButton.hidden = YES;
//        self.isEmoji = NO;
//        _KeyboardTextView.frame = CGRectMake(60, 8 , IPHONE_WIDTH - 74, 30);
//        [self.KeyboardTextView reloadInputViews];
//  
//    }
//    else
//    {
//        self.KeyboardTextView.inputView = self.emojiCollectionView;
//        [self.emojiButton setImage:[UIImage imageNamed:@"live_keyboard"] forState:UIControlStateNormal];
//        _sendButton.hidden = NO;
//        self.isEmoji = YES;
//        _KeyboardTextView.frame = CGRectMake(60, 8 , IPHONE_WIDTH - 120, 30);
//        [self.KeyboardTextView reloadInputViews];
//       
//    }
//    
//    if ([self.KeyboardTextView isFirstResponder]) {
//        
//        [self.KeyboardTextView resignFirstResponder];
//        
//        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
//        
//    }
//    else
//    {
//        [self.KeyboardTextView becomeFirstResponder];
//    }
}

- (void)delayMethod
{
    [self.KeyboardTextView becomeFirstResponder];
    
}
@end
