//
//  DXDownloadManagerMainController.m
//  Doxuewang
//
//  Created by 侯跃民 on 2019/4/9.
//  Copyright © 2019 都学网. All rights reserved.
//
#import "DXDownloadPreviewCell.h"
#import "DXDownloadingViewController.h"


#import "DownloadCell.h"
#import "DXHadDownCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import <sys/sysctl.h>
#import <mach/mach.h>

#import "DownCourseModel.h"
#import "DXHadDownloadTableTableViewController.h"
#import "DXDownloadManager.h"
#import "UIViewController+HUD.h"
#import "DXRefreshControl.h"

#define SegmentHeight 40.0f
#define NavAndStatus  0.0f
#import "DXDownloadManagerMainController.h"
//gensee回放下载
#import "DXLivePlaybackModel.h"
#import "DXLivePlaybackFMDBManager.h"
//cc回放下载
#import "CCDownloadSessionManager.h"

@interface DXDownloadManagerMainController ()<UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate,
DZNEmptyDataSetDelegate,
DZNEmptyDataSetSource,
GSVodManagerDelegate>
@property (strong, nonatomic) DXRefreshControl *refreshControl;
@property (nonatomic, strong) UITableView * tableViewHadDown;   //
@property (nonatomic, strong) UIButton * downButton;
@property (nonatomic, strong) DownCourseModel * selectDownCourse;
@property (nonatomic, strong) NSMutableArray *DXDownLoadItem;
@property (nonatomic, strong)NSMutableArray *selectorPatnArray;//多选array
@property(nonatomic, strong)  UIButton * editBtn;
@property(nonatomic, strong)  UIView *bottomView;//全删或删除选中view
@property(nonatomic, assign) NSInteger downloadingNumber;//正在下载视频及直播回放的总数

//视频下载完成的数组
@property(nonatomic, strong)  NSArray *videoDownDoneArray;
@property (nonatomic, strong)NSMutableArray * genseeLiveBackDownDoneArray;//处理完成之后的直播回放已下载数组
@property (nonatomic, strong)NSMutableArray * ccLiveBackDownDoneArray;//处理完成之后的直播回放已下载数组

@end

@implementation DXDownloadManagerMainController

- (NSMutableArray *)DXDownLoadItem {
    if (_DXDownLoadItem) {
        return _DXDownLoadItem;}
    _DXDownLoadItem = [NSMutableArray arrayWithCapacity:0];
    return _DXDownLoadItem;
}

/**
 *  tableview 完成下载
 *
 *  @return tableview对象
 */
