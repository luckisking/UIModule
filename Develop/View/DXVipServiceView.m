//
//  DXVipServiceView.m
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/17.
//  Copyright © 2019 都学网. All rights reserved.
//



#import "DXVipServiceView.h"


@interface DXVipServiceView ()<UITableViewDelegate,UITableViewDataSource>

//头部视图的高度
@property (nonatomic, assign) CGFloat headViewHeight;
//笔试还是面试（非0 笔试 0 面试）
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) UITableView *vsTabelView; //老师分配了测试作业的tableView
@property (nonatomic, strong) NSArray *dataArr;         //tableView的数据

@end

@implementation DXVipServiceView


/**
 初始化方法
 @param frame 大小
 @param type 笔试还是面试（非0 笔试 0 面试）
 @param target 目标controller
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type target:(id)target {
    
    if (self = [super initWithFrame:frame]) {
        _type = type;
        self.delegate = target;
        [self setupUI];
        
    }
    return self;
}
- (void)setupUI {
    
    self.backgroundColor = [UIColor whiteColor];
    _headViewHeight = iPhoneX?204:180;
    //添加头视图
    [self addHeadView];
    
    /* 未分配班主任 等待分配*/
//    [self addWaiForTeacherView];
    
    /* 已经分配班主任 等待安排计划*/
//    [self addTeacherViewWithHeadImv:nil detail:@"许焕琛  13800000000"];

    /* 已经分配班主任 并且安排了计划*/
//    [self addTestView];
    
   
}

- (void)addHeadView {
    
    UIView *headView = [[UIView alloc] init];
        [self addSubview:headView];
        headView.layer.contents = (id) (VipServiceImage(@"bg")).CGImage;
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.size.mas_equalTo(CGSizeMake(IPHONE_WIDTH, self.self.headViewHeight));
        }];
    UIImageView *headBackImv = [[UIImageView alloc] initWithImage:VipServiceImage(@"返回")];
        [headView addSubview:headBackImv];
        [headBackImv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headView.mas_top).offset(iPhoneX?44:24);
            make.left.mas_equalTo(headView.mas_left).offset(16);
        }];
        headBackImv.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backClick:)];
        [headBackImv addGestureRecognizer:tap];
    UIImageView *headImv = [[UIImageView alloc] initWithImage:VipServiceImage(_type?@"笔试服务头部":@"面试服务头部")];
        [headView addSubview:headImv];
        [headImv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(headView.mas_right).offset(-15);
            make.left.mas_equalTo(headView.mas_left).offset(15);
            make.bottom.mas_equalTo(headView.mas_bottom).offset(10);
        }];
    UILabel *label  = [DXCreateUI initLabelWithText:_type?@"都学课堂VIP笔试服务":@"都学课堂VIP面试服务" textColor:RGBHex(0x392816) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:20] textAlignment:(NSTextAlignmentCenter)];
        [headImv addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(headImv);
            make.bottom.mas_equalTo(headImv.mas_bottom).offset(-30);
        }];
    UIImageView *rightImv = [[UIImageView alloc] initWithImage:VipServiceImage(_type?@"进入面试":@"进入笔试")];
        [headImv addSubview:rightImv];
        rightImv.hidden = YES;
        [rightImv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(headImv.mas_right);
            make.top.mas_equalTo(headImv.mas_top).offset(40);
        }];
}

- (UIView *)addWaiForTeacherView {
    
    UIView *view = [[UIView alloc] init];
    [self insertSubview:view atIndex:0];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headViewHeight);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
        make.left.mas_equalTo(self.mas_left);
    }];
    UIImageView *imv = [[UIImageView alloc] initWithImage:VipServiceImage(@"等待分配")];
    [view addSubview:imv];
    [imv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top).offset(40);
        make.centerX.mas_equalTo(view);
    }];
    
    UILabel *label  = [DXCreateUI initLabelWithText:_type?@"您已开通VIP笔试服务":@"您已开通VIP面试服务" textColor:RGBHex(0x392816) font:[UIFont fontWithName:@"PingFangSC-Medium" size:15] textAlignment:(NSTextAlignmentCenter)];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imv.mas_bottom).offset(6);
        make.centerX.mas_equalTo(view);
    }];
    
    UILabel *label1  = [DXCreateUI initLabelWithText:@"正在为您分配专属班主任，请耐心等待~" textColor:RGBHex(0x392816) font:[UIFont fontWithName:@"PingFangSC-Medium" size:15] textAlignment:(NSTextAlignmentCenter)];
    [view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(10);
        make.centerX.mas_equalTo(view);
    }];
    
    return view;
    
}


