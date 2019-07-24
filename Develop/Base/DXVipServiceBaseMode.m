//
//  DXVipServiceBaseMode.m
//  Doxuewang
//
//  Created by doxue_imac on 2019/7/1.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXVipServiceBaseMode.h"
#import <objc/runtime.h>

@implementation DXVipServiceBaseMode
- (instancetype)init
{
    self = [super init];
    if (self) {
#pragma mark - instruments显示会有内存泄漏
//                unsigned int count;
//                objc_property_t *propertyList = class_copyPropertyList([self class], &count);
//                for (unsigned int i=0; i<count; i++) {
//                    NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
//                    if ([self isNSStringProperty:[self class] propertyName:key]) {
//                        if ([self isPropertyReadOnly:[self class] propertyName:key]){
//                            [self setValue:@"" forKey:[NSString stringWithFormat:@"_%@",key]];
//                        }else{
//                            [self setValue:@"" forKey:key];
//                        }
//                    }
//                }
    }
    return self;
}

- (void)customHandler{
    
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@", [self mj_keyValues]];
}

- (NSString *)debugDescription{
    
    return [NSString stringWithFormat:@"<%@：%p，%@>",[self class], self, [self mj_keyValues]];
}

//- (id)parserData:(NSDictionary *)dictData{
//    return nil;
//}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

- (id)parseData:(NSDictionary *)dictData {
    return dictData[@"result"];
}



//- (id)initWithDictionary:(NSDictionary *)dictionary {
//    id selfClass;
//    @try {
//        selfClass = [[self class] mj_objectWithKeyValues:dictionary];
//    } @catch (NSException *exception) {
//        NSLog(@"反序列化错误！ [BaseModel initWithDictionary] line:42");
//    }//    NSAssert(selfClass, @"检查返回数据格式是否正确");
//    return selfClass;
//}

- (NSDictionary *)parameters {
    NSDictionary *mutDict = [self mj_keyValues];
    return mutDict;
}

- (void)encodeWithCoder:(NSCoder*)encoder {
    //    [encoder encodeObject:self.objectId forKey:idPropertyNameOnObject];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
        [encoder encodeObject:[self valueForKey:key] forKey:key];
    }
    
    Class superClass = [[[[self class] alloc] superclass] class];
    do {
        if (superClass){
            propertyList = class_copyPropertyList(superClass, &count);
            for (unsigned int i=0; i<count; i++) {
                NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
                //                if ([key isEqualToString:@"objectId"]){
                //                    continue ;
                //                }
                [encoder encodeObject:[self valueForKey:key] forKey:key];
            }
        }
        superClass = [[[superClass alloc] superclass] class];
    } while (superClass && superClass != [NSObject class]);
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        //        [self setValue:[decoder decodeObjectForKey:idPropertyNameOnObject] forKey:idPropertyNameOnObject];
        unsigned int count;
        objc_property_t *propertyList = class_copyPropertyList([self class], &count);
        for (unsigned int i=0; i<count; i++) {
            NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
            if ([self isPropertyReadOnly:[self class] propertyName:key]) {
                continue;
            }
            id value = [decoder decodeObjectForKey:key];
            if (value != [NSNull null] && value != nil) {
                [self setValue:value forKey:key];
            }
        }
        Class superClass = [[[[self class] alloc] superclass] class];
        do {
            if (superClass){
                propertyList = class_copyPropertyList(superClass, &count);
                for (unsigned int i=0; i<count; i++) {
                    NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
                    //                    if ([key isEqualToString:@"objectId"]){
                    //                        continue ;
                    //                    }
                    if ([superClass isPropertyReadOnly:[self class] propertyName:key]) {
                        continue;
                    }
                    id value = [decoder decodeObjectForKey:key];
                    if (value != [NSNull null] && value != nil) {
                        [self setValue:value forKey:key];
                    }
                }
            }
            superClass = [[[superClass alloc] superclass] class];
        } while (superClass && superClass != [NSObject class]);
        
    }
    return self;
}

/**
 *  解析字典
 */
+ (id)objectFromDictionary:(NSDictionary*)dictionary {
    return [[self class] mj_objectWithKeyValues:dictionary];
    
}

- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key {
     NSLog(@"Class: %@    UndefinedKey: %@", [self class], key );
}

- (id)copyWithZone:(NSZone *)zone{
    id newModel = [[[self class] allocWithZone:zone]init];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
        if ([self isPropertyReadOnly:[self class] propertyName:key]) {
            continue;
        }
        id value = [self valueForKey:key];
        if (value != [NSNull null] && value != nil) {
            [newModel setValue:value forKey:key];
        }
    }
    Class superClass = [[[[self class] alloc] superclass] class];
    do {
        if (superClass){
            propertyList = class_copyPropertyList(superClass, &count);
            for (unsigned int i=0; i<count; i++) {
                NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
                if ([superClass isPropertyReadOnly:[self class] propertyName:key]) {
                    continue;
                }
                id value = [self valueForKey:key];
                if (value != [NSNull null] && value != nil) {
                    [newModel setValue:value forKey:key];
                }
            }
        }
        superClass = [[[superClass alloc] superclass] class];
    } while (superClass && superClass != [NSObject class]);
    
    return newModel;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    id newModel = [[[self class] allocWithZone:zone]init];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
        if ([self isPropertyReadOnly:[self class] propertyName:key]) {
            continue;
        }
        id value = [self valueForKey:key];
        if (value != [NSNull null] && value != nil) {
            if ([value respondsToSelector:@selector(mutableCopyWithZone:)]){
                [newModel setValue:[value mutableCopyWithZone:zone] forKey:key];
            }else{
                [newModel setValue:value forKey:key];
            }
        }
    }
    
    Class superClass = [[[[self class] alloc] superclass] class];
    do {
        if (superClass){
            propertyList = class_copyPropertyList(superClass, &count);
            for (unsigned int i=0; i<count; i++) {
                NSString *key = [NSString stringWithUTF8String:property_getName(propertyList[i])];
                if ([superClass isPropertyReadOnly:[self class] propertyName:key]) {
                    continue;
                }
                id value = [self valueForKey:key];
                if (value != [NSNull null] && value != nil) {
                    if ([value respondsToSelector:@selector(mutableCopyWithZone:)]){
                        [newModel setValue:[value mutableCopyWithZone:zone] forKey:key];
                    }else{
                        [newModel setValue:value forKey:key];
                    }
                }
            }
        }
        superClass = [[[superClass alloc] superclass] class];
    } while (superClass && superClass != [NSObject class]);
    
    return newModel;
}



- (BOOL)isNSStringProperty:(Class)klass propertyName:(NSString*)propertyName{
    const char * type = property_getAttributes(class_getProperty(klass, [propertyName UTF8String]));
    NSString * typeString = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:0];
    return [typeAttribute rangeOfString:@"T@\"NSString\""].length > 0;
}

- (BOOL)isPropertyReadOnly:(Class)klass propertyName:(NSString*)propertyName{
    const char * type = property_getAttributes(class_getProperty(klass, [propertyName UTF8String]));
    NSString * typeString = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:1];
    return [typeAttribute rangeOfString:@"R"].length > 0;
}

@end
