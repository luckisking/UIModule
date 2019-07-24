//
//  DXVipDoWorkView.m
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/14.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXVipDoWorkView.h"

@interface DXVipDoWorkView ()<UITableViewDelegate,UITableViewDataSource>
//tableView
@property (nonatomic, strong) UITableView *dwTabelView;
//tableView数据
@property (nonatomic,strong) NSArray *data;
@end

@implementation DXVipDoWorkView

- (instancetype)initWithFrame:(CGRect)frame target:(nullable id)target {
    
    if (self = [super initWithFrame:frame]) {
        if (target) {
            self.delegate = target;
        }
        [self setupUI];
        
    }
    return self;
}
- (void)setupUI {
    
    self.backgroundColor = [UIColor whiteColor];
    _dwTabelView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    [self addSubview:_dwTabelView];
    _dwTabelView.backgroundColor = [UIColor whiteColor];
    [_dwTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.size.mas_equalTo(self);
    }];
    _dwTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dwTabelView.delegate = self;
    _dwTabelView.dataSource = self;
    [_dwTabelView registerClass:[DXVipDoWorkCell class] forCellReuseIdentifier:@"dwCell"];
    _dwTabelView.estimatedRowHeight = 0;
    _dwTabelView.estimatedSectionHeaderHeight = 0;
    _dwTabelView.estimatedSectionFooterHeight = 0;
    _dwTabelView.tableFooterView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    
    
    
}

#pragma mark tableView的代理方法

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    DXVipDoWorkCell *dwCell = [tableView dequeueReusableCellWithIdentifier:@"dwCell"];
        DXVipServicePaperMode *paperMode = _data[indexPath.row];
        NSString *recordId = paperMode.record_id;
        NSString *papre = [NSString stringWithFormat:@"%ld.%@",indexPath.row+1,paperMode.paper];
        if ([DXCreateUI judgeEmpty:recordId]) {
            //还没开始答题
             [dwCell setCellType:0 title:papre score:[NSString stringWithFormat:@"已答：%@题",@"0"] time:@"答题时间：0小时0分0秒"];
        }else {
            NSUInteger useTime =  [[NSString stringWithFormat:@"%@",paperMode.use_time] integerValue];
            NSString *hour =  useTime/60/60?[NSString stringWithFormat:@"%ld小时",useTime/60/60]:@"0小时";
            NSString *minute =  useTime/60%60?[NSString stringWithFormat:@"%ld分",useTime/60%60]:@"0分";
            NSString *second =  useTime%60?[NSString stringWithFormat:@"%ld秒",useTime%60]:@"0秒";
            NSString *time = [NSString stringWithFormat:@"答题时间：%@%@%@",hour,minute,second];
            if ([[NSString stringWithFormat:@"%@",paperMode.submit_state] isEqualToString:@"1"]) {
                //提交了
                [dwCell setCellType:1 title:papre score:[NSString stringWithFormat:@"已答完：%@分",paperMode.score] time:time];
            }else {
                //做了一部分没有提交
                [dwCell setCellType:2 title:papre score:[NSString stringWithFormat:@"已答：%@题",paperMode.done_question_count]  time:time];
            }
            
        }
    
    return dwCell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _data.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 80;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = @{@"paperID":((DXVipServicePaperMode *)_data[indexPath.row]).paper_id};
    [self.delegate clickWithDescription:@"paperId" param:dic];
}


- (void)refreshData:(NSArray *)array {
    _data = array;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dwTabelView reloadData];
    });
}


@end



#pragma mark cell
@implementation  DXVipDoWorkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
    
}
- (void)setupUI {
    
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = RGBHex(0x6A4D31).CGColor;
    _titleLabel  = [DXCreateUI initLabelWithText:@"" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:15] textAlignment:(NSTextAlignmentCenter)];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(15);
            make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        }];
    _leftLabel  = [DXCreateUI initLabelWithText:@"" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] textAlignment:(NSTextAlignmentCenter)];
        [self.contentView addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15);
            make.left.mas_equalTo(self.contentView.mas_left).offset(21);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        }];
    _rightLabel  = [DXCreateUI initLabelWithText:@"" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] textAlignment:(NSTextAlignmentCenter)];
        [self.contentView addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.leftLabel);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        }];
}

/**
 Description
 @param type 0 一个题没有答 1 答完了 2 答了一部分
 @param title 试卷名字
 @param score 得分
 @param time 用时
 */
- (void)setCellType:(NSInteger)type title:(nullable NSString *)title score:(nullable NSString *)score time:(nullable NSString *)time {
    self.contentView.layer.borderColor = RGBHex(0x6A4D31).CGColor;
        _titleLabel.text = title;
        _leftLabel.text = score;
        _rightLabel.text = time;
    if (type==0) return;
    if (type==1) {
        _rightTopImv = [[UIImageView alloc] initWithImage:VipServiceImage(@"对号-金色")];
            self.contentView.layer.borderColor = RGBHex(0xDDB372).CGColor;
            [self.contentView addSubview:_rightTopImv];
            [_rightTopImv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.mas_top);
                make.right.mas_equalTo(self.contentView.mas_right);
            }];
    } else if (type==2) { 
        _rightBtn = [DXCreateUI initButtonWithTitle:@"继续测试" titleColor:RGBHex(0x392816) backgroundColor:[UIColor clearColor] font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] controlStateNormal:(UIControlStateNormal) controlStateHighlighted:(UIControlStateNormal) cornerRadius:14];
            [self.contentView addSubview:_rightBtn];
            _rightBtn.layer.borderColor = RGBHex(0xDDB272).CGColor;
            _rightBtn.layer.borderWidth = 1;
            [DXCreateUI addBackgroundColorShadowWidth:80  height:28 fromeColor:RGBHex(0xFFF5E4) toColor:RGBHex(0xD9AD6A) cornerRadius:14 superView:_rightBtn];
            [_rightBtn addTarget:self action:@selector(click) forControlEvents:(UIControlEventTouchUpInside)];
            [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.titleLabel);
                make.right.mas_equalTo(self.mas_right).offset(-10);
                make.size.mas_equalTo(CGSizeMake(80, 28));
            }];
    }
}
- (void)setFrame:(CGRect)frame
{
    //修改cell的左右边距为15;
    //修改cell的Y值下移10;
    //修改cell的高度减少10;
    static CGFloat marginLeftRight = 15;
    static CGFloat marginHeight = 10;
    frame.origin.x = marginLeftRight;
    frame.size.width -= 2 * marginLeftRight;
    frame.origin.y += marginHeight;
    frame.size.height -=  marginHeight;
    [super setFrame:frame];
    
}


@end


