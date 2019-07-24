//
//  JQPopSelectMenuView.m
//  Doxuewang
//
//  Created by jq on 2019/6/10.
//  Copyright © 2019 都学网. All rights reserved.
//
#import "JQPopSelectMenuView.h"

static JQPopSelectMenuView *ViewManager = nil; //是否允许弹出多个实例
/**
 视图模式
 */
typedef NS_ENUM(NSUInteger, JQSelectMenumViewMode) {
    ViewModePop,        //弹出视图
    ViewModeSelect      //选择视图，类似html5的select视图
};

@interface JQPopSelectMenuView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong,nullable) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, assign) CGFloat  dynamicHeight;//tableVeiw的高度
@property (nonatomic, copy) void(^action)(NSInteger index);

@property(nonatomic, assign)JQSelectMenumViewMode viewMode;  //视图类型

/*三角形相关*/
@property (nonatomic, assign) CGRect triangleFrame;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *strokeColor;


@end

@implementation JQPopSelectMenuView

- (instancetype)initPopWithFrame:(CGRect)frame items:(NSArray <NSDictionary *>*)array  action:(void(^)(NSInteger index))action {
    if (array.count == 0) return nil;
    if (self = [super initWithFrame:frame]) {
        
        _showMode = JQSelectMenumModeNormal;
        _viewMode = ViewModePop;
        _tableData = [array copy];
        _action = action;
         [self initConfig];
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];

    }
    return self;
}
+ (void)showPopWithFrame:(CGRect)frame
                   items:(NSArray <NSDictionary *>*)array
           triangleFrame:(CGRect)triangleFrame
               fillColor:(UIColor *)fillColor
             strokeColor:(UIColor *)strokeColor
                delegate:(nullable id<JQPopSelectMenuViewDelegate>)delegate
               action:(void(^)(NSInteger index))action {
    JQPopSelectMenuView *view = [[JQPopSelectMenuView alloc] initPopWithFrame:frame items:array action:action];
    view.delegate = delegate;
    [view initTableViewWithFrame:frame];
    frame.size.height = view.dynamicHeight;
    view.tableView.frame = frame;
    if (!CGRectIsNull(triangleFrame)&&!CGRectIsEmpty(triangleFrame)) {
        view.showMode = JQSelectMenumModeTransformTriangleBottom;
        view.triangleFrame = triangleFrame;
        view.fillColor = fillColor ;
        view.strokeColor = strokeColor;
    }
    view.frame = [UIScreen mainScreen].bounds;
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (instancetype)initSelectWithFrame:(CGRect)frame items:(NSArray <NSDictionary *>*)array action:(void(^)(NSInteger index))action {
    if (self = [super initWithFrame:frame]) {
        _showMode = JQSelectMenumModeNormal;
        _viewMode = ViewModeSelect;
        _tableData = [array copy];
        _action = action;
        [self initConfig];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)initConfig {
    _cellHeight = 40;
    _showGrandCount = 5;
    _HideNeedMode  = YES;
    _animationTime = 0.2;
    _fillColor  = [UIColor whiteColor];
    _strokeColor  = [UIColor whiteColor];
    if (_tableData.count<=_showGrandCount) {
        _dynamicHeight = _cellHeight *_tableData.count;
    }else{
        _dynamicHeight = _cellHeight * _showGrandCount;
    }
}

- (void)initTableViewWithFrame:(CGRect)frame {
    if (_viewMode == ViewModeSelect) {
        frame.origin.y = frame.size.height;
        frame.size.height = _dynamicHeight;
    }else {
        frame.size.height = _dynamicHeight;
    }
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = YES;
    _tableView.rowHeight = _cellHeight;
    [_tableView registerClass:[JQPopSelectMenuTableViewCell class] forCellReuseIdentifier:@"JQPopSelectMenuTableViewCell"];
    [self addSubview:_tableView];
    if ([self.delegate respondsToSelector:@selector(JQPopSelectMenuViewshowCustom:view:)]||[self.delegate respondsToSelector:@selector(JQPopSelectMenuViewhideCustom:view:)]) {
        _showMode = JQSelectMenumModeNone;
    }
}
- (void)tap {
    [self hide];
}
- (void)tapAction {
    if (_tableView) {
        [self hide];
        return;
    }
    [self show];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        return NO;
    }
    if ([touch.view isKindOfClass:[UITableView class]]) {
        return NO;
    }
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma mark - show or hide
- (void)show {
    if (!_tableView) [self initTableViewWithFrame:self.bounds];
    if ([self.delegate respondsToSelector:@selector(JQPopSelectMenuViewAppearanceConfigTableView:view:)]) {
        [self.delegate JQPopSelectMenuViewAppearanceConfigTableView:_tableView view:self];
    }
    [self.superview layoutIfNeeded];
    [self layoutIfNeeded];
    for (UIView * view in self.superview.subviews) {
        if ([view isKindOfClass:[JQPopSelectMenuView class]]) {
            if (view != self&&CGRectEqualToRect(view.frame, self.frame)) {
                [(JQPopSelectMenuView *)view hide];
                [view removeFromSuperview];
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(JQPopSelectMenuViewshowCustom:view:)]) {
        [self.delegate JQPopSelectMenuViewshowCustom:_tableView view:self];
        return;
    }
    switch (_showMode) {
        case JQSelectMenumModeNone:break;
        case JQSelectMenumModeTransformTriangleBottom:{
            if (CGRectIsNull(_triangleFrame)) break;
            CGFloat scaleWithPositon =  (_triangleFrame.origin.x+_triangleFrame.size.width/2)/_tableView.frame.size.width;
            //将动画的起始点设置在三角形的位置底部中间
            _tableView.layer.position = CGPointMake(_tableView.frame.origin.x+_tableView.frame.size.width*scaleWithPositon, _tableView.frame.origin.y );
            _tableView.layer.anchorPoint = CGPointMake(scaleWithPositon, 0);
            _tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
            break;
        }
        case JQSelectMenumModeTransformTop:{
            //将动画的起始点设置在tableView顶部中间位置
            _tableView.layer.position = CGPointMake(_tableView.layer.position.x, _tableView.frame.origin.y );
            _tableView.layer.anchorPoint = CGPointMake(0.5, 0);
            _tableView.transform = CGAffineTransformMakeScale(1, 0.0001);
            break;
        }
        case JQSelectMenumModeNormal:{
            CGRect frame  =  _tableView.frame;
            _dynamicHeight = frame.size.height; 
            frame.size.height = 0;
            _tableView.frame = frame;
            break;
        }
        default:{
              break;
        }
    }
    if ([self.delegate respondsToSelector:@selector(JQPopSelectMenuViewWillShow:view:)]) {
        [self.delegate JQPopSelectMenuViewWillShow:_tableView view:self];
    }
    [UIView animateWithDuration:_animationTime animations:^{
        if (self.showMode==JQSelectMenumModeNormal) {
            CGRect frame  =  self.tableView.frame;
            frame.size.height = self.dynamicHeight;
            self.tableView.frame  =  frame;
        }else {
            self.tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }
      
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(JQPopSelectMenuViewDidShow:view:)]) {
            [self.delegate JQPopSelectMenuViewDidShow:self.tableView view:self];
        }
    }];
}

- (void)hide {
    if ([self.delegate respondsToSelector:@selector(JQPopSelectMenuViewhideCustom:view:)]) {
        [self.delegate JQPopSelectMenuViewhideCustom:_tableView view:self];
        _tableView = nil;
        return;
    }
    if ([self.delegate respondsToSelector:@selector(JQPopSelectMenuViewWillHidden:view:)]) {
        [self.delegate JQPopSelectMenuViewWillHidden:_tableView view:self];
    }
    [UIView animateWithDuration:0.2 animations:^{

        if (self.HideNeedMode) {
            switch (self.showMode) {
                case JQSelectMenumModeNone:break;
                case JQSelectMenumModeTransformTriangleBottom: self.tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);    break;
                case JQSelectMenumModeTransformTop: self.tableView.transform = CGAffineTransformMakeScale(1, 0.0001);                    break;
                case JQSelectMenumModeNormal:{
                    CGRect frame  =  self.tableView.frame;
                    frame.size.height = 0;
                    self.tableView.frame = frame;
                    break;
                }
                default:
                    break;
            }
        }
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(JQPopSelectMenuViewDidHidden:view:)]) {
            [self.delegate JQPopSelectMenuViewDidHidden:self.tableView view:self];
        }
        [self.tableView removeFromSuperview];
        if (self.viewMode == ViewModePop) {
            [self removeFromSuperview];
        }else {
            self.tableView = nil;
        }
    }];
}

