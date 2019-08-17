//
//  DXLiveSubTableViewCell.h
//  DXLiveSeparation
//
//  Created by doxue_imac on 2019/8/7.
//  Copyright © 2019 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>
#import "DXLiveModuleNoteModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DXLiveSubTableViewCell : UIView

@end


#pragma mark 聊天的cell
@interface DXLiveChatCell : UITableViewCell

@property (nonatomic, strong) NSString *chatString; //聊天信息

@property (nonatomic, strong) UIImageView *headImv;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) YYLabel *chatInfoLabel; //由于聊天数据是富文本 (有表情和图片等)，所以我们使用YYLabel
@property (nonatomic, strong) YYTextLayout *yyLayout; //yylabel的自适应布局属性

@end


//#pragma mark 笔记的cell(废弃，有自适应问题问题)
//@interface DXLiveNoteCell : UITableViewCell
//@property (nonatomic, strong) DXLiveModuleNoteModel *noteModel;
//@end
#pragma mark (新版)笔记的cell
@interface DXLiveNewNoteCell : UITableViewCell
@property (nonatomic, strong) DXLiveModuleNoteModel *noteModel;
@property (nonatomic, strong) YYTextLayout *yyLayout; //yylabel的自适应布局属性
@property (nonatomic, strong) NSString *stringLayout; //yylabel的自适应布局属性
@end
NS_ASSUME_NONNULL_END
