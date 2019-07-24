//
//  DXVipDefine.h
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/14.
//  Copyright © 2019 都学网. All rights reserved.
//

#ifndef DXVipDefine_h
    #define DXVipDefine_h
    #define VipServiceImage(name) [[NSBundle bundleForClass:[self class]] URLForResource:@"DXVipService" withExtension:@"bundle"]?[UIImage imageNamed:name inBundle:[NSBundle bundleWithURL: [[NSBundle bundleForClass:[self class]] URLForResource:@"DXVipService" withExtension:@"bundle"]] compatibleWithTraitCollection:nil] : nil
//    #define VipServiceImage(name)  [UIImage imageNamed:name]
    #define VSStringFormat(object) [NSString stringWithFormat:@"%@",object]
    #define VSStringFormatWithFront(front,object) [NSString stringWithFormat:@"%@%@",front,object]
    #define VSStringFormatWithMid(front,object,behind) [NSString stringWithFormat:@"%@%@%@",front,object,behind]
    #define VSStringFormatInt(int) [NSString stringWithFormat:@"%d",int]
    #define VSStringFormatInteger(integer) [NSString stringWithFormat:@"%ld",integer]
    #define VSStringFormatFloat(float) [NSString stringWithFormat:@"%f",float]
    #define VSAction(target,method) ([target respondsToSelector:@selector(method)]?@selector(method):nil)

//苹方字体 苹果系统苹果方字体比 UI  windons系统苹方字体 相同字体粗一号
#define vPingFangLight(fontSize)                   [UIFont fontWithName:@"PingFangSC-Light" size:(fontSize)]
#define vPingFangRegular(fontSize)                 [UIFont fontWithName:@"PingFangSC-Regular" size:(fontSize)]
#define vPingFangMedium(fontSize)                  [UIFont fontWithName:@"PingFangSC-Medium" size:(fontSize)]
#define vPingFangBold(fontSize)                    [UIFont fontWithName:@"PingFangSC-Semibold" size:(fontSize)]



#endif



















/*以下定义从主项目中copy来的*/
//#define VipServiceModule
#ifndef VipServiceModule
//设备大小
#define IPHONE_WIDTH [[UIScreen mainScreen] bounds].size.width
#define IPHONE_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define kScreen_Bounds [UIScreen mainScreen].bounds
//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhoneX
#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define iPhoneX (IS_iPhoneX || IS_IPHONE_Xr || IS_IPHONE_Xs || IS_IPHONE_Xs_Max)

#define IS_IPHONE_X iPhoneX

#define RGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define logDic(dic)   NSLog(@"打印字典=%@",[[NSString alloc] initWithData: [NSJSONSerialization dataWithJSONObject:dic?:@{} options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
#endif