-(UITableView *)tableViewHadDown{
    if (_tableViewHadDown == nil) {
        _tableViewHadDown = [[UITableView alloc]initWithFrame:CGRectMake(0, NavAndStatus, IPHONE_WIDTH, IPHONE_HEIGHT-NavAndStatus) style:UITableViewStylePlain];
        _tableViewHadDown.dataSource = self;
        _tableViewHadDown.delegate = self;
        _tableViewHadDown.emptyDataSetSource = self;
        _tableViewHadDown.emptyDataSetDelegate = self;
        _tableViewHadDown.tableFooterView = [[UIView alloc]init];
        _tableViewHadDown.editing = NO;
        [_tableViewHadDown registerNib:[UINib nibWithNibName:@"DXDownloadPreviewCell" bundle:nil] forCellReuseIdentifier:@"DXDownloadPreviewCell"];
    }
    return _tableViewHadDown;
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
- (NSMutableArray *)selectorPatnArray{
    if (!_selectorPatnArray) {
        _selectorPatnArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectorPatnArray;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self.tableViewHadDown.mj_header beginRefreshing];
    [self.navigationController setNavigationBarHidden:NO];
   
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

//查看下载情况
-(void)checkDownloadStatus{

    //直播回放正在下载的数组
    //gensee
    NSArray *genseeloadingArray = [[VodManage shareManage] getListOfUnDownloadedItem];
    //cc
    NSArray *ccloadingArray = [[CCDownloadSessionManager manager] queryAllDownloaded:NO];
    //视频正在下载的数组
    NSArray *videoDownloadingArray  = [[DXDownloadManager sharedInstance] dataSource_queue];//DXDownloadItem
    // 正在下载的总数量
    _downloadingNumber = genseeloadingArray.count +ccloadingArray.count + videoDownloadingArray.count;

    //直播回放下载完成的数组
    //gensee
    NSArray *genseeloadedArray = [[VodManage shareManage] searchFinishedItems];//downItem
    //cc
     NSArray *ccloadedArray = [[CCDownloadSessionManager manager] queryAllDownloaded:YES];
    //视频下载完成的数组
    _videoDownDoneArray  = [[DXDownloadManager sharedInstance] dataSource_course];//DXDownloadItem

    //把直播回放已下载的重新分组 ,处理直播回放下载数据,把同一直播大课的放在一个数组里
    //gensee
    _genseeLiveBackDownDoneArray = [@[] mutableCopy];
    for (downItem *item in genseeloadedArray) {
        DXLivePlaybackModel *livePlaybackModel = [[DXLivePlaybackFMDBManager shareManager] selectCurrentModelWithStrDownloadID:item.strDownloadID];
        if (livePlaybackModel.courseID) {
            BOOL isExist = NO;
            livePlaybackModel.item = item;
            for (NSMutableArray *array in _genseeLiveBackDownDoneArray) {
                DXLivePlaybackModel *model = [array firstObject];
                if ([livePlaybackModel.courseID isEqualToString:model.courseID]) {
                    [array addObject:livePlaybackModel];
                    isExist = YES;
                    break;
                }
            }
            if (!isExist) {
                [_genseeLiveBackDownDoneArray addObject:[NSMutableArray arrayWithObject:livePlaybackModel]];
            }
        }
    }
    //cc
    _ccLiveBackDownDoneArray = [@[] mutableCopy];
    for (CCDownloadModel *ccModel in ccloadedArray) {
        if (ccModel.courseID) {
            BOOL isExist = NO;
            for (NSMutableArray *array in _ccLiveBackDownDoneArray) {
                CCDownloadModel *model = [array firstObject];
                if ([ccModel.courseID isEqualToString:model.courseID]) {
                    [array addObject:ccModel];
                    isExist = YES;
                    break;
                }
            }
            if (!isExist) {
                [_ccLiveBackDownDoneArray addObject:[NSMutableArray arrayWithObject:ccModel]];
            }
        }
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"我的下载";
    
    [self setNavRightBtn];//多选删除按钮
    [self setDeletedBtn];//设置全删或删除
    [self.view addSubview:self.tableViewHadDown];
    self.downButton.hidden = YES;
    
    // 创建下来刷新，并更新内容
    @weakify(self);
    self.tableViewHadDown.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        @strongify(self);
        [[DXDownloadManager sharedInstance] sortVideoByCourse];//视频重新加载
        [self checkDownloadStatus];//查看全部下载情况
        if ([self.tableViewHadDown.mj_header isRefreshing]) {
            [self.tableViewHadDown.mj_header endRefreshing];
        }
        [self.tableViewHadDown reloadData];
    }];
    [self.tableViewHadDown.mj_header beginRefreshing];
}

//设置多选按钮
-(void)setNavRightBtn {
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

#pragma mark - UITableView delegate & datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_downloadingNumber) {
        if (indexPath.row ==0) {
             return 90.0;
        }else{
             return 75.0;
        }
    }else{
       return 75.0;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _genseeLiveBackDownDoneArray.count +_ccLiveBackDownDoneArray.count+_videoDownDoneArray.count+(_downloadingNumber?1:0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        if (_downloadingNumber&&indexPath.row ==0) {
            DXDownloadPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DXDownloadPreviewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.numberLabel.text = [NSString stringWithFormat:@"%ld",_downloadingNumber];
            cell.courseImageView.image = [UIImage imageNamed:@"downloadingBV_YM"];
            return cell;
        }else{
            static NSString * cellIdentifier = @"DXHadDownCell";
            DXHadDownCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell  =[DXHadDownCell cell];}
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
            NSInteger flag = _downloadingNumber?1:0;
            NSUInteger videoCount = [DXDownloadManager sharedInstance].dataSource_course.count;
            NSUInteger genseeCount = _genseeLiveBackDownDoneArray.count;
            if (indexPath.row-flag < videoCount) {//视频
                DownCourseModel * co = [DXDownloadManager sharedInstance].dataSource_course[indexPath.row-flag];
                
                cell.co = co;
                [cell.hImageView sd_setImageWithURL:[NSURL URLWithString:co.course_img] placeholderImage:IMG(@"course_default")];
                cell.hTitleLabel.text = co.course_title;
                cell.countLabel.text = [NSString stringWithFormat:@"%ld个文件",(unsigned long)co.items.count];
            }else{//直播回放
                if (indexPath.row-flag< (videoCount + genseeCount)) {
                    //gensee
                    NSMutableArray * array= _genseeLiveBackDownDoneArray[indexPath.row -videoCount-flag];
                    DXLivePlaybackModel *model = [array firstObject];
                    [cell.hImageView sd_setImageWithURL:model.coverImageUrl.URL placeholderImage:[UIImage imageNamed:@"banner_placeHolder"]];
                    cell.hTitleLabel.text = [NSString stringWithFormat:@"%@",model.PrimaryTitle];
                    cell.countLabel.text = [NSString stringWithFormat:@"直播回放--%ld个文件",array.count];
                }else {
                    //cc
                    NSMutableArray * array= _ccLiveBackDownDoneArray[indexPath.row -videoCount - genseeCount -flag];
                    CCDownloadModel *model = [array firstObject];
                    [cell.hImageView sd_setImageWithURL:model.coverImageUrl.URL placeholderImage:[UIImage imageNamed:@"banner_placeHolder"]];
                    cell.hTitleLabel.text = [NSString stringWithFormat:@"%@",model.primaryTitle];
                    cell.countLabel.text = [NSString stringWithFormat:@"直播回放~~%ld个文件",array.count];
                 
                }
               
            }
            
            return cell;
        }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;//多选状态
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.editBtn.isSelected) {//多选状态下
        if (_downloadingNumber&&indexPath.row ==0) {
                //选中正在下载
                [self.selectorPatnArray addObject:@(-1)];
        }else{
            //选中下载完成
            NSInteger flag = _downloadingNumber?1:0;
            NSUInteger videoCount = [DXDownloadManager sharedInstance].dataSource_course.count;
            NSUInteger genseeCount = _genseeLiveBackDownDoneArray.count;
            if (indexPath.row - flag < videoCount) {//视频
                [self.selectorPatnArray addObject:[DXDownloadManager sharedInstance].dataSource_course[indexPath.row -flag]];
                
            }else{//直播回放
                if (indexPath.row-flag< (videoCount + genseeCount)) {
                    //gensee
                    NSMutableArray * array= _genseeLiveBackDownDoneArray[indexPath.row - videoCount -flag];
                    [self.selectorPatnArray addObject: array];
                }else {
                    //cc
                    NSMutableArray * array= _ccLiveBackDownDoneArray[indexPath.row - videoCount - genseeCount -flag];
                    [self.selectorPatnArray addObject: array];
                }
               
            }
        }
    }else{//非多选状态下
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (_downloadingNumber&&indexPath.row ==0) {
            //正在下载的
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            DXDownloadingViewController *downloadingVC = [storyboard instantiateViewControllerWithIdentifier:@"DXDownloadingViewController"];
            [self.navigationController pushViewController:downloadingVC animated:YES];
            
        }else{
            //下载完成的
            NSInteger flag = _downloadingNumber?1:0;
            NSUInteger videoCount = [DXDownloadManager sharedInstance].dataSource_course.count;
            NSUInteger genseeCount = _genseeLiveBackDownDoneArray.count;
            if (indexPath.row-flag < videoCount){//视频
                self.selectDownCourse = [DXDownloadManager sharedInstance].dataSource_course[indexPath.row - flag];
                DXHadDownloadTableTableViewController * vc = [[DXHadDownloadTableTableViewController alloc]init];
                vc.course = _selectDownCourse;
                vc.videoType = 0;
                [self.navigationController pushViewController:vc animated:YES];
            }else{//直播回放
                  NSLog(@"直播回放");
                if (indexPath.row-flag< (videoCount + genseeCount)) {
                    //gensee
                    DXHadDownloadTableTableViewController * vc = [[DXHadDownloadTableTableViewController alloc]init];
                    NSMutableArray *array = _genseeLiveBackDownDoneArray[indexPath.row - videoCount - flag];
//                    NSMutableArray *itemArray = [NSMutableArray array];
//                    for (DXLivePlaybackModel *mode in array) {
//                        [itemArray addObject:mode.item];
//                    }
                    vc.genseeItems = array.mutableCopy;
                    vc.videoType = 1;
                    [self.navigationController pushViewController:vc animated:YES];
                }else {
                    //cc
                    DXHadDownloadTableTableViewController * vc = [[DXHadDownloadTableTableViewController alloc]init];
                    NSMutableArray *array = _ccLiveBackDownDoneArray[indexPath.row - videoCount - genseeCount -flag];
                    vc.ccItems = array.mutableCopy;
                    vc.videoType = 2;
                    [self.navigationController pushViewController:vc animated:YES];
                }
              
            }
        }
    }
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //从选中中取消
    NSUInteger videoCount = [DXDownloadManager sharedInstance].dataSource_course.count;
    NSUInteger genseeCount = _genseeLiveBackDownDoneArray.count;
    if (self.selectorPatnArray.count > 0) {//多选状态下
        if (_downloadingNumber) {
            if ( indexPath.row ==0) {//选中正在下载
                [self.selectorPatnArray removeObject:@(-1)];
            }else{
                if (indexPath.row - 1 < videoCount) {//视频
                    [self.selectorPatnArray removeObject:[DXDownloadManager sharedInstance].dataSource_course[indexPath.row -1]];
                    
                }else{//直播回放
                    if (indexPath.row- 1< (videoCount + genseeCount)) {
                        NSMutableArray * array= _genseeLiveBackDownDoneArray[indexPath.row - videoCount -1];
                        [self.selectorPatnArray removeObject: array];
                    }else {
                        NSMutableArray * array= _ccLiveBackDownDoneArray[indexPath.row - videoCount - genseeCount -1];
                        [self.selectorPatnArray removeObject: array];
                    }
                    
                }
            }
        }else{
            if (indexPath.row < videoCount) {//视频
                [self.selectorPatnArray removeObject:[DXDownloadManager sharedInstance].dataSource_course[indexPath.row]];
                
            }else{//直播回放
                if (indexPath.row < (videoCount + genseeCount)) {
                    NSMutableArray * array= _genseeLiveBackDownDoneArray[indexPath.row - videoCount];
                    [self.selectorPatnArray removeObject: array];
                }else {
                    NSMutableArray * array= _ccLiveBackDownDoneArray[indexPath.row - videoCount - genseeCount];
                    [self.selectorPatnArray removeObject: array];
                }
               
            }
        }
        
    }
    
}

