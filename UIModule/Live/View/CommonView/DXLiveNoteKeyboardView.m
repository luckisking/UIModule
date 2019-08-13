//
//  DXLiveNoteKeyboardView.m
//  Doxuewang
//
//  Created by doxue_ios on 2018/3/26.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import "DXLiveNoteKeyboardView.h"

@interface DXLiveNoteKeyboardView ()

@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) UIButton *noteBackButton;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation DXLiveNoteKeyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI
{
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    
    self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 12.5, 200, 24)];
    self.noteLabel.font = [UIFont systemFontOfSize:17.0];
    self.noteLabel.text = @"记笔记";
    self.noteLabel.textColor = dominant_BlockColor;
    [self.contentView addSubview:self.noteLabel];
    
    self.noteBackButton = [[UIButton alloc] initWithFrame:CGRectMake(IPHONE_WIDTH - 50, 11, 40, 24)];
    [self.noteBackButton setTitle:@"取消" forState:UIControlStateNormal];
    self.noteBackButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [self.noteBackButton setTitleColor:RGBAColor(136, 136, 136, 1) forState:UIControlStateNormal];
//    [self.noteBackButton setImage:[UIImage imageNamed:@"live_smallVideoBack"] forState:UIControlStateNormal];
//    self.noteBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, 16, 16, 0);
    [self.noteBackButton addTarget:self action:@selector(noteBackAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.noteBackButton];
    
    self.noteTextView = [[UITextView alloc] initWithFrame:CGRectMake(17, CGRectGetMaxY(self.noteLabel.frame) + 16, IPHONE_WIDTH - 34, 80)];
    self.noteTextView.font = [UIFont systemFontOfSize:15.0];
    self.noteTextView.backgroundColor = live_tableViewBgColor;
    self.noteTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    CGFloat topMargin = 6;
    self.noteTextView.contentInset = UIEdgeInsetsMake(topMargin, 0, 0, 0);
    [self.contentView addSubview:self.noteTextView];
    
    self.placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 150, 21)];
    self.placeHolderLabel.font = [UIFont systemFontOfSize:15];
    self.placeHolderLabel.textColor = RGBAColor(136, 136, 136, 1);
    self.placeHolderLabel.text = @"请输入笔记内容";
    [self.noteTextView addSubview:self.placeHolderLabel];
    
    self.pictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pictureButton.frame = CGRectMake(15, CGRectGetMaxY(self.noteTextView.frame) + 10, 25, 25);
    [self.pictureButton setImage:[UIImage imageNamed:@"live_camera_selected"] forState:UIControlStateSelected];
    [self.pictureButton setImage:[UIImage imageNamed:@"live_camera"] forState:UIControlStateNormal];
    self.pictureButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.pictureButton.selected = YES;
    [self.pictureButton addTarget:self action:@selector(pictureAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.pictureButton];
    
    self.pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.pictureButton.frame) + 10, CGRectGetMaxY(self.noteTextView.frame) + 5, 35, 35)];
    [self.contentView addSubview:self.pictureImageView];
//    self.publicButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.publicButton.frame = CGRectMake(CGRectGetMaxX(self.pictureButton.frame) + 20, CGRectGetMaxY(self.noteTextView.frame) + 10, 25, 25);
//    self.publicButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.publicButton.selected = YES;
//    [self.publicButton setImage:[UIImage imageNamed:@"live_public_selected"] forState:UIControlStateSelected];
//    [self.publicButton setImage:[UIImage imageNamed:@"live_public"] forState:UIControlStateNormal];
//    [self.publicButton addTarget:self action:@selector(publicAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:self.publicButton];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveButton.frame = CGRectMake(CGRectGetMaxX(self.noteBackButton.frame) - 100, 11, 40, 24);
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    self.saveButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [self.saveButton setTitleColor:dominant_GreenColor forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.saveButton];
}

- (void)noteBackAction:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(didSelectNoteBackButton)]) {
        [_delegate didSelectNoteBackButton];
    }
}

- (void)pictureAction:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(didSelectScreenshotsButton)]) {
        [_delegate didSelectScreenshotsButton];
    }
}

//- (void)publicAction:(UIButton *)sender
//{
//    if ([_delegate respondsToSelector:@selector(didSelectPublicButton)]) {
//        [_delegate didSelectPublicButton];
//    }
//}


- (void)saveAction:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(didSelectSaveButton)]) {
        [_delegate didSelectSaveButton];
    }
}
@end
