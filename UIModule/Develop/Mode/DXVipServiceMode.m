//
//  DXVipServiceMode.m
//  Doxuewang
//
//  Created by doxue_imac on 2019/7/1.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXVipServiceMode.h"

@implementation DXVipServiceMode
/* 转化过程中对字典的值进行过滤和进一步转化 */
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"publisher"]) {
        if (oldValue == nil) {
            return @"";
        }
    } else if (property.type.typeClass == [NSDate class]) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt dateFromString:oldValue];
    }
    return oldValue;
}
@end

@implementation DXVipServiceDateMode
@end

@implementation DXVipServiceStudyMode
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"stage":@"event.stage",
             @"date":@"event.date",
             @"theDay":@"event.the_day",
             @"eventDesc":@"event.event_desc",
             @"prevDayState":@"prev_day_state",
             @"startTime":@"event.start_time",
             @"endTime":@"event.end_time"
             };
}
+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"video": [DXVipServiceVideoMode class],
             @"paper": [DXVipServicePaperMode class],
             };
    
}
@end
@implementation DXVipServicePaperMode
//+ (id)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
//    return [propertyName mj_camelFromUnderline];  //下划线转驼峰
//}
@end
@implementation DXVipServiceVideoMode
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"courseId":@"id",
             };
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"jie": [DXVipServiceJieMode class],
             };
    
}
@end
@implementation DXVipServiceJieMode
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"jieId":@"id",
             };
}
@end