#pragma mark - 删除 开始 停止下载

/* ALL - 开始/暂停 */
- (void)actionButtonTapped:(id)sender
{
    UIButton *allButton = (UIButton *)sender;
    if ([allButton.titleLabel.text isEqualToString:@"全部开始"]) {
        [[DXDownloadManager sharedInstance] startDownloadAll];
    }else if ([allButton.titleLabel.text isEqualToString:@"全部暂停"]){
        [[DXDownloadManager sharedInstance] stopDownloadAll];
    }
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

}

/**
 *  暂停下载
 */
- (void)downloadManagerItemDidStop:(NSNotification *)notification {

}

- (void)downloadManagerNetworkStatusChanged:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *userInfo = notification.userInfo;
        [self showHint:userInfo[@"text"]];
    });
}

- (void)downloadManagerDownloadFinished:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentNotification];
    });
}

- (void)downloadManagerDownloadSuccess:(NSNotification *)notification
{
    DXWeak(self, weakSelf);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        /* 更新正在下载列表 */
       // [weakSelf.tableViewQueue reloadData];
        
        /* 更新已下载   */
        [weakSelf.tableViewHadDown reloadData];
        
        /*  开启"全部下载",但是暂停部分任务, 修正顶部downButton显示逻辑   */
        NSArray *isDown = [[DXDownloadManager sharedInstance].downloadingItems.items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.videoDownloadStatus = 1"]];
        
        if (isDown.count == 0)
        {
            [self.downButton setTitle:@"全部开始" forState:UIControlStateNormal];
        }
    });
}
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)downloadManagerDownloading:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSInteger totalBytesExpectedToWrite = [(NSNumber *)userInfo[@"totalBytesExpectedToWrite"] integerValue];
    
    if([[self freeDiskSpace]longLongValue] <= (long long)totalBytesExpectedToWrite){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"警告" message:@"设备可用容量不足,建议清除手机内存后重试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            [self.downButton setTitle:@"开始下载" forState:UIControlStateNormal];
        });
        return;
    }
    
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"没有下载的课程";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