#pragma mark - Draw triangle
- (void)drawRect:(CGRect)rect {
    if (!CGRectIsNull(_triangleFrame)&&!CGRectIsEmpty(_triangleFrame)) {
        CGRect triangleRect =  CGRectMake(_tableView.frame.origin.x+_triangleFrame.origin.x, _tableView.frame.origin.y+_triangleFrame.origin.y, _triangleFrame.size.width, _triangleFrame.size.height);
        [[UIColor whiteColor] set];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextBeginPath(context);
        CGPoint point =   CGPointMake(triangleRect.origin.x, triangleRect.origin.y);
        CGContextMoveToPoint(context, point.x, point.y);
        CGContextAddLineToPoint(context, point.x - triangleRect.size.width, point.y + triangleRect.size.height);
        CGContextAddLineToPoint(context, point.x + triangleRect.size.width, point.y + triangleRect.size.height);
        CGContextClosePath(context);
        [_fillColor setFill];
        [_strokeColor setStroke];
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}
- (void)setTriangleFrame:(CGRect)frame fillColor:(UIColor *)fillColor  strokeColor:(UIColor *)strokeColor {
    _triangleFrame = frame;
    _fillColor = fillColor;
    _strokeColor = strokeColor;
    [self setNeedsDisplay];
}
#pragma mark - select out of  view response event(超出父视图)
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint myPoint = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, myPoint)) {
                return subView;
            }
        }
    }
    return view;
    
}

