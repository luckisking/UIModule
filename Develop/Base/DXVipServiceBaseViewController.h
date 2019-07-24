//
//  DXVipServiceBaseViewController.h
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/1.
//  Copyright © 2019 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXCreateUI.h"

NS_ASSUME_NONNULL_BEGIN

@interface DXVipServiceBaseViewController : UIViewController

- (UIButton *)getRightButtonWithWidth:(CGFloat)width height:(CGFloat)height backImage:(nullable UIImage *)image label:(nullable UILabel *)label;
- (void)adjustmentRightButtonSubViewPositionWithRightFromScreen:(CGFloat)right topFromButton:(CGFloat)top width:(CGFloat)width height:(CGFloat)height;

- (nullable UIViewController *)getTargetController:(NSString *)controllerName param:(nullable NSDictionary *)param ;
- (nullable id)executeController:(UIViewController *)controller  method:(NSString *)methodName param:(NSDictionary *)param ;

@end

NS_ASSUME_NONNULL_END
