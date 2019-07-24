//
//  DXVipLookCourseView.m
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/14.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXVipLookCourseView.h"

@interface DXVipLookCourseView ()<UITableViewDelegate,UITableViewDataSource>
{

        BOOL flag;
}
//tableView
@property (nonatomic, strong) UITableView *lcTabelView;
//tableView数据
@property (nonatomic,strong) NSArray *data;
//学习对话框
@property (nonatomic, strong) UIView *bgStudyView;
//院校对话框
@property (nonatomic, strong) UIView *bgAcademyView;

//折叠还是展开
@property (nonatomic,strong) NSMutableArray *foldOrUnfold;



@end

@implementation DXVipLookCourseView

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
    _foldOrUnfold = [NSMutableArray array];
    flag = YES;
    _lcTabelView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        [self addSubview:_lcTabelView];
        [_lcTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(self);
        }];
        _lcTabelView.backgroundColor = [UIColor whiteColor];
        _lcTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _lcTabelView.delegate = self;
        _lcTabelView.dataSource = self;
        [_lcTabelView registerClass:[DXVipLookCourseCell class] forCellReuseIdentifier:@"lcCell"];
        _lcTabelView.estimatedRowHeight = 0;
        _lcTabelView.estimatedSectionHeaderHeight = 0;
        _lcTabelView.estimatedSectionFooterHeight = 0;
        _lcTabelView.tableFooterView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    
}

//时间处理
- (NSString *)dateWithTimeInterval:(long long)timeInterval{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSString * dateString = [formatter stringFromDate:date];
    return dateString;
}
//星期几处理
- (NSString *)getWeekDayFordate:(NSTimeInterval)data {
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}
//返回直播时间状态
- (NSInteger)liveStateWihtStart:(NSString *)startStr end:(NSString *)endStr {
    //直播时间状态：0-已结束，1-未开始，2-直播中
    long long  start = startStr.longLongValue;
    long long  end = endStr.longLongValue;
    long long  now = (long long)[[NSDate date] timeIntervalSince1970];
    if (now<start) return 1;
    if (now>end) return 0;
    return 2;
}

#pragma mark tableView的代理方法

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    DXVipLookCourseCell *lcCell = [tableView dequeueReusableCellWithIdentifier:@"lcCell"];
    DXVipServiceVideoMode *videoMode =  _data[indexPath.section];
    NSArray  *jieArr = videoMode.jie;
    DXVipServiceJieMode  *jie = jieArr[indexPath.row];
    if ([jie.study isEqualToString:@"1"]) {
        //学习过的课程设置灰色
        lcCell.cellTitleLabel.textColor = RGBHex(0xB2B2B2);
        lcCell.cellTetaiLabel.textColor = RGBHex(0xB2B2B2);
        lcCell.cellTimeLabel.textColor = RGBHex(0xB2B2B2);
    }else {
        lcCell.cellTitleLabel.textColor = RGBHex(0x6A4D31);
        lcCell.cellTetaiLabel.textColor = RGBHex(0x6A4D31);
        lcCell.cellTimeLabel.textColor = RGBHex(0x6A4D31);
    }
    if (![videoMode.kctype  isEqualToString:@"2"]) {
            //非直播
        [lcCell setCellInfoWithTitle:jie.video_title time:jie.duration detail:nil];
        [lcCell  setAccessibilityIdentifier:@"可以点击"];
    }else{
            //直播
        NSString *teacherName = jie.teacher_name ;
        teacherName  = teacherName.length>4?[teacherName substringToIndex:4]:teacherName;
        NSString *date =  [self dateWithTimeInterval:jie.broadcast_time.longLongValue] ;
        NSString *month = [date substringWithRange:NSMakeRange(6, 5)];
        NSString *week = [self getWeekDayFordate:jie.broadcast_time.longLongValue];
        NSString *time = [date substringFromIndex:11];
        NSString *detail = [NSString stringWithFormat:@"%@ 直播时间：%@ （%@) %@",teacherName,month,week,time];
        [lcCell setCellInfoWithTitle:jie.video_title time:jie.duration detail:detail];
        NSInteger state = [self liveStateWihtStart:jie.broadcast_time end:jie.broadcast_endtime];
        //直播时间状态：0-已结束，1-未开始，2-直播中
         BOOL hasClick  = NO;//是否可以点击
        [lcCell setLiveType:state];
        if (state==0&&![DXCreateUI judgeEmpty:jie.live_playback_url]) {
                //有回放
               [lcCell setLiveType:4];
              hasClick = YES;
        }
        if (state==2) hasClick = YES;
        if (hasClick) {
             [lcCell  setAccessibilityIdentifier:@"可以点击"];
        }else {
             [lcCell  setAccessibilityIdentifier:@"不可以点击"];
        }
       
    }
    return lcCell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![((NSNumber *)_foldOrUnfold[section]) intValue]) {
        return 0;
    }else{
        DXVipServiceVideoMode *videoMode =  _data[section];
        NSArray  *jieArr = videoMode.jie;
        return jieArr.count;
    }

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _data.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![((DXVipServiceVideoMode *)_data[indexPath.section]).kctype  isEqualToString:@"2"]) {
        //非直播
        return 50;
    }else{
        //直播
        return 66;
    }
}
//组尾的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 20;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 57;
    
}
//创建组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DXVipServiceVideoMode *videoMode =  _data[section];
    NSArray  *jieArr = videoMode.jie;
    NSString *detail ;
    BOOL zhibo = NO;
    if (![videoMode.kctype  isEqualToString:@"2"]) {
        //非直播
        detail = [NSString stringWithFormat:@"共%ld小节  视频时长 %@",jieArr.count,videoMode.duration];
    }else{
        zhibo = YES;
        detail = [NSString stringWithFormat:@"共%ld小节  直播时长 %@",jieArr.count,videoMode.duration];
    }
    NSString * headImage  = [DXCreateUI judgeEmpty:videoMode.thumb]?nil:videoMode.thumb;
    if (![headImage hasPrefix:@"http"]) headImage = VSStringFormatWithFront(@"https:", headImage);
    UIView *view = [self getHeadViewWithHeadImage:headImage title:videoMode.video_title iszhibo:zhibo detail:detail upDownImage:![_foldOrUnfold[section] intValue]?@"向下小箭头":@"向上箭头"];
        view.tag = 1000 + section;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectHeaderView:)];
        [view addGestureRecognizer:tap];
    return view;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DXVipServiceVideoMode *videoMode =  _data[indexPath.section];
    DXVipServiceJieMode  *jie = videoMode.jie[indexPath.row];
    NSDictionary *param = @{@"jieId":jie.jieId,@"kctype":videoMode.kctype,@"courseId":videoMode.courseId,@"zhangId":jie.zhangid?:@""};
    if ([[tableView cellForRowAtIndexPath:indexPath].accessibilityIdentifier isEqualToString:@"可以点击"]) {
        [self.delegate clickWithDescription:@"视频或直播" param:param];
    }
}

