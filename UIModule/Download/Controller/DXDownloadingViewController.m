//
//  DXDownloadingController.m
//  Doxuewang
//
//  Created by 侯跃民 on 2019/4/10.
//  Copyright © 2019 都学网. All rights reserved.
//
#define NavAndStatus  0.0f

#import "DXLivePlaybackModel.h"
#import "DXLivePlaybackFMDBManager.h"
#import "DXLivePlaybackFMDBManager.h"
#import "AppDelegate.h"

#import "DownloadCell.h"
#import "DXHadDownCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import <sys/sysctl.h>
#import <mach/mach.h>

#import "DownCourseModel.h"
#import "DXHadDownloadTableTableViewController.h"
#import "DXDownloadManager.h"
#import "UIViewController+HUD.h"
#import "DXDownloadingViewController.h"
#import "CCSDK/OfflinePlayBack.h"//离线下载

@interface DXDownloadingViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,GSVodManagerDelegate,CCDownloadSessionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *headerView;

@property (nonatomic, strong) DownCourseModel * selectDownCourse;

@property (nonatomic, strong) NSMutableArray *DXDownLoadItem;

@property (nonatomic, strong)NSMutableArray *selectorPatnArray;//多选array
@property(nonatomic, strong)  UIButton * editBtn;
@property(nonatomic, strong)  UIView *bottomView;//全删或删除选中view
@property(nonatomic, assign) NSInteger downloadingNumber;//正在下载视频及直播回放的总数
@property(nonatomic, assign) CGFloat lastSize;//上一次的大小
@property(nonatomic, assign)  double lastTime;//上一次时间
@property(nonatomic, assign)  float percent;//上一次的进度

//直播回放正在下载的数组
@property (nonatomic, strong) NSArray *genseeloadingArray;
@property (nonatomic, strong) NSArray *ccloadingArray;


@end

@implementation DXDownloadingViewController


- (NSMutableArray *)DXDownLoadItem {
    if (_DXDownLoadItem) {
        return _DXDownLoadItem;}
    _DXDownLoadItem = [NSMutableArray arrayWithCapacity:0];
    return _DXDownLoadItem;
}


-(UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.frame = CGRectMake(0, KScreenWidth-20, 30, 30);
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:dominant_BlockColor forState:UIControlStateNormal];
        [_editBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [_editBtn setSelected:NO];
        [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (UIView *)headerView {
    if (_headerView) {
        return _headerView;
    }
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    _headerView.backgroundColor = KWhiteColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.headerView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 30));
        make.left.mas_equalTo(8);
        make.centerY.equalTo(self.headerView.mas_centerY);
    }];
    [button.titleLabel setFont:FMainFont];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [button setTitle:@"全部开始" forState:UIControlStateNormal];
    [button setTitle:@"全部暂停" forState:UIControlStateSelected];
    [button addTarget:self action:@selector(tapStartAll:) forControlEvents:UIControlEventTouchUpInside];
    
    /*
     设置是否是下载状态（在app的delegate中会自动选择是否开启下载的），这里只需要设置状态
     1，在wifi下，如果用户打开了允许自动下载
     1，在3G.4G下，如果用户打开了允许自动下载
     */
    if ([[DXDownloadManager sharedInstance] isDownloading]) {
        //视频
        button.selected = YES;//下载状态
    }else {
        //gensee回放
        if ([GSVodManager sharedInstance].state == GSVodDownloadStateDownloading) {
              button.selected = YES;//下载状态
        }
        //cc
        for (CCDownloadModel *model in [[CCDownloadSessionManager manager] queryAllDownloaded:NO]) {
            if (model.state==CCPBDownloadStateRunning) {
                button.selected = YES;//下载状态
                break;
            }
        }
    }
    return _headerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"正在下载";
    
    self.tableView.editing = NO;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [[UIView alloc]init];

    [self setNavRightBtn];//多选删除按钮
    [self setDeletedBtn];//设置全删或删除

    [self addObserverForDownloadManager];
//    [self loadDownloadItems];
    

   // 创建下来刷新，并更新
    //视频
