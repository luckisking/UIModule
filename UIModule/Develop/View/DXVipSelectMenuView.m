//
//  DXVipSelectMenuView.m
//  Doxuewang
//
//  Created by xjq on 2019/6/10.
//  Copyright © 2019 都学网. All rights reserved.
//
#import "DXVipSelectMenuView.h"
static CGFloat const kCellHeight = 40;


@interface DXVipSelectMenuTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong)UIImageView *rightImageView;


@end

@interface DXVipSelectMenuView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    CGFloat _dynamicHeight;
    NSInteger _showIndex;
}

@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, assign) CGPoint trianglePoint;
@property (nonatomic, assign) CGFloat triangleWith;
@property (nonatomic, copy) void(^action)(NSInteger index);
@end

@implementation DXVipSelectMenuView

- (instancetype)initWithItems:(NSArray <NSDictionary *>*)array
                        frame:(CGRect)frame
             triangleLocation:(CGPoint)point
                       action:(void(^)(NSInteger index))action index:(NSInteger)lastIndex
{
    _showIndex = lastIndex;
    if (array.count == 0) return nil;
    if (self = [super init]) {
        
        self.backgroundColor  = RGBHex(0x878787);
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        _tableData = [array copy];
        self.action = action;
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        
        if (array.count<=6) {
            _dynamicHeight = kCellHeight *array.count;
        }else{
            _dynamicHeight = kCellHeight * 6;
        }
        self.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMaxY(frame), frame.size.width, _dynamicHeight);
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = RGBHex(0xd9dbe0);
        _tableView.scrollEnabled = YES;
        _tableView.rowHeight = kCellHeight;
        [_tableView registerClass:[DXVipSelectMenuTableViewCell class] forCellReuseIdentifier:@"DXVipSelectMenuTableViewCell"];
        [self addSubview:_tableView];
        
        _tableView.layer.borderWidth = 1;
        _tableView.layer.borderColor = RGBHex(0xE2CFAC).CGColor;
        
    }
    return self;
}

+ (void)showWithItems:(NSArray <NSDictionary *>*)array
                frame:(CGRect)frame
     triangleLocation:(CGPoint)point
               action:(void(^)(NSInteger index))action     index:(NSInteger)lastIndex
{
    DXVipSelectMenuView *view = [[DXVipSelectMenuView alloc] initWithItems:array   frame:frame triangleLocation:point action:action index:lastIndex];
    
    [view show];
    
}

- (void)tap {
    [self hide];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        return NO;
    }
    return YES;
}

#pragma mark - show or hide
- (void)show {
//    __weak typeof(self) weakself = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    _tableView.layer.position = CGPointMake(kDeviceWidth - 15, _trianglePoint.y + 5);
//    _tableView.layer.anchorPoint = CGPointMake(1.0, 0);
//    _tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
//    [UIView animateWithDuration:0.2 animations:^{
//        self.alpha = 1;
//        weakself.tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
//    }];
    
}

- (void)hide {
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.2 animations:^{
//        self.alpha = 0;
//        weakself.tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } completion:^(BOOL finished) {
        [weakself.tableView removeFromSuperview];
        [self removeFromSuperview];
        if (self.hideHandle) {
            self.hideHandle();
        }
    }];
}

#pragma mark - Draw triangle

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DXVipSelectMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DXVipSelectMenuTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = _tableData[indexPath.row];
    [cell.titleLabel sizeToFit];
    cell.titleLabel.textColor = RGBHex(0x000000);
    
    cell.rightImageView.image = [UIImage imageNamed:@"Notselected.png"];
    if (indexPath.row==_showIndex) {
        cell.rightImageView.image = [UIImage imageNamed:@"choose.png"];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_action) {
        _action(indexPath.row);
        
        
    }
    
    [self hide];
}



@end

@implementation DXVipSelectMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _leftImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_leftImageView];
        [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = RGBHex(0x000000);
        [self.contentView addSubview:_titleLabel];
        __weak typeof(self) weakself = self;
        [weakself.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(weakself.leftImageView.mas_right).offset(0);
        }];
        _rightImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_rightImageView];
        [_rightImageView setImage:[UIImage imageNamed:@"Notselected.png"]];
        [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-30);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(16);
        }];

        
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }else {
        self.backgroundColor = [UIColor whiteColor];
    }
    
}

@end
