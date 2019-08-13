//
//  DXLiveNoteKeyboardView.h
//  Doxuewang
//
//  Created by doxue_ios on 2018/3/26.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol liveNoteKeyboardViewDelegate <NSObject>

- (void)didSelectNoteBackButton;

- (void)didSelectScreenshotsButton;

//- (void)didSelectPublicButton;

- (void)didSelectSaveButton;

@end


@interface DXLiveNoteKeyboardView : UIView

@property (nonatomic, strong) UITextView *noteTextView;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *pictureButton;
@property (nonatomic, strong) UIButton *publicButton;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) UIImageView *pictureImageView;

@property (nonatomic, weak) id <liveNoteKeyboardViewDelegate> delegate;

@end
