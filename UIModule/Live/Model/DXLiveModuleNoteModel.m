//
//  DXNoteModel.m
//  Doxuewang
//
//  Created by MBAChina-IOS on 16/6/20.
//  Copyright © 2016年 都学网. All rights reserved.
//

#import "DXLiveModuleNoteModel.h"

@implementation DXLiveModuleNoteModel


- (void)setValue:(id)value forKey:(NSString *)key{
    //先设置"键值"
    [super setValue:value forKey:key];
    
    //在调整"键值"
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"noteID"];
        return;
    }
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


@end

@implementation DXLiveModuleNoteUserModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
