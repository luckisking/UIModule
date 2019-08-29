//
//  DXHadDownloadTableTableViewController.m
//  Doxuewang
//
//  Created by Zhang Lei on 16/3/7.
//  Copyright © 2016年 都学网. All rights reserved.
//
#define courseCacheKey [NSString stringWithFormat:@"course_%ld_%lld",_course.course_id,[DXUserManager sharedManager].user.uid]//除了套餐外其他课程缓存的key，包括录播、线下课程和书籍

#define liveBackCourseCacheKey [NSString stringWithFormat:@"course_%@_%lld",_livePlaybackModel.courseID,[DXUserManager sharedManager].user.uid]//除了套餐外其他课程缓存的key，包括录播、线下课程和书籍

#import "DXLivePlaybackFMDBManager.h"
#import "DXLivePlaybackModel.h"
#import <VodSDK/VodSDK.h>
#import "DXSelectDownloadItemViewController.h"
#import "DXMyApiExecutor.h"
#import "CourseModel.h"
#import <TMCache/TMDiskCache.h>
#import <TMCache/TMCache.h>
#import "DXHadDownloadTableTableViewController.h"
#import "AppDelegate.h"
#import "DownCourseModel.h"
#import "DownItemCell.h"
#import "OrderViewController.h"
#import "JieModel.h"
#import "DXMoviePlayerViewController.h"
#import "DXDownloadManager.h"
#import "CourseDetailViewController.h"
#import "UIView+YMTool.h"
#import "DXLivePlayBackViewController.h"
#import "CCSDK/OfflinePlayBack.h"//离线下载

@interface DXHadDownloadTableTableViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
{
    DXDownloadManager *_manager;
}

@property (nonatomic, strong) CourseModel *courseModel;//课程详情模型
@property (strong, nonatomic) NSMutableArray * courseChapters;              // 课程的章节
@property (nonatomic, strong) DXDownloadItem * selectPlayItem;
@property (strong, nonatomic) NSMutableArray * selectedMarray;//视频选择下载数组
@property (strong, nonatomic) DXLivePlaybackModel *livePlaybackModel;

@property (nonatomic, assign) BOOL isEnterDownloadVC;
@property(nonatomic, strong)  UIButton * editBtn;
@property(nonatomic, strong)  UIView *bottomView;//全删或删除选中view
@property (nonatomic, strong)NSMutableArray *selectorPatnArray;//多选array
@property (nonatomic, strong) UITableView * tableViewQueue;     //下载列表
@end

@implementation DXHadDownloadTableTableViewController

/**
 *  tableview 正在下载
 *  @return tableview对象
 */

-(UITableView *)tableViewQueue{
    if (_tableViewQueue == nil) {
        _tableViewQueue = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight+kNavBarHeight, IPHONE_WIDTH, IPHONE_HEIGHT-kStatusBarHeight+kNavBarHeight-kBootomSafeHeight) style:UITableViewStylePlain];
        _tableViewQueue.dataSource = self;
        _tableViewQueue.delegate = self;
        _tableViewQueue.emptyDataSetSource = self;
        _tableViewQueue.emptyDataSetDelegate = self;
        _tableViewQueue.editing = NO;
        _tableViewQueue.tableFooterView = [[UIView alloc]init];
    }
    return _tableViewQueue;
}