- (void)didSelectHeaderView:(UITapGestureRecognizer *)tap{
    NSInteger i =  tap.view.tag-1000;
    //取反
    _foldOrUnfold[i] = [_foldOrUnfold[i] intValue]==0?@1:@0;
    //刷新列表
    NSIndexSet * index = [NSIndexSet indexSetWithIndex:i];
    [_lcTabelView reloadSections:index withRowAnimation:UITableViewRowAnimationAutomatic];


    
}
#pragma mark 头视图
- (UIView *)getHeadViewWithHeadImage:(nullable NSString *)image
                               title:(NSString *)title
                             iszhibo:(BOOL)zhibo
                              detail:(NSString *)detail
                         upDownImage:( NSString *)udImage {
    UIView *view = [[UIView alloc] init];
    UIImageView *leftImv = [[UIImageView alloc] initWithImage:VipServiceImage(image?:@"课程占位图")];
        if (image) [leftImv setImageWithURL: [NSURL URLWithString:image]];
        leftImv.layer.cornerRadius = 4;
        leftImv.layer.masksToBounds = YES;
        [view addSubview:leftImv];
        [leftImv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_top);
            make.bottom.mas_equalTo(view.mas_bottom);
            make.left.mas_equalTo(view.mas_left).offset(12);
            make.width.mas_equalTo(102);
        }];
    UILabel *titleLabel  = [DXCreateUI initLabelWithText:title textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:15] textAlignment:(NSTextAlignmentLeft)];
        [view addSubview:titleLabel];
        titleLabel.numberOfLines = 0;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_top);
            make.left.mas_equalTo(leftImv.mas_right).offset(10);
            make.right.mas_equalTo(view.mas_right).offset(-25);
        }];
    if (zhibo) {
        UIImageView *zhiboImv = [[UIImageView alloc] initWithImage:VipServiceImage(@"直播")];
            [view addSubview:zhiboImv];
            [zhiboImv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(titleLabel.mas_bottom).offset(3);
                make.left.mas_equalTo(leftImv.mas_right).offset(10);
            }];
    }
     UILabel *detailLabel  = [DXCreateUI initLabelWithText:detail textColor:RGBHex(0x666666) font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] textAlignment:(NSTextAlignmentLeft)];
        [view addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftImv.mas_right).offset(10);
            make.bottom.mas_equalTo(view.mas_bottom);
            make.right.mas_equalTo(view.mas_right).offset(-45);
        }];
    UIImageView *rightBottomImv = [[UIImageView alloc] initWithImage:VipServiceImage(udImage)];
        [view addSubview:rightBottomImv];
    rightBottomImv.tag = 1500;
        [rightBottomImv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(detailLabel);
            make.right.mas_equalTo(view.mas_right).offset(-25);
        }];
    return view;
}

