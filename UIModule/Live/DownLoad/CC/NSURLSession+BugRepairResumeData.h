//
//  NSURLSession+CCCorrectedResumeData.h
//  Demo
//
//  Created by luyang on 2017/4/18.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSession (BugRepairResumeData)
//解决ios10 10.1断点续传bug 就这一个作用
- (NSURLSessionDownloadTask *)downloadTask_ios10_1_WithResumeData:(NSData *)resumeData;

@end