//    [[DXDownloadManager sharedInstance] sortVideoByCourse];
    
    //gensee
    _genseeloadingArray = [[VodManage shareManage] getListOfUnDownloadedItem];
    //cc
     _ccloadingArray = [[CCDownloadSessionManager manager] queryAllDownloaded:NO];
    //gensee
       [GSVodManager sharedInstance].delegate = self;
    //cc
      [CCDownloadSessionManager manager].delegate = self;//下载代理
    
    //测试gense下载（本步骤在appdelegate中实现）
        //创建gensee回放下载队列
        for (downItem *item in _genseeloadingArray) {
            [ [GSVodManager sharedInstance] insertQueue:item atIndex:-1];
        }
        if (kNetworkWIFIReachability) {
            //wifi状态自动开始下载
            [ [GSVodManager sharedInstance] startQueue];//开始队列下载
        }
    //测试cc下载（本步骤在appdelegate中实现）
    for (CCDownloadModel *model in _ccloadingArray) {
        [[CCDownloadSessionManager manager] resumeWithDownloadModel:model];
    }
    
    [self.tableView reloadData];
}

//设置多选按钮
-(void)setNavRightBtn
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.editBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}


-(void)setDeletedBtn
{
    UIView *bottomView = [[UIView alloc]init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(48);
    }];
    bottomView.layer.borderWidth = 0.5;
    bottomView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bottomView.hidden = YES;
    _bottomView = bottomView;
    
    UIButton *selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectAll setTitle:@"全删" forState:UIControlStateNormal];
    [selectAll setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:selectAll];
    [selectAll addTarget:self action:@selector(selectAllClick) forControlEvents:UIControlEventTouchUpInside];
    [selectAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0.0f);
        make.left.offset(0.0f);
        make.width.offset(KScreenWidth*0.5);
        make.bottom.offset(0.0f);
    }];
    
    UIButton *DeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [DeleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [DeleteBtn setTitleColor: [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    DeleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];;
    [bottomView addSubview:DeleteBtn];
    [DeleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [DeleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0.0f);
        make.right.offset(0.0f);
        make.width.offset(KScreenWidth*0.5);
        make.bottom.offset(0.0f);
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  为下载管理器增加监控。通过观察器可以处理与下载管理器之间的交互消息
 */
- (void)addObserverForDownloadManager{

    /* 开始下载 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadManagerItemDidStart:) name:@"DXDownloadManger.downloadItemDidStart" object:nil];

    /* 正在下载 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadManagerDownloading:) name:@"DXDownloadManger.downloading" object:nil];

    /* 停止下载 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadManagerItemDidStop:) name:@"DXDownloadManger.downloadItemDidStop" object:nil];

    /* 网络状态变化 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadManagerNetworkStatusChanged:) name:@"DXDownloadManger.NetworkStatus" object:nil];

    /* 完成下载 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadManagerDownloadFinished:) name:@"DXDownloadManger.downloadFinished" object:nil];

    /* 下载成功 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadManagerDownloadSuccess:) name:@"DXDownloadManger.downloadSuccess" object:nil];
}

#pragma mark - 数据源

///**
// *  加载下载条目。包括正在下载条目以及下载完毕条目，加载完毕刷新table显示。
// */
//- (void)loadDownloadItems{
//    /* 初始化已下载数据 */
//    [[DXDownloadManager sharedInstance] sortVideoByCourse];
//
//    [self.tableView reloadData];
//
//}

#pragma mark - UITableView delegate & datasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DXDownloadManager sharedInstance].dataSource_queue.count+_genseeloadingArray.count+_ccloadingArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 83.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 正在下载队列
    static NSString *cellCode = @"DownloadCell";
    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellCode];
    if (cell == nil) {
        cell = [[DownloadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellCode];
    }

    //cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    // 视频正在下载
    if (indexPath.row < [DXDownloadManager sharedInstance].dataSource_queue.count) {
        DXDownloadItem * item = [[DXDownloadManager sharedInstance] downloadingItemAtIndex:indexPath.row];
        if (item) {
            
            cell.item = item;
            cell.progressView.progress = item.progress;

            /*  cell 按钮点击动作判断  */
            //        cell.indexBlock = ^(NSIndexPath *indexPath){
            //
            //            if (item.videoDownloadStatus != DXDownloadStatusDownloading)
            //            {
            //                /* 是否允许3G/4G网络下载 */
            //                BOOL allowCellular = [DXDefault boolForKey:AllowDownloadVideoByCellular];
            //
            //                if (allowCellular)
            //                {
            //                    [[DXDownloadManager sharedInstance] stopDownloadAll];
            //                    [[DXDownloadManager sharedInstance] continueDownLoad:item];
            //                }
            //                else
            //                {
            //                    if (kNetworkWIFIReachability)
            //                    {
            //                        if (item.videoDownloadStatus == DXDownloadStatusDownloading)
            //                        {
            //                            [[DXDownloadManager sharedInstance] stopDownloadAll];
            //                        }
            //                        else
            //                        {
            //                            [[DXDownloadManager sharedInstance] stopDownloadAll];
            //                            [[DXDownloadManager sharedInstance] continueDownLoad:item];
            //                        }
            //                    }
            //                    else
            //                    {
            //                        [self showHint:@"非Wifi环境,无法下载"];
            //                    }
            //                }
            //            }
            //            else if (item.videoDownloadStatus == DXDownloadStatusDownloading)
            //            {
            //                [[DXDownloadManager sharedInstance] stopDownloadAll];
            //            }
            //        };
        }
        if (NO == [[DXDownloadManager sharedInstance] isDownloading]) {
            cell.stateLabel.text = @"已暂停";
        }
    }else{
        //直播回放正在下载
        if (indexPath.row < ([DXDownloadManager sharedInstance].dataSource_queue.count+_genseeloadingArray.count)) {
            //gensee
            downItem *livebackitem = _genseeloadingArray[indexPath.row - [DXDownloadManager sharedInstance].dataSource_queue.count];
            if (livebackitem) {
                cell.livebackItem = livebackitem;
                if (indexPath.row ==[DXDownloadManager sharedInstance].dataSource_queue.count&&[GSVodManager sharedInstance].state==GSVodDownloadStateDownloading) {
                    cell.stateLabel.text = @"正在下载";
                }
            }
        }else {
            //cc
            CCDownloadModel *model = _ccloadingArray[indexPath.row - [DXDownloadManager sharedInstance].dataSource_queue.count-_genseeloadingArray.count];
            if (model) {
                cell.nameLabel.text = model.secondaryTitle;
                if (model.state == 0) {//CCDownloadStateNone,未下载 或 下载删除了
                     cell.stateLabel.text = @"未下载";
                    //        [[CCDownloadSessionManager manager] resumeWithDownloadModel:model];
                } else if (model.state == 1) {//CCDownloadStateReadying,等待下载
                     cell.stateLabel.text = @"等待中...";
                } else if (model.state == 2) {//CCDownloadStateRunning,正在下载
                    //        [[CCDownloadSessionManager manager] resumeWithDownloadModel:model];
                    cell.stateLabel.text = @"正在下载";
                    cell.remainingTime.text = [NSString stringWithFormat:@"(%.2f %@/sec)", [self calculateFileSizeInUnit:model.progress.speed],[self calculateUnit:model.progress.speed]];
                } else if (model.state == 3) {//CCDownloadStateSuspended,下载暂停
                     cell.stateLabel.text = @"已暂停";
                } else if (model.state == 4) {//CCDownloadStateCompleted,下载完成
                    if (model.decompressionState == 2) {
                          cell.stateLabel.text = @"解压完成\t可播放";
                    } else {
                        if (model.decompressionState == 1) {
                              cell.stateLabel.text = @"下载完成,解压中";
                        }else if (model.decompressionState == 0) {
                              cell.stateLabel.text = @"已下载，未解压";
                        }else{
                              cell.stateLabel.text = @"解压失败";
                        }
                        
                    }
                    cell.progressView.progress = 0;
                    cell.sizeLabel.text = [NSString stringWithFormat:@"%.2f MB/%.2f MB", model.progress.totalBytesWritten/1024.0/1024.0,model.progress.totalBytesExpectedToWrite/1024.0/1024.0];
                    
                } else if (model.state == 5) {//CCDownloadStateFailed,下载失败
                        cell.stateLabel.text = @"下载失败，请重新下载";
                }

            }
            
        }
 
        
    }
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;//多选状态
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableView){
        return @"移除";

    }
    return @"";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
//        if (editingStyle == UITableViewCellEditingStyleDelete) {
//            if ([DXDownloadManager sharedInstance].isDownloading == YES) {
//                [self showHint:@"请先暂停下载"];
//            }
//            else
//            {
//                [[DXDownloadManager sharedInstance].dataSource_queue removeObjectAtIndex:indexPath.row];
//                [DXDownloadManager sharedInstance].downloadingItems.items = [DXDownloadManager sharedInstance].dataSource_queue;
//                [[DXDownloadManager sharedInstance].downloadingItems writeToPlistFile:DXDownloadingItemPlistFilename];
//                NSLog(@"🌺😆1111___%lu",(unsigned long)[DXDownloadManager sharedInstance].dataSource_queue.count);
//                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//
//                //                [self.tableView reloadData];
//            }
//        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     if (self.editBtn.isSelected) {//多选状态下
         if (indexPath.row < [DXDownloadManager sharedInstance].dataSource_queue.count) {//视频
             [self.selectorPatnArray addObject:[DXDownloadManager sharedInstance].dataSource_queue[indexPath.row]];
             
         }else{//直播回放
             //gensee
             if (indexPath.row < ([DXDownloadManager sharedInstance].dataSource_queue.count+_genseeloadingArray.count)) {
                 downItem *livebackitem = _genseeloadingArray[indexPath.row - [DXDownloadManager sharedInstance].dataSource_queue.count];
                 [self.selectorPatnArray addObject: livebackitem];
             }else {
                 //cc
                 CCDownloadModel *model = _ccloadingArray[indexPath.row - [DXDownloadManager sharedInstance].dataSource_queue.count-_genseeloadingArray.count];
                 [self.selectorPatnArray addObject: model];
             }
            
         }
     }else{
         
     }
     
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //从选中中取消
    if (self.selectorPatnArray.count > 0) {//多选状态下
        if (indexPath.row < [DXDownloadManager sharedInstance].dataSource_queue.count) {//视频
            [self.selectorPatnArray removeObject:[DXDownloadManager sharedInstance].dataSource_queue[indexPath.row]];
            
        }else{//直播回放
            //gensee
            if (indexPath.row < ([DXDownloadManager sharedInstance].dataSource_queue.count+_genseeloadingArray.count)) {
                downItem *livebackitem = _genseeloadingArray[indexPath.row - [DXDownloadManager sharedInstance].dataSource_queue.count];
                [self.selectorPatnArray removeObject: livebackitem];
            }else {
                //cc
                CCDownloadModel *model = _ccloadingArray[indexPath.row - [DXDownloadManager sharedInstance].dataSource_queue.count-_genseeloadingArray.count];
                [self.selectorPatnArray removeObject: model];
            }
          
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 44.0;
    }
    
    return 28.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.headerView;
    }
    
    return nil;
}

#pragma mark -  开始 停止下载

- (void)tapStartAll:(id)sender {
    UIButton *button = sender;
    if (kNetworkNotReachability) {
        [self showHint:@"无网络连接"];
        return;
    }
    button.selected = !button.selected;
    if ( button.selected) {
        if (kNetworkWWANReachability) {
            [self showHint:@"将使用4g开始下载"];
        }
        //全部开始（与显示文字正好相反）
        //视频
        [[DXDownloadManager sharedInstance] startDownloadAll];
        //gensee
        if (![[GSVodManager sharedInstance] downloadQueue].count) {
            for (downItem *item in _genseeloadingArray) {
                [ [GSVodManager sharedInstance] insertQueue:item atIndex:-1];
            }
        }
        [[GSVodManager sharedInstance] startQueue];
        //cc
        for (CCDownloadModel *model in [[CCDownloadSessionManager manager] queryAllDownloaded:NO]) {
             [[CCDownloadSessionManager manager] resumeWithDownloadModel:model];
        }
        
    }else {
        //全部暂停
        [[DXDownloadManager sharedInstance] stopDownloadAll];
        [[GSVodManager sharedInstance] pauseQueue];
        for (CCDownloadModel *model in [[CCDownloadSessionManager manager] queryAllDownloaded:NO]) {
            [[CCDownloadSessionManager manager] suspendWithDownloadModel:model];
        }
    }
    [self.tableView reloadData];
}

- (void)presentNotification
{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"所有下载已完成!";
    //提示音
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"downloadViewToHadDownlist"]){
        DXHadDownloadTableTableViewController * vc = [segue destinationViewController];
        vc.course = _selectDownCourse;
    }
}