- (UIView *)addTeacherViewWithHeadImv:(nullable NSString *)imvString detail:(nullable NSString *)detail {
    
    UIView *teacherView = [[UIView alloc] init];
        [self insertSubview:teacherView atIndex:0];
        [teacherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.self.headViewHeight);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.right.mas_equalTo(self.mas_right);
            make.left.mas_equalTo(self.mas_left);
        }];
    UILabel *topLabel  = [DXCreateUI initLabelWithText:@"亲爱的同学，\n已为您分配专属班主任" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:15] textAlignment:(NSTextAlignmentCenter)];
        [teacherView addSubview:topLabel];
        topLabel.numberOfLines = 0;
        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(teacherView.mas_top).offset(40);
            make.centerX.mas_equalTo(teacherView);
        }];
    UIImageView *headImv = [[UIImageView alloc] initWithImage:VipServiceImage(imvString?:@"默认老师")];
    
        [headImv setImageWithURL: [NSURL URLWithString:imvString]];
        [teacherView addSubview:headImv];
        headImv.layer.cornerRadius = 35;
        headImv.layer.masksToBounds = YES;
        [headImv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topLabel.mas_bottom).offset(12);
            make.centerX.mas_equalTo(teacherView);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
    UILabel *nameLabel  = [DXCreateUI initLabelWithText:detail?:@"班主任正在赶来..." textColor:RGBHex(0xFCE0B0) font:[UIFont fontWithName:@"PingFangSC-Medium" size:16] textAlignment:(NSTextAlignmentCenter)];
        [teacherView addSubview:nameLabel];
        [DXCreateUI addBackgroundColorShadowWidth:200 height:26 fromeColor:RGBHex(0x8E6A3E) toColor:RGBHex(0x694C30) cornerRadius:13 superView:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headImv.mas_bottom).offset(12);
            make.centerX.mas_equalTo(teacherView);
            make.size.mas_equalTo(CGSizeMake(200, 26));
        }];
    UILabel *bottomLabel  = [DXCreateUI initLabelWithText:_type?@"请耐心等待班主任为您安排VIP笔试服务~":@"请耐心等待班主任为您安排VIP面试服务~" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:15] textAlignment:(NSTextAlignmentCenter)];
        [teacherView addSubview:bottomLabel];
        [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(12);
            make.centerX.mas_equalTo(teacherView);
        }];
    
    return teacherView;
    
}


- (void)addTestViewWithDataArray:(nullable NSArray *)array {
    if (!array) {
        [self addWaiForTeacherView];
        return;
    }
    _dataArr = array;
    _vsTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headViewHeight, self.bounds.size.width, IPHONE_HEIGHT- self.headViewHeight+(iPhoneX?-34:0)) style:(UITableViewStyleGrouped)];
        [self insertSubview:_vsTabelView atIndex:0];
        _vsTabelView.backgroundColor = [UIColor whiteColor];
        _vsTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _vsTabelView.delegate = self;
        _vsTabelView.dataSource = self;
        [_vsTabelView registerClass:[DXVipServiceCell class] forCellReuseIdentifier:@"vsCell"];
        _vsTabelView.estimatedRowHeight = 0;
        _vsTabelView.estimatedSectionHeaderHeight = 0;
        _vsTabelView.estimatedSectionFooterHeight = 0;
    
}