- (void)didMoveToSuperview {
    if ([self superview]){
        if(self.viewMode==ViewModeSelect) {
            if ([self.delegate respondsToSelector:@selector(JQPopSelectMenuViewAppearanceConfigTableView:view:)]) {
                [self.delegate JQPopSelectMenuViewAppearanceConfigTableView:_tableView view:self];
            }
        }else{
           [self show];
        }
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JQPopSelectMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JQPopSelectMenuTableViewCell" forIndexPath:indexPath];
    cell.delegate = self.delegate;
    cell.titleLabel.text = _tableData[indexPath.row][@"title"];
    if (![_tableData[indexPath.row][@"image"] isEqualToString:@""]) {
        cell.leftImageView.hidden = NO;
        [cell.leftImageView setImage:[UIImage imageNamed:_tableData[indexPath.row][@"image"]]];
    }else {
        cell.leftImageView.hidden = YES;
        [cell.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView.mas_left).offset(15);
        }];
    }
    if (_JQNotselected) {
          cell.rightImageView.image = [UIImage imageNamed:_JQNotselected];
    }
    if (_JQselected) {
        if (indexPath.row==_showIndex) {
            cell.rightImageView.image = [UIImage imageNamed:_JQselected];
        }
    }
    if ([self.delegate respondsToSelector:@selector(JQPopSelectMenuViewAppearanceConfigCell:cellForRowAtIndexPath:)]) {
        [self.delegate JQPopSelectMenuViewAppearanceConfigCell:cell cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(JQPopSelectMenuViewTableView:didSelectRowAtIndexPath:)]) {
        [self.delegate JQPopSelectMenuViewTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    if (_action) {
        _action(indexPath.row);
    }
    [self hide];
    
}
- (void)reloadData:(NSArray <NSDictionary *>*)array {
    self.tableData = array;
    [self.tableView reloadData];
}

#pragma mark  SET METHOD

- (void)setMultipleInstance:(BOOL)multipleInstance {
    if (multipleInstance) {
        [ViewManager removeFromSuperview];
        ViewManager = nil;
    }else {
        [ViewManager removeFromSuperview];
        ViewManager = self;
    }
    _multipleInstance = multipleInstance;
}

- (void)setCellHeight:(CGFloat)cellHeight {
    
    CGRect frame = _tableView.frame;
    _dynamicHeight = _showGrandCount*cellHeight;
    frame.size.height = _dynamicHeight;
    _tableView.frame = frame;
    _tableView.rowHeight = cellHeight;
    [_tableView reloadData];
    
    _cellHeight = cellHeight;
}
- (void)setShowGrandCount:(NSUInteger)showGrandCount {
    CGRect frame = self.tableView.frame;
    _dynamicHeight = showGrandCount*_cellHeight;
     frame.size.height = _dynamicHeight;
    _tableView.frame = frame;

    _showGrandCount = showGrandCount;
}
- (void)setShowIndex:(NSInteger)showIndex {
      [_tableView reloadData];
    _showIndex = showIndex;
}
- (void)setDelegate:(id<JQPopSelectMenuViewDelegate>)delegate {
    [_tableView reloadData];
    _delegate = delegate;
}

@end

@implementation JQPopSelectMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layoutMargins = UIEdgeInsetsZero;
        self.separatorInset = UIEdgeInsetsZero;
        
        _leftImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_leftImageView];
        _leftImageView.hidden = YES;
        [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.size.mas_lessThanOrEqualTo(30);
            make.left.equalTo(self.contentView).offset(15);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel sizeToFit];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(45);
        }];
        _rightImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_rightImageView];
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
    if ([self.delegate respondsToSelector:@selector(JQPopSelectMenuViewCell:setHighlighted:animated:)]) {
        [self.delegate JQPopSelectMenuViewCell:self setHighlighted:highlighted animated:animated];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if ([self.delegate respondsToSelector:@selector(JQPopSelectMenuViewCell:setSelected:animated:)]) {
        [self.delegate JQPopSelectMenuViewCell:self setSelected:selected animated:animated];
    }
}
@end