- (double)availableMemory {

    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

#pragma mark - 设置容量大小
-(NSNumber *)totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}
#pragma mark - 可用容量大小
-(NSNumber *)freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}
#pragma mark - 单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - 处理下载通知消息

/**
 *  下载已经开始
 */
- (void)downloadManagerItemDidStart:(NSNotification *)notification{
    
    NSLog(@"downloadManagerItemDidStart");

    NSDictionary *userInfo = notification.userInfo;
    NSInteger index = [((NSNumber *)userInfo[@"index"]) integerValue];

    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    DownloadCell *cell = (DownloadCell*)[self.tableView cellForRowAtIndexPath:indexPath];

    NSInteger status = [userInfo[@"status"] integerValue];

    dispatch_async(dispatch_get_main_queue(), ^{

        if (cell) {
            if (status == 0) {

                DXDownloadItem *item = [[DXDownloadManager sharedInstance]downloadingItemAtIndex:index];
                item.stateString = @"等待中";
                item.videoDownloadStatus = DXDownloadStatusDownloading;

                [cell.stateLabel setText:@"等待中"];
            }
        }
    });
}

/**
 收到停止下载的消息

 @param notification 通知消息对象
 */
- (void)downloadManagerItemDidStop:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSInteger index = [((NSNumber *)userInfo[@"index"]) integerValue];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    DownloadCell *cell = (DownloadCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    NSInteger status = [userInfo[@"status"] integerValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (status == -1 || 2 == status) {
            
            DXDownloadItem *item = [[DXDownloadManager sharedInstance]downloadingItemAtIndex:index];
            if (item) {
                item.stateString = @"已暂停";
                item.videoDownloadStatus = DXDownloadStatusPause;
            }
            
            if (cell) {
                cell.stateLabel.text = @"已暂停";
                cell.remainingTime.text = @"";
                cell.sizeLabel.text = @"";
            }
        }
    });
}

