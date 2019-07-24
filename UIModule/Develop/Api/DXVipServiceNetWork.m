//
//  DXVipServiceNetWork.m
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/20.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXVipServiceNetWork.h"
#import <AFNetworking/AFNetworking.h>
#import <CommonCrypto/CommonDigest.h> 

@implementation DXVipServiceNetWork

+ (NSURLSessionDataTask *)get:(NSString *)url paramaters:(nullable NSDictionary *)params success:(success)success fail:(failure)failure animated:(BOOL)animated {
    if (animated) [self showHUDLoadImage];

    NSDictionary *dic = [self getMD5WithParam:params] ;
    NSURLSessionDataTask *task = [[self manager] GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (animated) [self hideHUDLoadImage];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        BOOL state = [dictionary isKindOfClass:[NSDictionary class]]?([dictionary[@"flag"] intValue]==1):YES;
        
        [self logWithUrl:url params:dic data:responseObject error:nil];
        success(dictionary,state);
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (animated) [self hideHUDLoadImage];
        [self logWithUrl:url params:[self getMD5WithParam:params] data:nil error:error];
        failure(error);
    }];
    return task;
}

+ (NSURLSessionDataTask *)post:(NSString *)url paramaters:(nullable NSDictionary *)params success:(success)success fail:(failure)failure animated:(BOOL)animated {
    if (animated) [self showHUDLoadImage];
    
    NSDictionary *dic = [self getMD5WithParam:params] ;
    NSURLSessionDataTask *task = [[self manager] POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (animated) [self hideHUDLoadImage];
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        BOOL state = [dictionary isKindOfClass:[NSDictionary class]]?([dictionary[@"flag"] intValue]==1):YES;
       
        [self logWithUrl:url params:dic data:responseObject error:nil];
        success(dictionary,state);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       if (animated) [self hideHUDLoadImage];
       [self logWithUrl:url params:[self getMD5WithParam:params] data:nil error:error];
        failure(error);
    }];
    return task;
}

+ (AFHTTPSessionManager *)manager {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    AFSecurityPolicy *AFSecurity = [AFSecurityPolicy defaultPolicy];
     /* 允许无效证书 */
    AFSecurity.allowInvalidCertificates = YES;
    /* 不需要验证域名 */
    AFSecurity.validatesDomainName = NO;
    manager.securityPolicy = AFSecurity;
    if (_token) {
        [manager.requestSerializer setValue:_token forHTTPHeaderField:@"token"];
        [manager.requestSerializer setValue:@"6356F870EE4C1015" forHTTPHeaderField:@"appid"];
    }
    return manager;
    
}
+ (void)setToken:(nullable NSString *)token {
    _token = token;
}
+ (NSString *)getToken {
    return  _token;
}

+ (void)logWithUrl:(NSString *)url params:(nullable NSDictionary *)params data:(NSData *)data error:(nullable NSError *)error {
    _requestLog = ^(){
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params?:@{} options:NSJSONWritingPrettyPrinted error:nil];
        NSString * paramsString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"\nurl:%@\nparams:%@\nresponse:%@\n",url,paramsString,responseString);
        }else{
            NSLog(@"\nurl:%@\nparams:%@\nerrorUserInfo:%@",url,paramsString,error.userInfo[@"NSLocalizedDescription"]);
        }
    };
}


+ (NSDictionary *)getMD5WithParam:(nullable NSDictionary *)param {
    
    NSString *timeString = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSMutableString *paramString  = [NSMutableString stringWithString:@""];
    if (param) {
        NSArray * keyArr =  [[param allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {return [obj1 compare:obj2];}];
        for (int i=0; i<keyArr.count; i++) {
            if (i==0)  [paramString appendString:[NSString stringWithFormat:@"%@=%@",keyArr[i],[param objectForKey:keyArr[i]]]];
            else  [paramString appendString:[NSString stringWithFormat:@"&%@=%@",keyArr[i],[param objectForKey:keyArr[i]]]];
        }
    }
    [paramString appendString:[NSString stringWithFormat:@"%@time=%@&salt=6356F870EE4C1015",param?@"&":@"",timeString]];
    const char* original_str= [paramString UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x", digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    NSMutableDictionary *params = param?[[NSMutableDictionary alloc] initWithDictionary:param]:[NSMutableDictionary dictionary];
    [params setObject:timeString forKey:@"time"];
    [params setObject:[outPutStr lowercaseString] forKey:@"hash"];
    
    return params;
}

+ (void)Log {
    if (_requestLog) {
           _requestLog();
    }
}

+ (void)showHUDLoadImage{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 快速显示一个提示信息
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    });
}
+ (void)hideHUDLoadImage {
     [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
}
#pragma mark 显示成功和失败信息
+ (void)show:(NSString *)text {
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    hud.label.text = [NSString stringWithFormat:@"%@",text];
    // hud.label.font = [UIFont systemFontOfSize:14];
    // 设置图片
    //   NSString *icon = @"";
    //    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 2秒之后再消失
    [hud hideAnimated:YES afterDelay:2];
}
#pragma mark  cache 磁盘缓存


@end
