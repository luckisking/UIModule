//
//  DXLiveInteractionView.m
//  DXLiveSeparation
//
//  Created by doxue_imac on 2019/8/7.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXLiveInteractionView.h"
#import <SPPageMenu/SPPageMenu.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>  //空白页面自动显示
//#import <QuickLook/QuickLook.h>         //pdf查看
#import "DXLiveSubTableViewCell.h"

@interface DXLiveInteractionView ()<SPPageMenuDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UIWebViewDelegate>

//@property (copy, nonatomic)NSURL *pdfFileURL; //PDF文件路径（使用QuickLook本地打开查看）
@property (strong, nonatomic) UIWebView *pdfWebView;    //使用weView浏览pdf文档
@property (strong, nonatomic) UIButton *closePdfButton; //关闭webView
@property (assign, nonatomic) BOOL pdfOPenSuccess; //pdf打开成功

@end

@implementation DXLiveInteractionView

- (instancetype)initWithFrame:(CGRect)frame target:(id)target {
    
    if (self = [super init]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;//告诉系统我将使用自动布局，请忽略我的非自动布局代码
        self.delegate = target;
        [self setupUI];
        
    }
    return self;
}
- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    [self initTableView];
}
- (void)initTableView {
    
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectZero trackerStyle:SPPageMenuTrackerStyleLine];
    [self addSubview:pageMenu];
    [pageMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right).offset(-50);
        make.height.mas_equalTo(44);
    }];
    // 传递数组，默认选中第1个
    [pageMenu setItems:@[@"聊天", @"资料", @"笔记"] selectedItemIndex:0];
    pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
    pageMenu.trackerWidth = 16;
    pageMenu.needTextColorGradients = NO;
    pageMenu.selectedItemTitleColor = RGBHex(0x1CB877);
    pageMenu.unSelectedItemTitleColor = RGBHex(0x333333);
    pageMenu.tracker.backgroundColor = RGBHex(0x1CB877);
    pageMenu.itemTitleFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    pageMenu.dividingLine.hidden = YES;
    // 设置代理
    pageMenu.delegate = (id<SPPageMenuDelegate>)self.delegate;
    
    _segmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _segmentButton.backgroundColor = [UIColor whiteColor];
    [_segmentButton setImage:[UIImage imageNamed:@"live_down"] forState:UIControlStateNormal];
    #pragma GCC diagnostic ignored "-Wundeclared-selector"
    [_segmentButton addTarget:self.delegate action:@selector(segmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_segmentButton];
    [_segmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pageMenu.mas_top);
        make.left.mas_equalTo(pageMenu.mas_right);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(pageMenu.mas_height);
    }];
    
    //scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pageMenu.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
        make.left.mas_equalTo(self.mas_left);
        make.bottom.mas_equalTo(self.mas_bottom).offset(iPhoneX?-34:0);
    }];
    scrollView.backgroundColor = RGBHex(0xF8F9FA);
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    _scrollView = scrollView;
    pageMenu.bridgeScrollView = scrollView;
        //聊天
        UITableView *chatTableView =  [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        chatTableView.delegate = self;
        chatTableView.dataSource = self;
        chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        chatTableView.backgroundColor = RGBHex(0xF8F9FA);
        [scrollView addSubview:chatTableView];
        [chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(scrollView);
            make.bottom.mas_equalTo(scrollView).offset(-44);//避开下方的聊天视图
            make.width.mas_equalTo(scrollView);
        }];
        _chatTableView = chatTableView;
        //资料
        UITableView *fileTableView =  [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        fileTableView.delegate = self;
        fileTableView.dataSource = self;
        fileTableView.backgroundColor = RGBHex(0xF8F9FA);
        fileTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        fileTableView.tableHeaderView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
        fileTableView.tableFooterView = [UIView new];
        [scrollView addSubview:fileTableView];
        [fileTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(scrollView);
            make.left.mas_equalTo(chatTableView.mas_right);
            make.size.mas_equalTo(scrollView);
        }];
        _fileTableView = fileTableView;

        //笔记
        UITableView *noteTableView =  [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        noteTableView.dataSource = self;
        noteTableView.delegate = self;
        noteTableView.backgroundColor = RGBHex(0xF8F9FA);
        noteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        noteTableView.tableHeaderView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        [scrollView addSubview:noteTableView];
        [noteTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(scrollView);//最后一个视图 + width自动撑开contenSize
            make.bottom.mas_equalTo(scrollView).offset(-44);//避开下方的聊天视图
            make.left.mas_equalTo(fileTableView.mas_right);
            make.width.mas_equalTo(scrollView);

        }];
        _noteTableView = noteTableView;
    
        [chatTableView registerClass:[DXLiveChatCell class] forCellReuseIdentifier:@"chatCell"];
        [fileTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"fileCell"];
        [noteTableView registerClass:[DXLiveNewNoteCell class] forCellReuseIdentifier:@"noteCell"];
        fileTableView.emptyDataSetSource = self;
        fileTableView.emptyDataSetDelegate = self;
    
}