- (void)downloadManagerNetworkStatusChanged:(NSNotification *)notification
{
    NSLog(@"downloadManagerNetworkStatusChanged");

    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *userInfo = notification.userInfo;
        [self showHint:userInfo[@"text"]];
    });
}

- (void)downloadManagerDownloadFinished:(NSNotification *)notification
{
    NSLog(@"downloadManagerDownloadFinished");

    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentNotification];
    });
}

- (void)downloadManagerDownloadSuccess:(NSNotification *)notification
{
    
    NSLog(@"downloadManagerDownloadSuccess");

    DXWeak(self, weakSelf);

    dispatch_async(dispatch_get_main_queue(), ^{

        /* 更新正在下载列表 */
        [weakSelf.tableView reloadData];

        /*  开启"全部下载",但是暂停部分任务, 修正顶部downButton显示逻辑   */
        NSArray *isDown = [[DXDownloadManager sharedInstance].downloadingItems.items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.videoDownloadStatus = 1"]];

        if (isDown.count == 0)
        {
            
        }
    });
}
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)downloadManagerDownloading:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSInteger totalBytesExpectedToWrite = [(NSNumber *)userInfo[@"totalBytesExpectedToWrite"] floatValue];

    if([[self freeDiskSpace]longLongValue] <= (long long)totalBytesExpectedToWrite){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"警告" message:@"设备可用容量不足,建议清除手机内存后重试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];

        });
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{

        NSInteger index = [((NSNumber *)userInfo[@"index"]) integerValue];
        float totalBytesWritten = [(NSNumber *)userInfo[@"totalBytesWritten"] floatValue];
        float totalBytesExpectedToWrite = [(NSNumber *)userInfo[@"totalBytesExpectedToWrite"] floatValue];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        DownloadCell * cell = (DownloadCell*)[self.tableView cellForRowAtIndexPath:indexPath];

        if(cell){

            float progress = [(NSNumber *)userInfo[@"progress"] floatValue];
            cell.progressView.progress = progress;

            cell.remainingTime.text = [NSString stringWithFormat:@"(%.2f %@/sec)  剩余：%ld秒", [(NSNumber *)userInfo[@"speed"] floatValue], userInfo[@"speedUnit"], (long)[(NSNumber *)userInfo[@"remainingTime"] integerValue]];
            cell.sizeLabel.text = [NSString stringWithFormat:@"%.2f %@/%.2f %@", totalBytesWritten, userInfo[@"fileSizeWrittenUnit"], totalBytesExpectedToWrite, userInfo[@"fileSizeUnit"]];

            [cell.stateLabel setText:@"正在下载"];

            NSString * bfb = [NSString stringWithFormat:@"%d%%",(int)ceil(progress*100)];

            DXDownloadItem *item = [[DXDownloadManager sharedInstance]downloadingItemAtIndex:index];
            item.progress = progress;
            item.videoDownloadStatus   = DXDownloadStatusDownloading;
            item.stateString           = bfb;
        }
    });
}