#pragma mark - 选中array
- (NSMutableArray *)selectorPatnArray{
    if (!_selectorPatnArray) {
        _selectorPatnArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectorPatnArray;
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

//多选删除
-(void)editBtnClick:(UIButton *)sender
{
    [self.view bringSubviewToFront:_bottomView];
    if (sender.isSelected) {//多选状态普通状态
        self.tableViewQueue.editing = NO;
        self.bottomView.hidden = YES;
    }else{
        self.tableViewQueue.editing = YES;
        self.bottomView.hidden = NO;
    }
    sender.selected = !sender.selected;
    [self.tableViewQueue reloadData];
    NSLog(@"多选删除");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _manager = [DXDownloadManager sharedInstance];

    [self sortDownCourseArr];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)sortDownCourseArr{
    /* 课程排序 */
    [self.course.items sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        DXDownloadItem *item_one = (DXDownloadItem *)obj1;
        DXDownloadItem *item_two = (DXDownloadItem *)obj2;
        
        NSString *strOne = [[item_one.video_title componentsSeparatedByString:@" "] firstObject];
        NSString *strTwo = [[item_two.video_title componentsSeparatedByString:@" "] firstObject];
        
        NSString *aHead = [[strOne componentsSeparatedByString:@"."] firstObject];
        NSString *aFoot = [[strOne componentsSeparatedByString:@"."] lastObject];
        NSString *bHead = [[strTwo componentsSeparatedByString:@"."] firstObject];
        NSString *bFoot = [[strTwo componentsSeparatedByString:@"."] lastObject];
        
        /* 先比较小数点前 */
        if ([aHead intValue] > [bHead intValue])
        {
            return NSOrderedDescending;
        }
        else if ([aHead intValue] < [bHead intValue])
        {
            return NSOrderedAscending;
        }
        else
        {
            /* 如果小数点前相等,在比较小数点后 */
            if ([aFoot intValue] > [bFoot intValue])
            {
                return NSOrderedDescending;
            }
            else
            {
                return NSOrderedAscending;
            }
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedMarray     = [[NSMutableArray alloc] initWithCapacity:0];
    [self setNavRightBtn];//多选删除按钮
    [self setDeletedBtn];//设置全删或删除
    if (!_videoType) {
        self.title = self.course.course_title;
    }else{
        if (_genseeItems.count)self.title = [NSString stringWithFormat:@"%@",[_genseeItems firstObject].PrimaryTitle];
        if (_ccItems.count)self.title = [NSString stringWithFormat:@"%@",[_ccItems firstObject].primaryTitle];
    }
    
    [self.view addSubview:self.tableViewQueue];
    self.tableViewQueue.tableFooterView = [[UIView alloc]init];
    self.tableViewQueue.rowHeight = 70;
    if (!_videoType) {
         [self setHeadView];
    }
}

//
-(void)setHeadView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 90)];

    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(20, 21, 102, 58)];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0]];
    [headView addSubview:backgroundView];
    
    UIImageView * cacheMoreImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 18, 22, 22)];
    cacheMoreImageView.image = [UIImage imageNamed:@"cacheMore_YM"];
    [backgroundView addSubview:cacheMoreImageView];
    
    UILabel *nameLable= [[UILabel alloc] initWithFrame:CGRectMake(132, 40, 70, 20)];
    nameLable.textAlignment = NSTextAlignmentLeft;
    nameLable.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    nameLable.font = [UIFont systemFontOfSize:14];
    nameLable.text = @"缓存更多";
    [headView addSubview:nameLable];
    [headView addTarget:self action:@selector(cacheMore)];
    
    self.tableViewQueue.tableHeaderView = headView;
}

//设置多选按钮
-(void)setNavRightBtn
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.editBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    //self.navigationItem.rightBarButtonItems = @[rightItem1,rightItem];
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

//缓存更多
-(void)cacheMore
{
    NSLog(@"cacheMore");
    if (_course) {//视频课程
        [self loadVideoCourseModel];
    }
    else
    {//直播回放
        [self loadLivebackModel];
    }
}

