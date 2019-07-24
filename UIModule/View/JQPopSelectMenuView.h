//
//  JQPopSelectMenuView.h
//  Doxuewang
//
//  Created by jq on 2019/6/10.
//  Copyright © 2019 都学网. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Masonry/Masonry.h>


/**
  Normal就是改变高度，适合select视图 ，视图弹出动画模式,Transform是缩放动画，适用于弹出视图，如要实现平移等其他动画，请实现代理show方法
 */
typedef NS_ENUM(NSUInteger, JQSelectMenumShowMode) {
    JQSelectMenumModeNone,
    JQSelectMenumModeNormal,                          //uiview简单动画
    JQSelectMenumModeTransformTriangleBottom,        //三角形底部动画 (类似top动画，就是位置跟随三角形的位置)
    JQSelectMenumModeTransformTop,
   
};

NS_ASSUME_NONNULL_BEGIN
/**
 代理方法
 */
@class JQPopSelectMenuView;
@class JQPopSelectMenuTableViewCell;
@protocol JQPopSelectMenuViewDelegate <NSObject>
@optional
/* 实现了协议的showCustom和hideCustom，以下4个方法将不会触发*/
- (void)JQPopSelectMenuViewWillShow:(UITableView *)tableView view:(JQPopSelectMenuView *)view ;   //当下拉菜单将要显示时调用
- (void)JQPopSelectMenuViewDidShow:(UITableView *)tableView view:(JQPopSelectMenuView *)view ;     // 当下拉菜单已经显示时调用
- (void)JQPopSelectMenuViewWillHidden:(UITableView *)tableView view:(JQPopSelectMenuView *)view ;  // 当下拉菜单将要收起时调用
- (void)JQPopSelectMenuViewDidHidden:(UITableView *)tableView view:(JQPopSelectMenuView *)view ;   // 当下拉菜单已经收起时调用
//设置tableView和self的外观 (-----------如要实现自动布局请在此设置---------------)
- (void)JQPopSelectMenuViewAppearanceConfigTableView:(UITableView *)tableView view:(JQPopSelectMenuView *)view;
//设置cell的外观
- (void)JQPopSelectMenuViewAppearanceConfigCell:(JQPopSelectMenuTableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath ;
//设置选中cell（可以不实现，默认提供block回调）
- (void)JQPopSelectMenuViewTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath ;
//设置cell 高亮
- (void)JQPopSelectMenuViewCell:(JQPopSelectMenuTableViewCell *)cell setHighlighted:(BOOL)highlighted animated:(BOOL)animated ;
//设置cell 选中
- (void)JQPopSelectMenuViewCell:(JQPopSelectMenuTableViewCell *)cell setSelected:(BOOL)selected animated:(BOOL)animated  ;

//自定义show和hide动画(最好成对实现)
- (void)JQPopSelectMenuViewshowCustom:(UITableView *)tableView view:(JQPopSelectMenuView *)view ;
- (void)JQPopSelectMenuViewhideCustom:(UITableView *)tableView view:(JQPopSelectMenuView *)view ;

@end

@interface JQPopSelectMenuView : UIView

@property (nonatomic, weak) id <JQPopSelectMenuViewDelegate> delegate;
@property(nonatomic, assign)JQSelectMenumShowMode showMode;  //视图出现的时候动画类型
@property(nonatomic, assign)BOOL multipleInstance ; //是否允许弹出多个实例对象 默认YES,

@property(nonatomic, assign)BOOL HideNeedMode;       //视图消失的时候是否需要动画，会朝着视图出现动画的反方向动画，默认Yes
@property(nonatomic, assign)CGFloat animationTime;   //动画时长

@property(nonatomic, assign)CGFloat cellHeight  ;       //cell的高度
@property(nonatomic, assign)NSUInteger showGrandCount;  //不滑动的情况下显示最大的行数


@property(nonatomic, strong)NSString *JQNotselected;  //非选中图片
@property(nonatomic, strong)NSString *JQselected;   //选中图片
@property (nonatomic, assign)NSInteger showIndex;   //默认选中(上一次选中)

/*
  数组格式
  @[@{@"image":@"",@"title":@""}]
*/
/*ViewModeSelect  选择视图,类似html5的选择视图*/
- (instancetype)initSelectWithFrame:(CGRect)frame items:(NSArray <NSDictionary *>*)array action:(void(^)(NSInteger index))action ;
/*ViewModePop  弹出视图*/
- (instancetype)initPopWithFrame:(CGRect)frame items:(NSArray <NSDictionary *>*)array action:(void(^)(NSInteger index))action ;

/*ViewModePop  弹出视图类方法，快速弹出，全屏背景，可以在右上角绘制一个三角形*/
+ (void)showPopWithFrame:(CGRect)frame
                   items:(NSArray <NSDictionary *>*)array
           triangleFrame:(CGRect)triangleFrame
               fillColor:(UIColor *)fillColor
             strokeColor:(UIColor *)strokeColor
                delegate:(nullable id<JQPopSelectMenuViewDelegate>)delegate
                  action:(void(^)(NSInteger index))action ;
//刷新数据
- (void)reloadData:(NSArray <NSDictionary *>*)array;
@end

@interface JQPopSelectMenuTableViewCell : UITableViewCell
@property (nonatomic, weak) id <JQPopSelectMenuViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong)UIImageView *rightImageView;
@end

NS_ASSUME_NONNULL_END