#pragma mark tableView的代理方法

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (tableView==_chatTableView) {
        DXLiveChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
        [cell.headImv setImage:[UIImage imageNamed:_imageArray[indexPath.row]]];
        cell.nameLabel.text  = _nameArray[indexPath.row];
        cell.chatString = _chatArray[indexPath.row];
        cell.chatInfoLabel.textLayout = cell.yyLayout;
        cell.chatInfoLabel.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);//设置边距，请在返回heigt的代理方法的高度中加上上下边距
        return cell;
    }else if (tableView==_fileTableView){
        UITableViewCell *cell=[[UITableViewCell alloc]init];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *rightLable= [[UILabel alloc] init];
        rightLable.textAlignment = NSTextAlignmentRight;
        rightLable.textColor = RGBHex(0x666666);
        rightLable.font = [UIFont systemFontOfSize:14];
        rightLable.text = @"点击预览";
        [cell.contentView addSubview:rightLable];
        [rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.contentView);
            make.width.mas_equalTo(100);
            make.right.mas_equalTo(cell.contentView).offset(-10);
        }];
        UILabel *nameLable= [[UILabel alloc] init];
        nameLable.textAlignment = NSTextAlignmentLeft;
        nameLable.textColor = RGBHex(0x101010);
        nameLable.font = [UIFont systemFontOfSize:15];
        nameLable.text = [NSString stringWithFormat:@"%@.pdf",_teach_material_file_title];
        [cell.contentView addSubview:nameLable];
        [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.contentView);
            make.left.mas_equalTo(cell.contentView).offset(10);
            make.right.mas_equalTo(rightLable.mas_left).offset(-5);
        }];
   
        return cell;
    }else {
        DXLiveNewNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noteCell"];
        cell.noteModel = [self.noteListArray objectAtIndex:indexPath.row];

        return cell;
    }

    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==_chatTableView) {
        return self.chatArray.count;
    }else if (tableView==_fileTableView){
        if (self.teach_material_file.length<1&&![self.teach_material_file isEqualToString:@""]) {
            return 0;
        }else{
            return 1;
        }
    }else {
        return self.noteListArray.count;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_chatTableView) {
        DXLiveChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
        cell.chatString = _chatArray[indexPath.row];
        return cell.yyLayout.textBoundingSize.height+37+20;//为37为nameLabel加上上下边距,20为chatInfoLabel上下边距
    }else if (tableView==_fileTableView){
        return 50;
    }else {
        
        DXLiveModuleNoteModel *mode = self.noteListArray[indexPath.row];
        DXLiveNewNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noteCell"];
        cell.stringLayout = mode.note_description;
         if (!mode.screenshot || mode.screenshot.length == 0) {
            return cell.yyLayout.textBoundingSize.height+120;
         }else {
            return cell.yyLayout.textBoundingSize.height+120+44;
         }
     
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _fileTableView) {
        #pragma GCC diagnostic ignored "-Wundeclared-selector"
        [self showPDFwebView];
    }
}