#pragma mark tableView的代理方法

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
        DXVipServiceCell *vsCell = [tableView dequeueReusableCellWithIdentifier:@"vsCell"];
        NSDictionary *dic =  _dataArr[indexPath.row];
        NSString *recordId = [NSString stringWithFormat:@"%@",dic[@"record_id"]];
        NSString *papre = [NSString stringWithFormat:@"%ld.%@",indexPath.row+1,dic[@"paper"]];
        if ([DXCreateUI judgeEmpty:recordId]) {
            //还没开始答题
            [vsCell setCellType:0 title:papre score:@"" time:@""];
        }else {
            NSUInteger useTime =  [[NSString stringWithFormat:@"%@",dic[@"use_time"]] integerValue];
            NSString *hour =  useTime/60/60?[NSString stringWithFormat:@"%ld小时",useTime/60/60]:@"";
            NSString *minute =  useTime/60%60?[NSString stringWithFormat:@"%ld分钟",useTime/60%60]:@"";
            NSString *second =  useTime%60?[NSString stringWithFormat:@"%ld秒",useTime%60]:@"";
            NSString *time = [NSString stringWithFormat:@"%@%@%@",hour,minute,second];
            if ([[NSString stringWithFormat:@"%@",dic[@"submit_state"]] isEqualToString:@"1"]) {
                //提交了
                 [vsCell setCellType:1 title:papre score:[NSString stringWithFormat:@"得分：%@",dic[@"score"]] time:time];
            }else {
                //做了一部分没有提交
                 [vsCell setCellType:2 title:papre score:[NSString stringWithFormat:@"已答：%@",dic[@"done_question_count"]]  time:time];
            }
            
        }
   
    
  
    return vsCell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArr.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic =  _dataArr[indexPath.row];
    NSString *recordId = [NSString stringWithFormat:@"%@",dic[@"record_id"]];
    if ([DXCreateUI judgeEmpty:recordId]) {
        return 60;
    }else{
        return 80;
    }
    
}
//组尾的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 50;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 80;
    
}
//创建组头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [[UIView alloc] init];
    UILabel *label  = [DXCreateUI initLabelWithText:@"您的专属班主任为您准备了入学测试，请及时完成，便于班主任后续为您安排最合适的学习计划" textColor:RGBHex(0x392816) font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] textAlignment:(NSTextAlignmentLeft)];
        [view addSubview:label];
        label.numberOfLines = 0 ;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_top).offset(30);
            make.left.mas_equalTo(view.mas_left).offset(15);
            make.right.mas_equalTo(view.mas_right).offset(-15);
        }];
    return view;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    UILabel *label  = [DXCreateUI initLabelWithText:@"注：请确认有充足时间可以完成整套试卷的测试，试卷答题结果以第一次提交为准。" textColor:RGBHex(0x392816) font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] textAlignment:(NSTextAlignmentLeft)];
        [view addSubview:label];
        label.numberOfLines = 0 ;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_top).offset(20);
            make.left.mas_equalTo(view.mas_left).offset(15);
            make.right.mas_equalTo(view.mas_right).offset(-15);
        }];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   [self.delegate clickWithDescription:@"paperId"];
}


#pragma mark 点击事件 click events
- (void)backClick:(UITapGestureRecognizer *)tap {
    
    [self.delegate clickWithDescription:@"返回"];
    
}

@end



#pragma mark cell
@implementation  DXVipServiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
    
}
- (void)setupUI {
    
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = RGBHex(0xDDB272).CGColor;
    self.contentView.layer.cornerRadius = 4;

    _titleLabel  = [DXCreateUI initLabelWithText:@"" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:15] textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.contentView.mas_left).offset(8);
//            make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.7);
            make.right.mas_equalTo(self.contentView.mas_right).offset(90);
        }];

    _rightTopImv = [[UIImageView alloc] initWithImage:VipServiceImage(@"等待")];
        [self.contentView addSubview:_rightTopImv];
        [_rightTopImv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.titleLabel);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        }];
    
}
- (void)setCellType:(NSInteger)type title:(nullable NSString *)title score:(nullable NSString *)score time:(nullable NSString *)time {
    
    [DXCreateUI addBackgroundColorShadowWidth:IPHONE_WIDTH-30 height:type?70:50 fromeColor:RGBHex(0xFFF5E4 ) toColor:RGBHex(0xD9AD6A) cornerRadius:4 superView:self.contentView];
      _titleLabel.text = title;
    if (type==0) return;
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(12);
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.7);
    }];
    _leftLabel  = [DXCreateUI initLabelWithText:score textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] textAlignment:(NSTextAlignmentCenter)];
        [self.contentView addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        }];
    _rightLabel  = [DXCreateUI initLabelWithText:[NSString stringWithFormat:@"答题时间：%@",time] textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] textAlignment:(NSTextAlignmentCenter)];
        [self.contentView addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.leftLabel);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        }];
    
    //已经答完
    if (type==1) {
        [_rightTopImv setImage:VipServiceImage(@"对号")];
        [_rightTopImv mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.right.mas_equalTo(self.contentView.mas_right);
        }];
        //
    } else{
        //答了一部分
        [_rightTopImv removeFromSuperview];
        
        _rightBtn = [DXCreateUI initButtonWithTitle:@"继续测试" titleColor:RGBHex(0x392816) backgroundColor:[UIColor clearColor] font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] controlStateNormal:(UIControlStateNormal) controlStateHighlighted:(UIControlStateNormal) cornerRadius:14];
            [self.contentView addSubview:_rightBtn];
            _rightBtn.layer.borderColor = RGBHex(0xDDB272).CGColor;
            _rightBtn.layer.borderWidth = 1;
            [DXCreateUI addBackgroundColorShadowWidth:80  height:28 fromeColor:RGBHex(0xFFF5E4) toColor:RGBHex(0xD9AD6A) cornerRadius:14 superView:_rightBtn];
//            [_rightBtn addTarget:self action:@selector(click) forControlEvents:(UIControlEventTouchUpInside)];
            [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.titleLabel);
                make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
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