// 返回详情文字
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = nil;
    text = @"在课程播放页面可以选择下载的视频";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attribute = @{
                                NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                NSParagraphStyleAttributeName: paragraph
                                };
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}
//编辑btn
-(void)editBtnClick:(UIButton *)sender
{
    [self.view bringSubviewToFront:_bottomView];
    if (sender.isSelected) {//多选状态普通状态
        self.tableViewHadDown.editing = NO;
        self.bottomView.hidden = YES;
    }else{
        self.tableViewHadDown.editing = YES;
        self.bottomView.hidden = NO;
    }
    sender.selected = !sender.selected;
    [self.tableViewHadDown reloadData];
    NSLog(@"多选删除");
}

//全删
-(void)selectAllClick
{
    //直播回放删除
    //gensee
    [[GSVodManager sharedInstance] stopQueue];
    [[GSVodManager sharedInstance] cleanQueue];
    [[VodManage shareManage] deleteAllItem];
    [[DXLivePlaybackFMDBManager shareManager] removeAllobjects];
    //cc
    for (CCDownloadModel *model in [CCDownloadSessionManager manager].downloadModelList) {
        [[CCDownloadSessionManager manager] deleteWithDownloadModel:model];
    }
//     [[CCDownloadSessionManager manager] deleteAllDownloadModel];
    
    
//视频全部删除
    //下载中删除
    NSMutableArray *videoDownloadingArray  = [[DXDownloadManager sharedInstance] dataSource_queue].mutableCopy;
    for (DXDownloadItem *item in videoDownloadingArray)
    {
        [[DXDownloadManager sharedInstance].downloadingItems removeObject:item];
    }
    [[DXDownloadManager sharedInstance].downloadingItems writeToPlistFile:DXDownloadingItemPlistFilename];
    
    //已下载删除
    NSArray *videodataSource_courseArray  =  [[DXDownloadManager sharedInstance] dataSource_haddown].mutableCopy;
    for (DXDownloadItem *item in videodataSource_courseArray)
    {
        [[DXDownloadManager sharedInstance].downloadFinishItems removeObject:item];
    }
    [[DXDownloadManager sharedInstance].downloadFinishItems writeToPlistFile:DXDownloadFinishItemPlistFilename];
    
    self.editBtn.selected = NO;
    [[DXDownloadManager sharedInstance] sortVideoByCourse];//视频重新加载
    [self checkDownloadStatus];//重新加载下载情况
    self.tableViewHadDown.editing = NO;
    self.bottomView.hidden = YES;
    [self.tableViewHadDown reloadData];
    NSLog(@"全删");
}

