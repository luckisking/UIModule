//
//  DownloadCell.m
//  Doxue
//
//  Created by MBAChina-IOS on 15/7/24.
//  Copyright (c) 2015年 MBAChina. All rights reserved.
//
#import "DXLivePlaybackModel.h"
#import "DXLivePlaybackFMDBManager.h"
#import "DownloadCell.h"
#import "DXDownloadItem.h"

@interface DownloadCell ()

@end

@implementation DownloadCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.lastTime  = 0.0f;
        self.writeSize = 0.0f;
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(11, 16, IPHONE_WIDTH-22, 20)];
        _nameLabel.font = FMainFont;
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.text = @"管理类联考数学基础课程 - 1.11 百分数";
        [self.contentView addSubview:_nameLabel];
        
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(11, CGRectGetMaxY(_nameLabel.frame)+10, IPHONE_WIDTH-22, 2);
        [_progressView setProgressTintColor: [UIColor colorWithRed:28/255.0 green:184/255.0 blue:119/255.0 alpha:1/1.0]];
        [_progressView setTrackTintColor:[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1/1.0]];
        [self.contentView addSubview:_progressView];
        
        _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(11, CGRectGetMaxY(_progressView.frame)+10, 60, 16)];
        _stateLabel.font = [UIFont systemFontOfSize:11.0];
        _stateLabel.textAlignment = NSTextAlignmentLeft;
        _stateLabel.textColor = CFontColorMore;
        [self.contentView addSubview:_stateLabel];
        
        _sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_stateLabel.frame), CGRectGetMaxY(_progressView.frame)+10, IPHONE_WIDTH-22-60, 16)];
        _sizeLabel.font = [UIFont systemFontOfSize:13.0];
        _sizeLabel.textAlignment = NSTextAlignmentRight;
        _sizeLabel.textColor = CFontColorMore;
        [self.contentView addSubview:_sizeLabel];
        
        
        self.remainingTime = [[UILabel alloc] initWithFrame:CGRectZero];
        self.remainingTime.font = FFont1;
        self.remainingTime.textAlignment = NSTextAlignmentRight;
        self.remainingTime.textColor = CFontColorMore;
        [self.contentView addSubview:self.remainingTime];
        [self.remainingTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.width.equalTo(@(200));
            make.height.equalTo(@(22));
        }];
        
    }
    return self;
}

-(void)setItem:(DXDownloadItem *)item{
    _item = item;
    self.nameLabel.text = item.video_title;
    self.progressView.progress = item.progress;
    if (item.videoDownloadedSize)
    {
        float hadDown    = item.videoDownloadedSize/1024.0/1024.0;
        float expectDown = item.videoFileSize/1024.0/1024.0;
        self.sizeLabel.text = [NSString stringWithFormat:@"%.2f/%.2f",hadDown,expectDown];
    }
    else
    {
        self.sizeLabel.text = @"0.00MB/0.00MB";
    }
    
    /*  cell 按钮图片显示判断  */
    if(item.videoDownloadStatus == DXDownloadStatusDownloading)
    {
        self.stateLabel.text = @"正在下载";
    }
    else
    {
        if (item.videoDownloadStatus == DXDownloadStatusPause)
        {
           self.stateLabel.text = @"已暂停";
        }
        else
        {
            self.stateLabel.text = @"等待中...";
        }
    }
    
}

-(void)setLivebackItem:(downItem *)livebackItem
{
    _livebackItem = livebackItem;
    DXLivePlaybackModel *livePlaybackModel = [[DXLivePlaybackFMDBManager shareManager] selectCurrentModelWithStrDownloadID:livebackItem.strDownloadID];
    self.nameLabel.text = livePlaybackModel.SecondaryTitle;

    //获取下载大小,和文件大小
    WS(weakSelf)
    [livebackItem requestMoreInfo:^(BOOL isSuccess, NSString *fileSize, NSString *startTime, NSString *endTime) {
        if (![fileSize IsEmptyStr]) {
            weakSelf.progressView.progress = livebackItem.percent/100.0;
            weakSelf.sizeLabel.text =  [NSString stringWithFormat:@"0.00MB/%.2fMB",livebackItem.fileSize.doubleValue/1024/1024];
            weakSelf.fileSize = fileSize;
        }
    }];
//    //item的信息除了id之外，全是错的？gensee sdk这么草率？
//    switch (livebackItem.state) {
//        case 0://REDAY,
//            self.stateLabel.text = @"等待中...";
//            break;
//
//        case 1://BEGIN,
//            self.stateLabel.text = @"正在下载";
//            break;
//
//        case 2://PAUSE,
//            self.stateLabel.text =@"已暂停";
//            break;
//
//        case 3://FINISH,
//            self.stateLabel.text = @"已完成";
//            break;
//
//        case 4://FAILED,
//            self.stateLabel.text = @"下载失败";
//            break;
//
//        default:
//            break;
//    }
    
    //由于 不知为何 ，livebackItem.state的数据只会返回1，没有任何其他的状态
    switch ([GSVodManager sharedInstance].state) {
        case GSVodDownloadStatePause:
            self.stateLabel.text =@"已暂停";
            self.remainingTime.text = @"";
            break;
        default:
             self.stateLabel.text = @"等待中...";
             self.remainingTime.text = @"";
            break;
    }
    
    
}

//-(void)stateButtonAction:(UIButton*)sender{
//    if(self.actionBlock){
//        self.actionBlock(self,self.item.videoDownloadStatus);
//    }
//}

//-(void)startBtnClicked:(id)sender
//{
//    if (self.indexBlock) {
//        self.indexBlock(self.indexPath);
//    }
//}

@end
