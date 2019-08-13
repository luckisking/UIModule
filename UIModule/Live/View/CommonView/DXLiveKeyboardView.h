//
//  DXLiveKeyboardView.h
//  Doxuewang
//
//  Created by doxue_ios on 2018/3/23.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GHEmojiCollectionView.h"

@protocol LiveKeyboardViewDelegate <NSObject>

- (void)didSelectSendButton;

@end

@interface DXLiveKeyboardView : UIView

@property (nonatomic, strong) UITextView *KeyboardTextView;

@property (nonatomic, strong) NSDictionary *key2fileDic;

//@property (nonatomic, strong) GHEmojiCollectionView *emojiCollectionView;

@property (nonatomic, weak) id <LiveKeyboardViewDelegate> delegate;

@property (nonatomic, assign) BOOL isEmoji;

@end