#pragma mark -- 设置数据超过一屏时滚动到底部
- (void)setupDataScrollPositionBottom {
    if (self.chatArray.count) {
        NSIndexPath *chatLastPath = [NSIndexPath indexPathForRow:self.chatArray.count - 1 inSection:0];
        [self.chatTableView scrollToRowAtIndexPath:chatLastPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

#pragma mark - DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"questionblank"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"没有资料,向老师申请吧！";
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:17.0f],
                                 NSForegroundColorAttributeName : RGBAColor(153, 153, 153, 1)
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark -浏览pdf
-(void)webViewDidFinishLoad:(UIWebView*)webView {
    _pdfOPenSuccess  = YES;
    _pdfWebView.hidden  = NO;
    _closePdfButton.hidden  = NO;
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:NO];
    NSLog(@"如果不能开发pdf,尝试下载，解压，在打开%@",error);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"资料文件无法打开，请联系讲师";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
    
    _pdfOPenSuccess  = NO;
    _pdfWebView.hidden = YES;
    _closePdfButton.hidden = YES;

}
- (void)tapClosePdf:(UIButton *)button {
    _pdfWebView.hidden = YES;
    _closePdfButton.hidden = YES;
}
//资料文件使用webView打开
-(void)showPDFwebView {
  
    if (_teach_material_file&& ![_teach_material_file isEqualToString:@""]) {
        NSURL *URL = [NSURL URLWithString:[_teach_material_file stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];

        _pdfWebView.hidden = NO;
        _closePdfButton.hidden = NO;
        if (_pdfOPenSuccess) return;//防止一直点击，每次都请求
        
        //这里一定要使用self，不然可能还没有懒加载,上面不要使用
        [self.pdfWebView loadRequest:request];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    }
}

#pragma mark -- 懒加载

- (NSMutableArray *)chatArray
{
    if (!_chatArray) {
        _chatArray = [[NSMutableArray alloc] init];
    }
    return _chatArray;
}

- (NSMutableArray *)nameArray
{
    if (!_nameArray) {
        _nameArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _nameArray;
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageArray;
}

- (NSMutableArray *)noteListArray
{
    if (!_noteListArray) {
        _noteListArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _noteListArray;
}
- (UIButton *)textButton
{
    if (!_textButton) {
        _textButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _textButton.frame = CGRectMake(15, 8, KScreenWidth - 30, 28.5);
        _textButton.layer.masksToBounds = YES;
        _textButton.layer.cornerRadius = 5.6;
        _textButton.layer.borderWidth = 0.5;
        _textButton.layer.borderColor = live_bottomViewBorderColor.CGColor;
        _textButton.backgroundColor = live_tableViewBgColor;
        _textButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _textButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _textButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_textButton addTarget:self.delegate action:@selector(didSelectChatButton) forControlEvents:UIControlEventTouchUpInside];
        [_textButton setTitleColor:dominant_grayColor forState:UIControlStateNormal];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = live_bottomViewBgColor;
        [self addSubview:view];
        [view addSubview:_textButton];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(iPhoneX?-34:0);
            make.left.and.right.equalTo(self);
            make.height.equalTo(@44);
        }];
    }
    return _textButton;
}

- (UIWebView *)pdfWebView {
    
    if (!_pdfWebView) {
        
        _pdfWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _pdfWebView.delegate = self;
        _pdfWebView.backgroundColor = KWhiteColor;
        _pdfWebView.opaque = NO;
        _pdfWebView.scrollView.showsVerticalScrollIndicator = NO;
        _pdfWebView.scrollView.bounces = NO;
        _pdfWebView.hidden = YES;
        
        [self.scrollView addSubview:_pdfWebView];
        [_pdfWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset(IPHONE_WIDTH);
            make.top.equalTo(self.scrollView);
            make.width.height.equalTo(self.scrollView);
        }];
        _closePdfButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closePdfButton addTarget:self action:@selector(tapClosePdf:) forControlEvents:UIControlEventTouchUpInside];;;
        [_closePdfButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closePdfButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _closePdfButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _closePdfButton.layer.cornerRadius = 8;
        [_closePdfButton setBackgroundColor:[UIColor darkGrayColor]];
        _closePdfButton.hidden = YES;
        
        [self.scrollView addSubview:_closePdfButton];
        [_closePdfButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.scrollView.mas_top).offset(50);
            make.left.equalTo(self.scrollView.mas_left).offset(IPHONE_WIDTH+20);
            make.width.equalTo(@(60));
            make.height.equalTo(@(30));
        }];
    }
    return _pdfWebView;
}
@end