//全删
-(void)selectAllClick
{
    self.editBtn.selected = NO;
    switch (_videoType) {
        case 0:{
            //视频删除
            for (DXDownloadItem *item in [self.course.items mutableCopy])
            {
                [[DXDownloadManager sharedInstance].downloadFinishItems removeObject:item];
            }
            [[DXDownloadManager sharedInstance].downloadFinishItems writeToPlistFile:DXDownloadFinishItemPlistFilename];
            
            [self.course.items removeAllObjects];
            
        }
            break;
        case 1:{
            //gensee
            for (DXLivePlaybackModel *model in self.genseeItems) {
                [[VodManage shareManage] deleteItem:model.item.strDownloadID];
            }
            [self.genseeItems removeAllObjects];
        }
            
            break;
        case 2:{
            //cc
            for (CCDownloadModel *model in self.ccItems) {
                [[CCDownloadSessionManager manager] deleteWithDownloadModel:model];
            }
            [self.ccItems removeAllObjects];
        }
            break;
            
        default:
            break;
    }
    self.tableViewQueue.editing = NO;
    self.bottomView.hidden = YES;
    [self.tableViewQueue reloadData];
    NSLog(@"全删");
   // [self.navigationController popViewControllerAnimated:YES];
}

//删除选中
-(void)deleteClick
{
    NSLog(@"删除选中");
    for (NSObject *obj in self.selectorPatnArray) {
        if([obj isKindOfClass:[DXDownloadItem class]]){//视频
            DXDownloadItem *item = (DXDownloadItem*)obj;
            [[DXDownloadManager sharedInstance].downloadFinishItems removeObject:item];
            [self.course.items removeObject:item];
            [[DXDownloadManager sharedInstance].downloadFinishItems writeToPlistFile:DXDownloadFinishItemPlistFilename];
        }else if([obj isKindOfClass:[DXLivePlaybackModel class]]){//直播回放gensee
            DXLivePlaybackModel *model = (DXLivePlaybackModel *)obj;
            [[VodManage shareManage] deleteItem:model.item.strDownloadID];
            [self.genseeItems removeObject:model];
        }else if([obj isKindOfClass:[CCDownloadModel class]]){//直播回放cc
            CCDownloadModel *model = (CCDownloadModel *)obj;
            [[CCDownloadSessionManager manager] deleteWithDownloadModel:model];
            [self.ccItems removeObject:model];
        }
    }
        
    self.editBtn.selected = NO;
    self.tableViewQueue.editing = NO;
    self.bottomView.hidden = YES;
    [self.tableViewQueue reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_videoType==0) return _course.items.count;
    if (_videoType==1) return _genseeItems.count;
    if (_videoType==2) return _ccItems.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"DownItemCell";
    
    DownItemCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [DownItemCell cell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    if (_videoType==0) {//视频
        DXDownloadItem * item = self.course.items[indexPath.row];
        cell.itemTitleLabel.text = item.video_title;
        //    cell.itemTitleLabel.numberOfLines = 0;
        cell.itemDetailLabel.text = [NSString stringWithFormat:@"%.1fM",item.videoFileSize/1024.0/1024.0];
        cell.timeLable.text = [NSString stringWithFormat:@"%@",item.duration];
        NSLog(@"%.1f--%.1f",item.videoFileSize/1024.0/1024.0,item.videoDownloadedSize/1024.0/1024.0);

    } else if (_videoType==1) {//直播回放gensee
        DXLivePlaybackModel * model = self.genseeItems[indexPath.row];
        _livePlaybackModel = model;
        cell.itemTitleLabel.text = [NSString stringWithFormat:@"%@",model.SecondaryTitle];
        [model.item requestMoreInfo:^(BOOL isSuccess, NSString *fileSize, NSString *startTime, NSString *endTime) {
             NSLog(@"fileSize--%@,startTime--%@,endTime--%@",fileSize,startTime,endTime);
            if (![fileSize IsEmptyStr]) {
                cell.itemDetailLabel.text = [NSString stringWithFormat:@"%.1fM",[fileSize floatValue]/1024.0/1024.0];
            }
            if (![startTime IsEmptyStr]) {
                NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"YY-MM-dd HH:mm:ss"];
                NSDate *dateStartTime = [formatter dateFromString:startTime];
                NSDate *dateEndTime = [formatter dateFromString:endTime];
                NSString * time = [NSString stringWithFormat:@"%ld",(long)[dateEndTime timeIntervalSinceDate:dateStartTime]];
                cell.timeLable.text = [NSString stringWithFormat:@"%@",[self formatTime:time.intValue]];
                NSLog(@"%@",[self formatTime:time.intValue]);
            }
            
        }];

    }else if (_videoType==2) {//直播回放CC
        CCDownloadModel * model = self.ccItems[indexPath.row];
        _livePlaybackModel = [[DXLivePlaybackModel alloc] init];
        _livePlaybackModel.courseID = model.courseID;
        cell.itemTitleLabel.text = [NSString stringWithFormat:@"%@",model.secondaryTitle];
        cell.itemDetailLabel.text = [NSString stringWithFormat:@"%.1fM",model.progress.totalBytesExpectedToWrite/1024.0/1024.0];
        //cc没有存储视频时间长度（可以下载请求的时候计算）
        cell.timeLable.text = @"";
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editBtn.isSelected) {//多选状态下
        if (_videoType==0) {//视频
            DXDownloadItem *item = self.course.items[indexPath.row];
            [self.selectorPatnArray addObject:item];
            
        }else  if (_videoType==1) {//直播回放gensee
            DXLivePlaybackModel *model = self.genseeItems[indexPath.row];
            [self.selectorPatnArray addObject:model];
            
        }else  if (_videoType==2) {//直播回放cc
            CCDownloadModel *item = self.ccItems[indexPath.row];
            [self.selectorPatnArray addObject:item];
            
        }
    }else{
        if (_videoType==0) {//视频
            self.selectPlayItem = self.course.items[indexPath.row];
            // 检查课程有效期，如果超过时间，则不允许客户进行播放，要求去更新课程时间！
            BOOL isCourseExpired = NO;
            if (_selectPlayItem.expireTime != 0) {
                NSTimeInterval intervale = [[NSDate dateWithTimeIntervalSince1970:_selectPlayItem.expireTime] timeIntervalSinceNow];
                if (intervale < 0) {
                    isCourseExpired = YES;
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"更新课程有效期", @"") message:NSLocalizedString(@"课程已经超过您购买的有效期，无法继续观看。请更新课程有效期后，重新再试！", @"") preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"以后再说", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"立即更新", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        // 显示购买课程页面，要求用户去购买
                        OrderViewController *orderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderViewController"];
                        orderViewController.courseID = [[NSString stringWithFormat:@"%lld",_selectPlayItem.course_id] integerValue];
                        orderViewController.inType   = @"1";
                        [self.navigationController pushViewController:orderViewController animated:YES];
                        
                    }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
            
            if (isCourseExpired == NO) {
                
                //        CourseModel *ActualModel = [CourseModel object];
                //        if ([[TMDiskCache sharedCache]objectForKey:MYCourseListKey]){
                //            NSDictionary *cacheDict = (NSDictionary *)[[TMDiskCache sharedCache]objectForKey:MYCourseListKey];
                //            for (NSDictionary *model in cacheDict[@"data"]) {
                //                CourseModel *course = [CourseModel object];
                //                [course setValuesForKeysWithDictionary:model];
                //
                //                course.courseID = [(NSNumber *)model[@"id"] integerValue];
                //                if ([model[@"teacher"]isKindOfClass:[NSDictionary class]]) {
                //                    course.teacher_name = model[@"teacher"][@"name"];}
                //
                //                if (course.courseID == self.selectPlayItem.course_id) {
                //                    [ActualModel setValuesForKeysWithDictionary:model];
                //                    ActualModel.courseID = [(NSNumber *)model[@"id"] integerValue];
                //                    break;
                //                }
                //            }
                //        }
                
                //        CourseDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseDetailViewController"];
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                CourseDetailViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"CourseDetailViewController"];
                
                //        CourseModel *ActualModel = [CourseModel object];
                //        ActualModel.Id = self.selectPlayItem.course_id;
                //        ActualModel.courseID = [[NSString stringWithFormat:@"%lld",self.selectPlayItem.course_id] integerValue];
                //        ActualModel.kctype = 1;
                //        ActualModel.imgurl = self.selectPlayItem.imageurl;
                //        ActualModel.video_title = self.course.course_title;
                
                viewController.courseId = [[NSString stringWithFormat:@"%lld",self.selectPlayItem.course_id] integerValue];
                viewController.kctype = 1;
                viewController.isTaocan = NO;
                //        viewController.course = ActualModel;
                viewController.isFromDownLoad = YES;
                viewController.startIndex     = self.selectPlayItem.video_id;
                [self.navigationController pushViewController:viewController animated:YES];
                
                //        [self performSegueWithIdentifier:@"downloadToPlayView" sender:nil];
            }
        }else  if (_videoType==1) {
            //直播回放gensee
            DXLivePlayBackViewController *_playBackVC = [[DXLivePlayBackViewController alloc] init];
            DXLivePlaybackModel *livePlaybackMode  = self.genseeItems[indexPath.row];
            _playBackVC.videoTitle = livePlaybackMode.SecondaryTitle;
            _playBackVC.courseID = livePlaybackMode.courseID.integerValue;
            _playBackVC.imgUrl = livePlaybackMode.coverImageUrl;
            _playBackVC.teach_material_file = livePlaybackMode.fileUrl;
            _playBackVC.item = livePlaybackMode.item;
            DXUser *user  =  [DXUserManager sharedManager].user;
            [_playBackVC setUserInfoWihtUid:user.uid uname:user.uname email:user.email phone:user.phone];
            [self.navigationController pushViewController:_playBackVC animated:YES];
            
        }else  if (_videoType==2) {
            //直播回放cc
            DXLivePlayBackViewController *_playBackVC = [[DXLivePlayBackViewController alloc] init];
            CCDownloadModel * model = self.ccItems[indexPath.row];
            _playBackVC.videoTitle = model.secondaryTitle;
            _playBackVC.courseID = model.courseID.integerValue;
            _playBackVC.imgUrl = model.coverImageUrl;
            _playBackVC.teach_material_file = model.fileUrl;
            _playBackVC.ccDownloadedPlayfile = model.filePath;
            _playBackVC.liveType = YES;
            DXUser *user  =  [DXUserManager sharedManager].user;
            [_playBackVC setUserInfoWihtUid:user.uid uname:user.uname email:user.email phone:user.phone];
            if (model.decompressionState == 2) {
                [self.navigationController pushViewController:_playBackVC animated:YES];
            }else {
                if (model.decompressionState == 1) {
                    [self showHint:@"请稍后，正在解压"];
                }else if (model.decompressionState == 0){
                    NSString *str = [model.filePath substringToIndex:model.filePath.length - 4];
                    dispatch_queue_t t = dispatch_queue_create("HDOfflive", NULL);
                    dispatch_async(t, ^{
                        model.decompressionState = 1;
                        int zipDec = [[[OfflinePlayBack alloc]init] DecompressZipWithDec:model.filePath dir:str];
                        NSLog(@"解压码是%d,,,,路径是%@",zipDec,model.filePath);
                        if (zipDec == 0) {
                            [[CCDownloadSessionManager manager] decompressionFinish:model];
                            [self.navigationController pushViewController:_playBackVC animated:YES];
                        } else {
                            model.decompressionState = 3;
                            [self showHint:@"解压失败"];
                            return ;
                        }
                        
                    });
                    
                }
                return;
            }
         
            
        }
    }
   
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;//多选状态
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if(tableView == self.tableViewQueue){
    //        return @"移除";}
    return @"";
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        DXDownloadItem * item = self.course.items[indexPath.row];
        
        /* mp4文件 */
        NSString * mp4moviePath = [NSString stringWithFormat:@"%@/%@.mp4",paths[0],item.video_id];
        if ([[NSFileManager defaultManager] fileExistsAtPath:mp4moviePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:mp4moviePath error:nil];}
        
        /* pcm加密文件 */
        NSString *pcmmoviePath = [NSString stringWithFormat:@"%@/%@.pcm",paths[0],item.video_id];
        if ([[NSFileManager defaultManager] fileExistsAtPath:pcmmoviePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:pcmmoviePath error:nil];}

        [self.course.items removeObjectAtIndex:indexPath.row];
        [self.tableViewQueue deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
//        for (int i = 0; i<APPDELEGATE.downloadFinishItems.items.count; i++) {
//            DXDownloadItem * obj = APPDELEGATE.downloadFinishItems.items[i];
//            if ([item.video_id isEqualToString:obj.video_id]){
//                [APPDELEGATE.downloadFinishItems.items removeObject:obj];
//            }
//        }
//        
//        [APPDELEGATE.downloadFinishItems writeToPlistFile:DXDownloadFinishItemPlistFilename];
 
        for (int i = 0; i<_manager.downloadFinishItems.items.count; i++) {
            DXDownloadItem * obj = _manager.downloadFinishItems.items[i];
            if ([item.video_id isEqualToString:obj.video_id]){
                [_manager.downloadFinishItems.items removeObject:obj];}}
        [_manager.downloadFinishItems writeToPlistFile:DXDownloadFinishItemPlistFilename];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadDownloadItems" object:nil];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.editBtn.isSelected) {//多选状态下
        //从选中中取消
        if (_videoType==0) {//视频
            DXDownloadItem *item = self.course.items[indexPath.row];
            [self.selectorPatnArray removeObject:item];
            
        }else if (_videoType==1){//直播回放
            DXLivePlaybackModel *item = self.genseeItems[indexPath.row];
            [self.selectorPatnArray removeObject:item];
            
        }else if (_videoType==2){//直播回放
            CCDownloadModel *mode = self.ccItems[indexPath.row];
            [self.selectorPatnArray removeObject:mode];
        }

    }
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"downloadToPlayView"]) {
        DXMoviePlayerViewController * moviePlayer = [segue destinationViewController];
        
        JieModel * jie = [JieModel object];
        jie.Id = self.selectPlayItem.Id;
        jie.duration = self.selectPlayItem.duration;
        jie.isfree = self.selectPlayItem.isfree;
        jie.video_id = self.selectPlayItem.video_id;
        jie.video_title = self.selectPlayItem.video_title;
        moviePlayer.jie = jie;
    }
}