#pragma mark - DZNEEmpty.Delegate
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂无正在下载的课程~";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
    
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIColor whiteColor];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
    
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -50.0;}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return 20.0f;
    
}

#pragma mark - 选中array
- (NSMutableArray *)selectorPatnArray{
    if (!_selectorPatnArray) {
        _selectorPatnArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectorPatnArray;
}


//多选删除
-(void)editBtnClick:(UIButton *)sender
{
    [self.view bringSubviewToFront:_bottomView];
    if (sender.isSelected) {//多选状态普通状态
        self.tableView.editing = NO;
        self.bottomView.hidden = YES;
    }else{
        self.tableView.editing = YES;
        self.bottomView.hidden = NO;
    }
    sender.selected = !sender.selected;
    [self.tableView reloadData];
    NSLog(@"多选删除");
}


//全删
-(void)selectAllClick
{
    //直播回放选中正在下载删除
    //gensee
    [[GSVodManager sharedInstance] stopQueue];
    [[GSVodManager sharedInstance] cleanQueue];
    for (downItem *item in [[VodManage shareManage] getListOfUnDownloadedItem]) {
        [[VodManage shareManage] deleteItem:item.strDownloadID];
        [[DXLivePlaybackFMDBManager shareManager] removeStrDownloadID:item.strDownloadID];
    }
    //cc
    for (CCDownloadModel *model in [[CCDownloadSessionManager manager] queryAllDownloaded:NO]) {
         [[CCDownloadSessionManager manager] deleteWithDownloadModel:model];
    }
    
    //视频全部删除
    //下载中删除
    NSMutableArray *videoDownloadingArray  = [[DXDownloadManager sharedInstance] dataSource_queue].mutableCopy;
    NSLog(@"%@",videoDownloadingArray);
    for (DXDownloadItem *item in videoDownloadingArray)
    {
        [[DXDownloadManager sharedInstance].dataSource_queue removeObject:item];
    }
    [[DXDownloadManager sharedInstance].downloadingItems writeToPlistFile:DXDownloadingItemPlistFilename];
    
    self.editBtn.selected = NO;
    [[DXDownloadManager sharedInstance] sortVideoByCourse];//视频重新加载
    self.tableView.editing = NO;
    self.bottomView.hidden = YES;
    _genseeloadingArray = [[VodManage shareManage] getListOfUnDownloadedItem];
    _ccloadingArray = [[CCDownloadSessionManager manager] queryAllDownloaded:NO];
    [self.tableView reloadData];
    NSLog(@"全删");
}

//删除选中
-(void)deleteClick
{
    NSLog(@"删除选中");
    for (NSObject *obj in self.selectorPatnArray) {
        if ([obj isKindOfClass:[downItem class]]) {
            //gensee
            downItem *item = (downItem *)obj;
            [[VodManage shareManage] deleteItem:item.strDownloadID];
            [[DXLivePlaybackFMDBManager shareManager] removeStrDownloadID:item.strDownloadID];
        }else if ([obj isKindOfClass:[DXDownloadItem class]]){
            DXDownloadItem *item = (DXDownloadItem *)obj;
            [[DXDownloadManager sharedInstance].downloadingItems removeObject:item];
            [[DXDownloadManager sharedInstance].downloadingItems writeToPlistFile:DXDownloadingItemPlistFilename];
        }else if ([obj isKindOfClass:[CCDownloadModel class]]){
            //cc
             [[CCDownloadSessionManager manager] deleteWithDownloadModel:(CCDownloadModel *)obj];
        }
        
    }
    
    self.editBtn.selected = NO;
    [[DXDownloadManager sharedInstance] sortVideoByCourse];//视频重新加载
    self.tableView.editing = NO;
    self.bottomView.hidden = YES;
    _genseeloadingArray = [[VodManage shareManage] getListOfUnDownloadedItem];
    _ccloadingArray = [[CCDownloadSessionManager manager] queryAllDownloaded:NO];
    [self.tableView reloadData];

}
//计算文件大小（配合合理单位）
- (float)calculateFileSizeInUnit:(unsigned long long)contentLength
{
    if(contentLength >= pow(1024, 3))
        return (float) (contentLength / (float)pow(1024, 3));
    else if(contentLength >= pow(1024, 2))
        return (float) (contentLength / (float)pow(1024, 2));
    else if(contentLength >= 1024)
        return (float) (contentLength / (float)1024);
    else
        return (float) (contentLength);
}
//计算文件合理单位
- (NSString *)calculateUnit:(unsigned long long)contentLength
{
    if(contentLength >= pow(1024, 3))
        return @"GB";
    else if(contentLength >= pow(1024, 2))
        return @"MB";
    else if(contentLength >= 1024)
        return @"KB";
    else
        return @"Bytes";
}

#pragma mark - GSVodManagerDelegate

//已经请求到点播件数据,并加入队列
- (void)vodManager:(GSVodManager *)manager downloadEnqueueItem:(downItem *)item state:(RESULT_TYPE)type {
}
//开始下载
- (void)vodManager:(GSVodManager *)manager downloadBegin:(downItem *)item {
    NSLog(@"GSVodManager--开始下载");
}
//下载进度
- (void)vodManager:(GSVodManager *)manager downloadProgress:(downItem *)item percent:(float)percent {
    
    NSLog(@"GSVodManager percent ： %f  已经下载=%.1fM/%.1fM",percent,item.downLoadedSize.doubleValue/1024/1024,item.fileSize.doubleValue/1024/1024);
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    for (int i = 0; i<_genseeloadingArray.count; i++) {
        downItem *loadingItem = _genseeloadingArray[i];
        if ([item.strDownloadID isEqualToString:loadingItem.strDownloadID]) {
            indexPath = [NSIndexPath indexPathForRow:[DXDownloadManager sharedInstance].dataSource_queue.count+i inSection:0];
            break;
        }
    }
    /*downItem,除了strDownloadID，几乎所有的其他属性都是无效的。。。。。*/
    DownloadCell * cell = (DownloadCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        if (!cell.fileSize) {
            [item requestMoreInfo:^(BOOL isSuccess, NSString *fileSize, NSString *startTime, NSString *endTime) {
                if (![fileSize IsEmptyStr]) {
                    cell.fileSize = fileSize;
                }
            }];
        }
        cell.progressView.progress = percent/100.0;
        cell.stateLabel.text = @"正在下载";
        cell.sizeLabel.text = [NSString stringWithFormat:@"%.2fMB/%.2fMB",(cell.fileSize.doubleValue *percent/100.0)/1024/1024,cell.fileSize.doubleValue/1024/1024];
        double nowTime = [[NSDate date] timeIntervalSince1970];
        CGFloat changeSize = cell.fileSize.doubleValue*(percent - _percent)/100.0/1024/1024;//MB
        if (changeSize>0.001&&_percent>0.001) {
            BOOL larger = changeSize/(nowTime -self.lastTime)>1;//每秒大于1MB
            CGFloat speed = changeSize/(nowTime -self.lastTime);//下载速度
            cell.remainingTime.text = [NSString stringWithFormat:@"(%.2f %@/sec)  剩余：%d秒",speed*(larger?1:1024),larger?@"MB":@"KB", (int)((100-percent)/100*cell.fileSize.doubleValue/1024/1024/speed)];
          
        }
        //有效计数;
        _lastTime = nowTime;
        _percent = percent;
 
    }
}
//下载暂停
- (void)vodManager:(GSVodManager *)manager downloadPause:(downItem *)item {
    NSLog(@"GSVodManager--下载暂停");
}
//下载停止
- (void)vodManager:(GSVodManager *)manager downloadStop:(downItem *)item {
    NSLog(@"GSVodManager--下载停止");

}
//下载完成
- (void)vodManager:(GSVodManager *)manager downloadFinished:(downItem *)item {
    NSLog(@"GSVodManager--下载完成");
    NSLog(@"%u",item.state);
    NSLog(@"%@",[[VodManage shareManage] searchFinishedItems]);
    //此时并没有把下载完成的对象放入[[VodManage shareManage] searchFinishedItems],延时操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _genseeloadingArray = [[VodManage shareManage] getListOfUnDownloadedItem];
        [self.tableView reloadData];
    });


}
//下载失败
- (void)vodManager:(GSVodManager *)manager downloadError:(downItem *)item state:(GSVodDownloadError)state {
    NSLog(@"GSVodManager--下载失败");

}

