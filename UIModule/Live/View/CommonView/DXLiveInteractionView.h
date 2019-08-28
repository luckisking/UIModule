//
//  DXLiveInteractionView.h
//  DXLiveSeparation
//
//  Created by doxue_imac on 2019/8/7.
//  Copyright © 2019 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DXLiveInteractionViewDelegate <NSObject>

@end

@interface DXLiveInteractionView : UIView

@property (nonatomic, weak) id<DXLiveInteractionViewDelegate>delegate;
@property (nonatomic, strong) UIButton *segmentButton;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UITableView *chatTableView;
@property (nonatomic,strong) UITableView *fileTableView;
@property (nonatomic,strong) UITableView *noteTableView;


@property (nonatomic,strong) NSMutableArray *chatArray; //聊天消息数组
@property (nonatomic, strong) NSMutableArray *nameArray; // 聊天昵称数组
@property (nonatomic, strong) NSMutableArray *imageArray; // 聊天头像数组

@property (nonatomic,strong) NSString *teach_material_file_title;//显示的pdf名字
@property (nonatomic,strong) NSString *teach_material_file;     //pdf的url
@property (nonatomic,strong) NSMutableArray *noteListArray;     //笔记数组

@property (nonatomic, strong) UIButton *textButton; //底部聊天的button


- (instancetype)initWithFrame:(CGRect)frame target:(id)target;
- (void)setupDataScrollPositionBottom ; //是的聊天显示最底部的信息

- (void)addloadViewWithSuperView:(UIView *)view text:(nullable NSString  *)text userEnabled:(BOOL)enabled;//加载动图 ,yes 用户可以继续操作
- (void)removeloadView ;  //移除加载动图


@end

NS_ASSUME_NONNULL_END
