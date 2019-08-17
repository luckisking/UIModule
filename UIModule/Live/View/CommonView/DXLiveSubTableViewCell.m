//
//  DXLiveSubTableViewCell.m
//  DXLiveSeparation
//
//  Created by doxue_imac on 2019/8/7.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXLiveSubTableViewCell.h"
//#import "NSString+date.h"
#import "SGImageBrowser.h"

@implementation DXLiveSubTableViewCell
@end

@implementation  DXLiveChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = RGBHex(0xF8F9FA);
    }
    return self;
    
}
- (void)setupUI {
    _headImv = [[UIImageView alloc] init];
    _headImv.layer.cornerRadius = 18;
    _headImv.layer.masksToBounds = YES;
    [self.contentView addSubview:_headImv];
    [_headImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(24);
        make.left.mas_equalTo(self.contentView.mas_left).offset(11);
        make.width.height.mas_equalTo(36);
    }];
    
    _nameLabel  = [[UILabel alloc] init];
    _nameLabel.textColor = RGBHex(0x666666);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(15);
        make.left.mas_equalTo(self.headImv.mas_right).offset(4);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    
    _chatInfoLabel  = [[YYLabel alloc] init];
    _chatInfoLabel.backgroundColor = [UIColor whiteColor];
    _chatInfoLabel.layer.cornerRadius = 4;
    _chatInfoLabel.layer.masksToBounds = YES;
    _chatInfoLabel.numberOfLines = 0;
    _chatInfoLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
//    _chatInfoLabel.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);//不起作用 bug?????
    [self.contentView addSubview:_chatInfoLabel];
    [_chatInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(2);
        make.left.mas_equalTo(self.headImv.mas_right).offset(4);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-30);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
}

- (YYTextLayout *)yyLayout{
    CGSize size = CGSizeMake(IPHONE_WIDTH-74, CGFLOAT_MAX);
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:_chatString];
    attString.yy_kern = @(1);
    attString.yy_lineSpacing = 8;
    NSRange range = NSMakeRange(0, _chatString.length);
    [attString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:15]} range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:RGBHex(0x101010) range:range];
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:attString];
    return layout;
}
@end