//时长计算
- (NSString *)formatTime:(int)msec {
    int hours = msec / 60 / 60;
    int minutes = (msec / 60) % 60;
    int seconds = msec % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

#pragma mark - 缓存更多

#pragma mark -  加载视频课程详情信息
-(void)loadVideoCourseModel
{
      _courseModel = [[TMCache sharedCache]objectForKey:courseCacheKey];

    if (_courseModel) {//有缓存
        NSLog(@"有缓存");
        _courseChapters = _courseModel.chapters;
        //展示选择下载页面
        [self showSelectDownView];
    }
    else
    {//没缓存去下载
        NSLog(@"没缓存去下载");
        [self retrieveAndUpdateCourseData];//获取课程详情
        
    }
    
}

/**
 第一次获取的课程数据存到本地
 */
- (void)retrieveAndUpdateCourseData {
    
    @weakify(self);
    if (_course.course_id > 0||_livePlaybackModel.courseID>0) {
        ApiRequestStateHandler *requestHandler = [ApiRequestStateHandler apiRequestStateHandlerOnSuccess:^(ApiExcutor *apiExcutor, BOOL *cache) {
            
            @strongify(self);
            NSDictionary *dict = apiExcutor.responseJson;
            if (dict && ([dict[@"flag"] integerValue] == 1 || [dict[@"state"] integerValue] == 1)) {
                NSData *dataJson = [NSJSONSerialization dataWithJSONObject:dict[@"data"] options:0 error:nil];
                NSLog(@"%@",[[NSString alloc]initWithData:dataJson encoding:NSUTF8StringEncoding]);
                // 取得课程信息
                NSDictionary *courseDict = dict[@"data"][@"video"];
                // 整理课程字段内信息
                CourseModel *course = [[CourseModel alloc] initWithJson:courseDict];
                if (dict[@"data"][@"sold_count"]) {
                    course.sold_count = [dict[@"data"][@"sold_count"] intValue];
                }
                
                if ([dict[@"teacher"] isKindOfClass:[NSDictionary class]]) {
                    course.teacher_name = dict[@"teacher"][@"name"];
                }
                
                if (dict[@"data"][@"expire"]) {
                    course.expire = [dict[@"data"][@"expire"] boolValue];
                }
                
                self.courseModel = course;
                //下载课程章节列表
                [self retrieveAndUpdateChapter];
            }
        } onFail:^(ApiExcutor *apiExcutor, NSError *error) {
            logerror(@"Original URL: %@, Description: %@", [apiExcutor getOriginalRequestURL], error.localizedDescription);
        }];
        
        // 执行api接口，获取课程信息
        ApiExcutor *excutor = [ApiExcutor excutor];
        if (_videoType==0) {
             [excutor addParam:@(_course.course_id) forKey:@"vid"];
        }else{
             [excutor addParam:_livePlaybackModel.courseID forKey:@"vid"];
        }
        [excutor addParam:@([DXUserManager sharedManager].user.uid) forKey:@"uid"];
        [excutor get:DX_API_COURSE_GET_VIDEO_DETAIL_v2 withStateHandler:requestHandler];
    }
    else {
        
        logerror(@"没有视频ID，无法找到课程信息");
        
    }
}

/**
  获取章节信息
 */
- (void)retrieveAndUpdateChapter{
    
    logdebug(@"开始获取课程《%@》[ID:%ld]章节信息", _course.course_title, (long)_course.course_id);
    @weakify(self);
    
    NSInteger vid;
    if (!_videoType) {
        vid = _course.course_id;
    }else{
        vid = [_livePlaybackModel.courseID integerValue];
    }
    
    DXMyApiExecutor *excutor = [[DXMyApiExecutor alloc] init];
    [excutor getCourseChapterWithVid:vid uid:[DXUserManager sharedManager].user.uid onSuccess:^(id dataObject) {
        logdebug(@"已经从服务器获得课程章节信息, 开始进行数据解析");
        @strongify(self);
        [self hideHud];
        //在这里已经把是否能单节购买的参数在这里返回了，避免网络异步导致的错误
        //返回的数据没有章节信息，章节（如1.2）要自己处理
        NSArray *dirs = dataObject[@"dir"];
        self.courseChapters = (dirs)?[NSMutableArray arrayWithArray:dirs]:nil;
        
       _courseModel.chapters = _courseChapters;
        if (!_videoType) {//视频
             [[TMCache sharedCache]setObject:_courseModel forKey:courseCacheKey];//添加缓存
        }else{//直播回放
            [[TMCache sharedCache]setObject:_courseModel forKey:liveBackCourseCacheKey];//添加缓存
        }
       
        [self showSelectDownView];
//        [self cacheNetWorkWatchRacord];
//        [self getChapterIndexAndGetDownloadIndex];
//
        //            [self cacheChapter];

    } onFail:^(NSInteger flag, NSString *msg) {
        NSLog(@"%@",msg);
    }];
}

#pragma Mark - 展示视频选择下载页面
- (void)showSelectDownView{
    
    // 选择下载条目的视图
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DXSelectDownloadItemViewController *selectDownloadItemVC = [mainSB instantiateViewControllerWithIdentifier:@"DXSelectDownloadItemViewController"];
    
    // 设置课程以及对应的章节
    selectDownloadItemVC.course = self.courseModel;
    selectDownloadItemVC.dataArray = self.courseChapters;
    selectDownloadItemVC.isVideo = !_videoType;
    
    @weakify(self);
    selectDownloadItemVC.closeWithNoChoice = ^{
        @strongify(self);
        _isEnterDownloadVC = NO;

    };
    
    //√按钮操作
    selectDownloadItemVC.closeButtonBlock = ^(NSMutableArray *selectDownArr) {
        @strongify(self);
        self.selectedMarray = [NSMutableArray arrayWithArray:selectDownArr];
        [self addDownloadQueue];
        _isEnterDownloadVC = NO;

    };
    _isEnterDownloadVC = YES;
    [self presentViewController:selectDownloadItemVC animated:YES completion:nil];
    
}

#pragma mark - 判断是否已选
-(BOOL)isSelectedIndexPath:(NSIndexPath*)indexPath{
    for (NSIndexPath * indexP in self.selectedMarray) {
        if (indexPath.section == indexP.section && indexPath.row == indexP.row) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 加入下载列表

- (void)addDownloadQueue{
    
    if (self.selectedMarray.count == 0)
    {
        return;
    }
    
    if (kNetworkNotReachability)
    {
        [self showHint:@"网络连接不可用"];
        return;
    }
    
    
    
    if ([self.selectedMarray count] == 0)
    {
        [self showHint:@"所选章节均已在下载队列或已下载完毕"];
    }
    else
    {
        //加入下载队列->检查网络状态
        [[DXDownloadManager sharedInstance] appendDownloadItems:self.selectedMarray];
        [[DXDownloadManager sharedInstance].downloadingItems writeToPlistFile:DXDownloadingItemPlistFilename];
        [self showHint:[NSString stringWithFormat:@"%ld个视频已成功加入下载列表",[self.selectedMarray count]]];
        
        NSString *msg = nil;
        BOOL canStartDownload = NO;
        
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN)
        {
            BOOL isOn = [[NSUserDefaults standardUserDefaults] boolForKey:AllowDownloadVideoByCellular];
            if (isOn)
            {
                BOOL automaticallyStartDownload = [[NSUserDefaults standardUserDefaults] boolForKey:AUTOMATICALLY_START_DOWNLOAD];
                if (automaticallyStartDownload)
                {
                    canStartDownload = YES;
                    //通知控制器下载自动下载通知!
                    [DXDownloadManager sharedInstance].isDownloading = YES;
                }else
                {
                    msg = NSLocalizedString(@"没有开启自动下载选项，无法进行自动下载。", @"");
                }
            }
            else
            {
                msg = NSLocalizedString(@"在运营商网络环境下，没有开启允许下载选项，无法进行下载。", @"");
            }
        }
        else
        {
            BOOL automaticallyStartDownload = [[NSUserDefaults standardUserDefaults] boolForKey:AUTOMATICALLY_START_DOWNLOAD];
            if (automaticallyStartDownload)
            {
                canStartDownload = YES;
            }
            else
            {
                msg = NSLocalizedString(@"没有开启自动下载选项，无法进行自动下载。", @"");
            }
        }
        
        if (canStartDownload)
        {
            DXWeak(self, weakSelf);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf showHint:NSLocalizedString(@"已经自动开始下载", @"")];
            });
            
            [[DXDownloadManager sharedInstance] startDownloadAll];
        }
        else if (msg)
        {
            DXWeak(self, weakSelf);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf showHint:msg];
            });
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadDownloadItems" object:nil];
    }
}

#pragma mark -  缓存直播回放
-(void)loadLivebackModel
{
    _courseModel = [[TMCache sharedCache]objectForKey:liveBackCourseCacheKey];
    
    if (_courseModel) {//有缓存
        NSLog(@"有缓存");
        _courseChapters = _courseModel.chapters;
        //展示选择下载页面
        [self showSelectDownView];
    }
    else
    {//没缓存去下载
        NSLog(@"没缓存去下载");
        [self retrieveAndUpdateCourseData];//获取课程详情
        
    }
    
}


#pragma mark - DZNEEmpty.Delegate

//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
//    return IMG(@"noHistory");
//
//}

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
    //    return dominant_bgColor;
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


@end