#pragma mark - CC回放下载代理
#pragma mark- CCDownloadSessionDelegate

// 更新下载进度
- (void)downloadModel:(CCDownloadModel *)downloadModel didUpdateProgress:(CCDownloadProgress *)progress {
    //进度
    //    NSLog(@"进度是%f,%f,--------%lld %lld",progress.speed,progress.progress,progress.totalBytesWritten,progress.totalBytesExpectedToWrite);
    
    DownloadCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[_ccloadingArray indexOfObject:downloadModel]+[DXDownloadManager sharedInstance].dataSource_queue.count inSection:0]];
    cell.progressView.progress = (float)(downloadModel.progress.totalBytesWritten)/(float)downloadModel.progress.totalBytesExpectedToWrite;
    int sec =  (int)((downloadModel.progress.totalBytesExpectedToWrite-downloadModel.progress.totalBytesWritten)/(float)downloadModel.progress.speed);
    cell.remainingTime.text = [NSString stringWithFormat:@"(%.2f %@/sec)  剩余：%d秒", [self calculateFileSizeInUnit:downloadModel.progress.speed],[self calculateUnit:downloadModel.progress.speed],sec];
    cell.sizeLabel.text = [NSString stringWithFormat:@"%.2f MB/%.2f MB", downloadModel.progress.totalBytesWritten/1024.0/1024.0,downloadModel.progress.totalBytesExpectedToWrite/1024.0/1024.0];
    
}