//#pragma mark 笔记cell实现
//@interface DXLiveNoteCell ()
//@property (nonatomic, strong) UIImageView  *headImageView;
//@property (nonatomic, strong) UILabel *nameLabel;
//@property (nonatomic, strong) UILabel *timeLabel;
//@property (nonatomic, strong) UIImageView *screenshotImageView;
//@property (nonatomic, strong) UILabel *noteLabel;
//
//@end
//
//@implementation DXLiveNoteCell
//
//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self setUpNotes];
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.contentView.backgroundColor = RGBHex(0xF8F9FA);
//    }
//    return self;
//}
//
//
//-(void)setUpNotes{
//    self.backgroundColor = [UIColor whiteColor];
//
//    _headImageView = [[UIImageView alloc]init];
//    [self.contentView addSubview:_headImageView];
//    _headImageView.layer.masksToBounds = YES;
//    _headImageView.layer.cornerRadius = 9.5;
//    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(self.contentView).offset(12);
//        make.size.mas_equalTo(CGSizeMake(19, 19));
//    }];
//
//    _timeLabel = [[UILabel alloc]init];
//    _timeLabel.font = [UIFont systemFontOfSize:13];
//    _timeLabel.textColor = RGBAColor(136, 136, 136, 1);
//    [self.contentView addSubview:_timeLabel];
//    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView).offset(-13);
//        make.centerY.equalTo(self.headImageView.mas_centerY);
//    }];
//
//    _nameLabel = [[UILabel alloc]init];
//    [self.contentView addSubview:_nameLabel];
//    _nameLabel.font = [UIFont systemFontOfSize:14];
//    _nameLabel.textColor = RGBAColor(136, 136, 136, 1);
//    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.headImageView.mas_right).offset(8);
//        make.centerY.equalTo(self.headImageView.mas_centerY);
//        make.right.equalTo(self.timeLabel.mas_left).offset(-5);
//    }];
//
//    _screenshotImageView = [[UIImageView alloc]init];
//    _screenshotImageView.layer.masksToBounds = YES;
//    _screenshotImageView.layer.cornerRadius = 4;
//    _screenshotImageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
//    [_screenshotImageView addGestureRecognizer:tap];
//    [self.contentView addSubview:_screenshotImageView];
//    [_screenshotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.timeLabel.mas_bottom).offset(6);
//        make.right.equalTo(self.contentView).offset(-13);
//        make.height.equalTo(@25);
//        make.width.equalTo(@45);
//    }];
//
//    _noteLabel = [[UILabel alloc]init];
//    _noteLabel.font = [UIFont systemFontOfSize:14];
//    _noteLabel.textColor = dominant_BlockColor;
//    _noteLabel.numberOfLines = 0;
//    [self.contentView addSubview:_noteLabel];
//    [_noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@12);
//        make.top.equalTo(self.headImageView.mas_bottom).offset(8);
//        make.right.equalTo(self.screenshotImageView.mas_left).offset(-11);
//        make.bottom.equalTo(self.contentView).offset(-12);
//    }];
//
//}
//
//-(void)setNoteModel:(DXLiveModuleNoteModel *)noteModel{
//    [_headImageView sd_setImageWithURL:[NSURL URLWithString:noteModel.noteUserModel.headimg] placeholderImage:IMG(@"default_photo")];
//    _nameLabel.text = noteModel.noteUserModel.uname;
//    NSString *noteTime = [self convertDateWithFormatYMD:[noteModel.ctime intValue]];
//    _timeLabel.text = noteTime;
//
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
//    CGSize titleSize = [noteTime boundingRectWithSize:CGSizeMake(300, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@((titleSize.width) + 10));
//    }];
//    if (!noteModel.screenshot || noteModel.screenshot.length == 0) {
//        [_noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@12);
//            make.top.equalTo(self.headImageView.mas_bottom).offset(8);
//            make.right.equalTo(self.contentView).offset(-13);
//            make.bottom.equalTo(self.contentView).offset(-12);
//        }];
//        _screenshotImageView.hidden = YES;
//    }else{
//
//        if (_screenshotImageView.frame.size.height < _noteLabel.frame.size.height) {
//            [_noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(@12);
//                make.top.equalTo(self.headImageView.mas_bottom).offset(8);
//                make.right.equalTo(self.screenshotImageView.mas_left).offset(-10);
//                make.bottom.equalTo(self.contentView).offset(-12);
//            }];
//        }
//        _screenshotImageView.hidden = NO;
//
//        [_screenshotImageView sd_setImageWithURL:[NSURL URLWithString:noteModel.screenshot]];
//    }
//
//    _noteLabel.text = noteModel.note_description;
//
//}
//
//- (void)tapClick:(UIGestureRecognizer *)tap {
//    [SGImageBrowser show:self.screenshotImageView];
//}
//- (NSString *)convertDateWithFormatYMD:(long long)beTime{
//
//    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
//    double distanceTime = now - beTime;
//    NSString * distanceStr;
//
//    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
//    NSDateFormatter * df = [[NSDateFormatter alloc]init];
//    [df setDateFormat:@"HH:mm"];
//    NSString * timeStr = [df stringFromDate:beDate];
//
//    [df setDateFormat:@"dd"];
//    NSString * nowDay = [df stringFromDate:[NSDate date]];
//    NSString * lastDay = [df stringFromDate:beDate];
//
//    if (distanceTime < 60) {//小于一分钟
//        distanceStr = @"刚刚";
//    }
//    else if (distanceTime <60*60) {//时间小于一个小时
//        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
//    }
//    else if(distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
//        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
//    }
//    else if(distanceTime<24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
//
//        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
//            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
//        }
//        else{
//            [df setDateFormat:@"yyyy-MM-dd HH:mm"];
//            distanceStr = [df stringFromDate:beDate];
//        }
//    }
//    //    else if(distanceTime <24*60*60*365){
//    //        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
//    //        distanceStr = [df stringFromDate:beDate];
//    //    }
//    else{
//        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
//        distanceStr = [df stringFromDate:beDate];
//    }
//    return distanceStr;
//}
//@end




#pragma mark 笔记cell实现
@interface DXLiveNewNoteCell ()
@property (nonatomic, strong) UIImageView  *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *screenshotImageView;
@property (nonatomic, strong) YYLabel *noteLabel;

@property (nonatomic, strong) UIButton *favoriteButton;
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UILabel *favoriteLabel;
@property (nonatomic, strong) UILabel *agreeLabel;

@end

@implementation DXLiveNewNoteCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


-(void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    
    _headImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_headImageView];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 15;
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font =  [UIFont fontWithName:@"PingFangSC-Semibold" size:(14)];
    _nameLabel.textColor = RGBHex(0x666666);
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).offset(6);
        make.centerY.equalTo(self.headImageView.mas_centerY);
    }];
    
    _noteLabel = [[YYLabel alloc]init];
