//
//  DXVipServiceNetWork.h
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/20.
//  Copyright © 2019 都学网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>

#define NETLog [DXVipServiceNetWork Log];
#define VSShowMessage(message)  [DXVipServiceNetWork show:message];


NS_ASSUME_NONNULL_BEGIN

typedef void(^success)(NSDictionary *dic,BOOL state);
typedef void(^failure)(NSError *error);

typedef void(^requestLog)(void);
static NSString *_token;
static requestLog _requestLog;
/*简单封装网络请求*/
@interface DXVipServiceNetWork : NSObject


@property (nonatomic, assign) BOOL * cache;
/**get请求*/
+ (NSURLSessionDataTask *)get:(NSString *)url paramaters:(nullable NSDictionary *)params success:(success)success fail:(failure)failure animated:(BOOL)animated;
/**post请求*/
+ (NSURLSessionDataTask *)post:(NSString *)url paramaters:(nullable NSDictionary *)params success:(success)success fail:(failure)failure animated:(BOOL)animated;

+ (void)setToken:(nullable NSString *)token ;
+ (NSString *)getToken ;
+ (void)Log ;
+ (void)show:(NSString *)text ;

@end

NS_ASSUME_NONNULL_END
