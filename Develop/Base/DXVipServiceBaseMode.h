//
//  DXVipServiceBaseMode.h
//  Doxuewang
//
//  Created by doxue_imac on 2019/7/1.
//  Copyright © 2019 都学网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

@interface DXVipServiceBaseMode : NSObject<NSCoding, NSCopying, NSMutableCopying>

/**
 *  解析字典
 */
+ (id)objectFromDictionary:(NSDictionary*)dictionary;
//- (id)initWithDictionary:(NSDictionary *)dictionary;

-(void)setValue:(nullable id)value forUndefinedKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