//    _noteLabel.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:(16)];
//    _noteLabel.textColor = RGBHex(0x333333);
    _noteLabel.numberOfLines = 0;
    [self.contentView addSubview:_noteLabel];
    [_noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.headImageView.mas_bottom).offset(9);
    }];
    
    _screenshotImageView = [[UIImageView alloc]init];
    _screenshotImageView.layer.masksToBounds = YES;
    _screenshotImageView.layer.cornerRadius = 4;
    _screenshotImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_screenshotImageView addGestureRecognizer:tap];
    [self.contentView addSubview:_screenshotImageView];
    [_screenshotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noteLabel.mas_bottom).offset(6);
        make.left.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(80);
    }];
    
   _favoriteButton = [[UIButton alloc] init];
    [_favoriteButton setImage:IMG(@"favorite") forState:UIControlStateNormal];
    [self.contentView addSubview:_favoriteButton];
    [_favoriteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(13);
//        make.top.mas_equalTo(self.screenshotImageView.mas_bottom).offset(40);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
        make.size.mas_equalTo(CGSizeMake(18, 16));
    }];
    _favoriteLabel = [[UILabel alloc]init];
    _favoriteLabel.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:(13)];
    _favoriteLabel.textColor = RGBHex(0x969696 );
    [self.contentView addSubview:_favoriteLabel];
    [_favoriteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.favoriteButton.mas_right).offset(5);
        make.centerY.mas_equalTo(self.favoriteButton);
    }];
    _agreeButton = [[UIButton alloc] init];
    [_agreeButton setImage:IMG(@"praise") forState:UIControlStateNormal];
    [self.contentView addSubview:_agreeButton];
    [_agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.favoriteLabel.mas_right).offset(20);
        make.centerY.mas_equalTo(self.favoriteButton);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    _agreeLabel = [[UILabel alloc]init];
    _agreeLabel.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:(13)];
    _agreeLabel.textColor = RGBHex(0x969696 );
    [self.contentView addSubview:_agreeLabel];
    [_agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreeButton.mas_right).offset(5);
        make.centerY.mas_equalTo(self.favoriteButton);
    }];
    
    _timeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_timeLabel];
    _timeLabel.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:(13)];
    _timeLabel.textColor = RGBHex(0x969696 );
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.favoriteButton.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
}

-(void)setNoteModel:(DXLiveModuleNoteModel *)noteModel{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:noteModel.noteUserModel.headimg] placeholderImage:IMG(@"default_photo")];
    _nameLabel.text = noteModel.noteUserModel.uname;
    NSString *noteTime = [self convertDateWithFormatYMD:[noteModel.ctime intValue]];
    _timeLabel.text = noteTime;

    if (!noteModel.screenshot || noteModel.screenshot.length == 0) {
        _screenshotImageView.hidden = YES;
        [_screenshotImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        
    }else{
        _screenshotImageView.hidden = NO;
        [_screenshotImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(44);
        }];
        [_screenshotImageView sd_setImageWithURL:[NSURL URLWithString:noteModel.screenshot]];
    }

    _stringLayout = noteModel.note_description;
    _noteLabel.textLayout = self.yyLayout;
    [_noteLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.yyLayout.textBoundingSize.height);
    }];
    _favoriteLabel.text = [NSString stringWithFormat:@"%@人", noteModel.note_collect_count] ;
    _agreeLabel.text =  [NSString stringWithFormat:@"%@人", noteModel.note_help_count] ;
    
}

- (void)tapClick:(UIGestureRecognizer *)tap {
    
    tap.view.userInteractionEnabled = NO; //快速多次点击会奔溃(SGImageBrowser sdk的问题)    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         tap.view.userInteractionEnabled = YES;
    });
    [SGImageBrowser show:self.screenshotImageView];
}
- (NSString *)convertDateWithFormatYMD:(long long)beTime{
    
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    if (distanceTime < 60) {//小于一分钟
        distanceStr = @"刚刚";
    }
    else if (distanceTime <60*60) {//时间小于一个小时
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
    }
    else if(distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
    }
    else if(distanceTime<24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        
        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }
        else{
            [df setDateFormat:@"yyyy-MM-dd HH:mm"];
            distanceStr = [df stringFromDate:beDate];
        }
    }
    //    else if(distanceTime <24*60*60*365){
    //        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    //        distanceStr = [df stringFromDate:beDate];
    //    }
    else{
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}
- (YYTextLayout *)yyLayout{
    CGSize size = CGSizeMake(IPHONE_WIDTH-20, CGFLOAT_MAX);
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:_stringLayout];
    attString.yy_kern = @(1);
    attString.yy_lineSpacing = 8;
    NSRange range = NSMakeRange(0, _stringLayout.length);
    [attString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:16]} range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:RGBHex(0x333333) range:range];
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:attString];
    return layout;
}
- (void)setFrame:(CGRect)frame {

    //修改cell的Y值下移10;
    //修改cell的高度减少10;
    frame.origin.y += 10;
    frame.size.height -=  10;
    [super setFrame:frame];
    
}
@end