// 更新下载状态
- (void)downloadModel:(CCDownloadModel *)downloadModel error:(NSError *)error{
    @autoreleasepool {
        DownloadCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[_ccloadingArray indexOfObject:downloadModel]+[DXDownloadManager sharedInstance].dataSource_queue.count+_genseeloadingArray.count inSection:0]];
        if (downloadModel.state == DWDownloadStateFailed) {//下载失败
            cell.stateLabel.text = @"下载失败";
        } else if (downloadModel.state == DWDownloadStateCompleted) {//下载完成
            NSString *str = [downloadModel.filePath substringToIndex:downloadModel.filePath.length - 4];
            dispatch_queue_t t = dispatch_queue_create("HDOfflive", NULL);
            OfflinePlayBack * ccofflinePlayBack =  [[OfflinePlayBack alloc] init];
            dispatch_async(t, ^{
                downloadModel.decompressionState = 1;
                int zipDec = [ccofflinePlayBack DecompressZipWithDec:downloadModel.filePath dir:str];
                NSLog(@"解压码是%d,,,,路径是%@",zipDec,downloadModel.filePath);
                if (zipDec == 0) {
                    [[CCDownloadSessionManager manager] decompressionFinish:downloadModel];
                    NSLog(@"解压完成");
                    
                } else {
                    downloadModel.decompressionState = 3;
                     NSLog(@"解压失败\t请重新下载");
                }
                
            });
            
            //更新
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _ccloadingArray = [[CCDownloadSessionManager manager] queryAllDownloaded:NO];
                [self.tableView reloadData];
            });
            
        }
        
    }
  
    //    [self.tableView reloadData];
    
}



@end