- (void)refreshData:(NSArray *)array {
    _data = array;
    for (int i=0; i< array.count; i++) {
        [_foldOrUnfold addObject:@0];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.lcTabelView reloadData];
    });
}


@end


#pragma mark cell
@implementation  DXVipLookCourseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI {
    
    self.contentView.backgroundColor = [RGBHex(0xFCE0B0) colorWithAlphaComponent:0.1];
    _cellTitleLabel  = [DXCreateUI initLabelWithText:@"" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:_cellTitleLabel];
        _cellTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(9);
            make.left.mas_equalTo(self.contentView.mas_left).offset(6);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-100);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-9);
        }];
    _cellTimeLabel  = [DXCreateUI initLabelWithText:@"" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] textAlignment:(NSTextAlignmentRight)];
        [self.contentView addSubview:_cellTimeLabel];
        [_cellTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.cellTitleLabel);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        }];
    _cellTetaiLabel  = [DXCreateUI initLabelWithText:@"" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] textAlignment:(NSTextAlignmentLeft)];
        [self.contentView addSubview:_cellTetaiLabel];
        _cellTetaiLabel.hidden = YES;

    _cellRightButton = [DXCreateUI initButtonWithTitle:@"直播中" titleColor:RGBHex(0x392816) backgroundColor:[UIColor clearColor] font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] controlStateNormal:(UIControlStateNormal) controlStateHighlighted:(UIControlStateNormal) cornerRadius:13];
        [self.contentView addSubview:_cellRightButton];
        _cellRightButton.hidden = YES;
        _cellRightButton.userInteractionEnabled = NO;
//        [_cellRightButton addTarget:self action:nil forControlEvents:(UIControlEventTouchUpInside)];
        [_cellRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-21);
            make.size.mas_equalTo(CGSizeMake(76, 26));
        }];
}
//设置cell信息
- (void)setCellInfoWithTitle:(NSString *)title time:(nullable NSString *)time detail:(nullable NSString *)detail {
    _cellTitleLabel.text = title;
    _cellTimeLabel.text = time;
    if (CGColorEqualToColor(_cellTimeLabel.textColor.CGColor, RGBHex(0xB2B2B2).CGColor)) {
        _cellTimeLabel.text = @"已学";//如果已经学了显示已查看而不是时间
    }
    _cellTetaiLabel.text = detail;
    
    //还原初始状态
    _cellTimeLabel.hidden = NO;
    _cellTetaiLabel.hidden = YES;
    _cellRightButton.hidden = YES;
}
//设置直播类型
- (void)setLiveType:(NSInteger)type {
    [_cellTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(9);
        make.left.mas_equalTo(self.contentView.mas_left).offset(6);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-120);
    }];
    _cellTimeLabel.hidden = YES;
    _cellTetaiLabel.hidden = NO;
    [_cellTetaiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-97);
//        make.top.mas_equalTo(self.cellTitleLabel.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-6);
    }];
    
    
    _cellRightButton.hidden = NO;
    _cellRightButton.userInteractionEnabled = YES;
    
    if (type==2) {
        [_cellRightButton setTitle:@"直播中" forState:(UIControlStateNormal)];
        _cellRightButton.backgroundColor = RGBHex(0xFAB820);
    }else  if (type==1) {
         [_cellRightButton setTitle:@"未开始" forState:(UIControlStateNormal)];
    }else  if (type==0) {
        [_cellRightButton setTitle:@"已结束" forState:(UIControlStateNormal)];
    }else  if (type==4) {
        [_cellRightButton setTitle:@"有回放" forState:(UIControlStateNormal)];
        _cellRightButton.layer.borderColor = RGBHex(0xDDB272).CGColor;
        _cellRightButton.layer.borderWidth = 1;
        [DXCreateUI addBackgroundColorShadowWidth:76  height:26 fromeColor:RGBHex(0xFFF5E4) toColor:RGBHex(0xD9AD6A) cornerRadius:13 superView:_cellRightButton];
    }
}
- (void)setFrame:(CGRect)frame
{
    
    //修改cell的左右边距为15;
    //修改cell的Y值下移10;
    //修改cell的高度减少10;
    static CGFloat marginLeftRight = 12;
    static CGFloat marginHeight = 10;
    frame.origin.x = marginLeftRight;
    frame.size.width -= 2 * marginLeftRight;
    frame.origin.y += marginHeight;
    frame.size.height -=  marginHeight;
    [super setFrame:frame];

}





@end