//删除选中
-(void)deleteClick
{
    NSLog(@"删除选中");
    for (NSObject *obj in self.selectorPatnArray) {
        if ([obj isKindOfClass:[NSNumber class]]){
            //下载中删除
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
            
            //视频下载中删除
            NSArray *videoDownloadingArray  = [[DXDownloadManager sharedInstance] dataSource_queue].mutableCopy;
            for (DXDownloadItem *item in videoDownloadingArray)
            {
                [[DXDownloadManager sharedInstance].downloadingItems removeObject:item];
            }
            [[DXDownloadManager sharedInstance].downloadingItems writeToPlistFile:DXDownloadingItemPlistFilename];
            
        }else{
            //下载完成的
            if ([obj isKindOfClass:[DownCourseModel class]]){//视频
                DownCourseModel *downCourseModel = (DownCourseModel*)obj;
                
                for (DXDownloadItem *item in [downCourseModel.items mutableCopy])
                {
                    [[DXDownloadManager sharedInstance].downloadFinishItems removeObject:item];
                }
                [[DXDownloadManager sharedInstance].downloadFinishItems writeToPlistFile:DXDownloadFinishItemPlistFilename];
                
            }else if([obj isKindOfClass:[NSMutableArray class]]){//直播回放
                NSMutableArray *array = (NSMutableArray*)obj;
                if ([[array firstObject] isKindOfClass:[DXLivePlaybackModel class]]) {
                      //gensee
                    for (DXLivePlaybackModel *model in [array mutableCopy]) {
                        [[VodManage shareManage] deleteItem:model.item.strDownloadID];
                        [[DXLivePlaybackFMDBManager shareManager] removeStrDownloadID:model.item.strDownloadID];
                    }
                }else  if ([[array firstObject] isKindOfClass:[CCDownloadModel class]]) {
                    //cc
                    for (CCDownloadModel *model in [array mutableCopy]) {
                        [[CCDownloadSessionManager manager] deleteWithDownloadModel:model];
                    }
                }
            }
        }
    }
    self.editBtn.selected = NO;
    [[DXDownloadManager sharedInstance] sortVideoByCourse];//视频重新加载
    [self checkDownloadStatus];//重新加载下载情况
    self.tableViewHadDown.editing = NO;
    self.bottomView.hidden = YES;
    [self.tableViewHadDown reloadData];
}
@end
