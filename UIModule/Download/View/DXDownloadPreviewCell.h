//
//  DXDownloadPreviewCell.h
//  Doxuewang
//
//  Created by 侯跃民 on 2019/4/11.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "SYBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DXDownloadPreviewCell : SYBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;//正在缓存的数量
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//小标题
@property (weak, nonatomic) IBOutlet UIProgressView *progress;//下载进度

@property (weak, nonatomic) IBOutlet UILabel *downloadspeedLabel;//下载速度

@end

NS_ASSUME_NONNULL_END
