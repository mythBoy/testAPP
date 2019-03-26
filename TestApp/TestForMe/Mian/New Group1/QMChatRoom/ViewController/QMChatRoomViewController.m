//
//  QMChatRoomViewController.m
//  IMSDK-OC
//
//  Created by HCF on 16/3/9.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import "QMChatRoomViewController.h"
#import "QMChatRoomInputView.h"
#import "TCMessageManagerFaceView.h"
#import "QMChatRoomMoreView.h"
#import <QMChatSDK/QMChatSDK.h>
#import <QMChatSDK/QMChatSDK-Swift.h>
#import "QMRecordIndicatorView.h"
#import "MJRefresh.h"
#import "TZImagePickerController.h"
#import "QMChatRoomShowImageController.h"
#import "QMTapGestureRecognizer.h"
#import "QMChatRoomGuestBookViewController.h"

#import "QMChatRoomTextCell.h"
#import "QMChatRoomVoiceCell.h"
#import "QMChatRoomImageCell.h"
#import "QMChatRoomInvestigateCell.h"
#import "QMChatRoomFileCell.h"
#import "QMChatRoomIframeCell.h"
#import "QMChatRoomCellFactory.h"

#import "QMAudioPlayer.h"
#import "QMAudioRecorder.h"
#import "SJVoiceTransform.h"

//new
#import "QMChatTileView.h"
#import "QMFileManagerController.h"
#import "QMAlert.h"
#import "QMTextAttachment.h"
#import "NSAttributedString+QMEmojiExtension.h"

#import <Photos/Photos.h>
#import "Reachability.h"


/**
    在线客服聊天界面
 */
@interface QMChatRoomViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, TCMessageManagerFaceViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate, AVAudioRecorderDelegate, QMKServiceDelegate, QMAudioRecorderDelegate> {
    
    NSMutableArray * _dataArray;
    NSArray * _investigateArray;
    
    int _dataNum;
    CGFloat _keyboardHigh;
    
    QMChatTileView *_titleView;
    
    
    NSTimer *breakTimer;
    NSTimer *breakTipTimer;
    
    CGFloat _navHeight;
}


@property (nonatomic, assign)float upProgress;

@end

@implementation QMChatRoomViewController

#pragma mark - 生命周期
// 注册通知
-(instancetype)init {
    self = [super init];
    if (self) {
        // 建议使用willshow和willhide
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewReload:) name:CHATMSG_RELOAD object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(robotAction) name:ROBOT_SERVICE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customOnline) name:CUSTOMSRV_ONLINE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customOffline) name:CUSTOMSRV_OFFLINE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customClaim) name:CUSTOMSRV_CLAIM object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customFinish) name:CUSTOMSRV_FINISH object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customQueue:) name:CUSTOMSRV_QUEUENUM object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customAgentMessage:) name:CUSTOMSRV_AGENT object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customInvestigate) name:CUSTOMSRV_INVESTIGATE object:nil];
    }
    return self;
}

// 基本配置
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:246/255.0 green:248/255.0 blue:249/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:13/255.0 green:139/255.0 blue:249/255.0 alpha:1];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = NO;
}

// 开始会话
- (void)viewDidAppear:(BOOL)animated {
    if (self.isPush == NO) {
        __weak QMChatRoomViewController * myChatView = self;
        [QMConnect sdkBeginNewChatSession:self.peerId successBlock:^(BOOL remark) {
            NSLog(@"开始会话成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                // 是否启动了评价功能
                if (remark == NO) {
                    myChatView.addView.evaluateBtn.hidden = YES;
                    myChatView.addView.evaluateLabel.hidden = YES;
                }else {
                    myChatView.addView.evaluateBtn.hidden = NO;
                    myChatView.addView.evaluateLabel.hidden = NO;
                }
            });
        } failBlock:^{
            NSLog(@"开始会话失败");
        }];
        self.isPush = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 网络监控
    Reachability *hostReach = [Reachability reachabilityForInternetConnection];
    hostReach.reachableBlock = ^(Reachability *reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 网络连接
            
        });
    };
    hostReach.unreachableBlock = ^(Reachability *reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 网络断开
            
        });
    };
    [hostReach startNotifier];
    
    [self getInvestigateData];
    [self createUI];
    
    _dataArray = [[NSMutableArray alloc]init];
    if (_dataNum == 0) {
        _dataNum = 10;
    }
    
    [self getData];
    [self.chatTableView reloadData];
    [self scrollToEnd];
    
    [self createNSTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([self.chatInputView.inputView isFirstResponder]) {
        [self.chatInputView.inputView resignFirstResponder];
        self.chatInputView.inputView.inputView = nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"Appear");
}

// 移除通知
- (void)dealloc {
    NSLog(@"销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 创建聊天室UI(消息列表、输入工具条、提示窗...)
- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect NavRect = self.navigationController.navigationBar.frame;
    _navHeight = StatusRect.size.height + NavRect.size.height;
    
    // 坐席信息提示
    _titleView = [[QMChatTileView alloc] initWithFrame: CGRectMake(0, 0, 150, 40)];
    _titleView.nameLabel.text = @"客服";
    _titleView.stateInfoLabel.text = @"等待连接";
    _titleView.intrinsicContentSize = CGSizeMake(150, 40);
    self.navigationItem.titleView = _titleView;
    
    // 消息列表
    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kInputViewHeight-_navHeight) style:UITableViewStylePlain];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatTableView.backgroundColor = [UIColor whiteColor];
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.chatTableView];
    
    __weak QMChatRoomViewController * myChatView = self;
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [myChatView Refresh];
    }];
    [mj_header.lastUpdatedTimeLabel setHidden:true];
    self.chatTableView.mj_header = mj_header;
    
    // 输入工具条
    self.chatInputView = [[QMChatRoomInputView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kInputViewHeight-_navHeight, kScreenWidth, kInputViewHeight)];
    [self.chatInputView.voiceButton addTarget:self action:@selector(voiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.chatInputView.faceButton addTarget:self action:@selector(faceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.chatInputView.addButton addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.chatInputView.RecordBtn addTarget:self action:@selector(cancelRecord:) forControlEvents:UIControlEventTouchUpOutside];
    [self.chatInputView.RecordBtn addTarget:self action:@selector(RecordBtnBegin:) forControlEvents:UIControlEventTouchDown];
    [self.chatInputView.RecordBtn addTarget:self action:@selector(RecordBtnEnd:) forControlEvents:UIControlEventTouchUpInside];
    [self.chatInputView.RecordBtn addTarget:self action:@selector(RecordBtnExit:) forControlEvents:UIControlEventTouchDragExit];
    [self.chatInputView.RecordBtn addTarget:self action:@selector(RecordBtnEnter:) forControlEvents:UIControlEventTouchDragEnter];
    self.chatInputView.inputView.delegate = self;
    [self.view addSubview:self.chatInputView];
    
    // 表情面板
    self.faceView = [[TCMessageManagerFaceView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, kScreenWidth, QM_IS_IPHONEX ? 250 : 216)];
    self.faceView.delegate = self;
    [self.faceView.sendButton addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 扩展面板
    self.addView = [[QMChatRoomMoreView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, kScreenWidth, (QM_IS_IPHONEX ? 144 : 110))];
    [self.addView.takePicBtn addTarget:self action:@selector(takePicBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.addView.evaluateBtn addTarget:self action:@selector(evaluateBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.addView.takeFileBtn addTarget:self action:@selector(takeFileBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 转人工
    self.manualButotn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.manualButotn.frame = CGRectMake(0, 0, 60, 30);
    self.manualButotn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.manualButotn setTitle:@"转人工" forState:UIControlStateNormal];
    [self.manualButotn setTitleColor:[UIColor colorWithRed:13/255.0 green:139/255.0 blue:249/255.0 alpha:1] forState:UIControlStateNormal];
    [self.manualButotn addTarget:self action:@selector(customClick) forControlEvents:UIControlEventTouchUpInside];
    if ([QMConnect allowRobot]) {
        self.isRobot = true;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.manualButotn];
    }else {
        self.isRobot = false;
    }
    
    // 注销
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.logoutButton.frame = CGRectMake(0, 0, 50, 30);
    self.logoutButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.logoutButton setTitle:@"注销" forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:[UIColor colorWithRed:13/255.0 green:139/255.0 blue:249/255.0 alpha:1] forState:UIControlStateNormal];
    [self.logoutButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.logoutButton];
    
    self.indicatorView = [[QMRecordIndicatorView alloc] init];
    self.indicatorView.frame = CGRectMake((kScreenWidth-150)/2, (kScreenHeight-150-_navHeight-50)/2, 150, 150);
    
    UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.chatTableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
}

- (void)hideKeyboard {
    [self.chatInputView.inputView resignFirstResponder];
    self.chatInputView.inputView.inputView = nil;
}

#pragma mark - 获取数据(数据模型已存储本地)
// 获取消息数据
- (void)getData {
    _dataArray = [NSMutableArray arrayWithArray:[QMConnect getDataFromDatabase:_dataNum]];
}

// 获取后台配置信息 、 满意度调查 、回复超时时间
- (void)getInvestigateData {
    [QMConnect sdkGetInvestigate:^(NSArray * _Nonnull investigateArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _investigateArray = investigateArray;

        });
    } failureBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            _investigateArray = [NSArray array];
        });
    }];
}

// 刷新TableView
-(void)reloadTableView {
    NSLog(@"刷新信息");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.chatTableView reloadData];
        [self scrollToEnd];
    });
}

// 消息通知、发送和接收的消息 都会走这个通知 统一刷新聊天界面
- (void)getNewReload: (NSNotification *)sender {
    NSLog(@"获取到新消息 %@", sender.object);
    [self getData];
    [self reloadTableView];
}


// 滑动到底部
- (void)scrollToEnd {
    if (_dataArray.count>0) {
        [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
}

// 下拉刷新
- (void)Refresh {
    if (_dataNum>_dataArray.count) {
        
    }
    _dataNum = _dataNum+10;
    [self getData];
    [_chatTableView reloadData];
    [self.chatTableView.mj_header endRefreshing];
}

- (void)applicationWillResignActive {
    NSLog(@"退到后台");
}

- (void)applicationDidBecomeActive {
    NSLog(@"返回前台");
}

#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomMessage * message = _dataArray[_dataArray.count-indexPath.row-1];
    
    NSString * identifier = @"";
    if ([message.messageType isEqualToString:@"text"]) {
        identifier = NSStringFromClass([QMChatRoomTextCell class]);
    }else if ([message.messageType isEqualToString:@"voice"]) {
        identifier = NSStringFromClass([QMChatRoomVoiceCell class]);
    }else if ([message.messageType isEqualToString:@"image"]) {
        identifier = NSStringFromClass([QMChatRoomImageCell class]);
    }else if ([message.messageType isEqualToString:@"investigate"]) {
        identifier = NSStringFromClass([QMChatRoomInvestigateCell class]);
    }else if ([message.messageType isEqualToString:@"file"]) {
        identifier = NSStringFromClass([QMChatRoomFileCell class]);
    }else if ([message.messageType isEqualToString:@"iframe"]) {
        identifier = NSStringFromClass([QMChatRoomIframeCell class]);
    }
    
    QMChatRoomBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [QMChatRoomCellFactory createCellWithClassName:identifier cellModel:message indexPath:indexPath];
    }
    
    if (indexPath.row>0) {
        CustomMessage * preMessage = _dataArray[_dataArray.count-indexPath.row];
        UInt64 disTime = message.createdTime.longLongValue - preMessage.createdTime.longLongValue;
        if (disTime<3*60*1000) {
            cell.timeLabel.hidden = YES;
        }else {
            cell.timeLabel.hidden = NO;
        }
    }else {
        cell.timeLabel.hidden = NO;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 如果需要设置头像、该方法加上一个头像路径参数
    [cell setData:message avater:self.avaterStr];
    if ([message.messageType isEqualToString:@"file"]) {
        [cell setProgress: self.upProgress];
    }
    if ([message.messageType isEqualToString:@"text"]) {
        __weak QMChatRoomViewController *weakSelf = self;
        cell.tapSendMessage = ^(NSString *text) {
            [weakSelf sendText:text];
        };
        cell.didBtnAction = ^(BOOL isUseful) {
            if (!message.isUseful||[message.isUseful isEqualToString:@"none"]) {
                [weakSelf sendRobotFeedback:isUseful questionId:message.questionId messageId:message._id];
            }
        };
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 15;
    CustomMessage * message = _dataArray[_dataArray.count-indexPath.row-1];
    
    if (indexPath.row>0) {
        CustomMessage * preMessage = _dataArray[_dataArray.count-indexPath.row];
        UInt64 disTime = message.createdTime.longLongValue - preMessage.createdTime.longLongValue;
        if (disTime<3*60*1000) {
            height = 15;
        }else {
            height = 45;
        }
    }else {
        height = 45;
    }
    
    if ([message.messageType isEqualToString:@"text"]) {
        MLEmojiLabel *textLabel = [MLEmojiLabel new];
        textLabel.customEmojiRegex = @"\\:[^\\:]+\\:";
        textLabel.customEmojiPlistName = @"expressionImage.plist";

        textLabel.text = message.message;
        CGSize size = [textLabel preferredSizeWithMaxWidth: [UIScreen mainScreen].bounds.size.width - 160];
        textLabel.frame = CGRectMake(15, 10, size.width, size.height+5);
        
        height += (textLabel.frame.size.height+21);
        height = height>65?height:65;
        if ([message.isRobot isEqualToString:@"1"] && ![message.questionId isEqualToString:@""]) {
            if (message.isUseful) {
                if ([message.isUseful isEqualToString:@"none"]) {
                    height += 30;
                }else {
                    height += 60;
                }
            }else {
                height += 30;
            }
        }
    }else if ([message.messageType isEqualToString:@"voice"]) {
        height += 45;
    }else if ([message.messageType isEqualToString:@"image"]) {
        height += 140;
    }else if ([message.messageType isEqualToString:@"investigate"]) {
        height += 145;
    }else if ([message.messageType isEqualToString:@"file"]) {
        height += 50;
    }else if ([message.messageType isEqualToString:@"iframe"]) {
        height += message.height.intValue+30;
    }else {
        height += 45;
    }
    return height;
}

#pragma mark - InputView Action
//切换录音按钮
- (void)voiceBtnAction:(UIButton *)button {
    if (self.chatInputView.RecordBtn.hidden == YES) {
        [self.chatInputView showRecordButton:YES];
        [self.chatInputView.inputView endEditing:YES];
    }else {
        [self.chatInputView showRecordButton:NO];
        self.chatInputView.inputView.inputView = nil;
        [self.chatInputView.inputView becomeFirstResponder];
        [self.chatInputView.inputView reloadInputViews];
    }
}

//表情按钮
- (void)faceBtnAction:(UIButton *)button {
    if (button.tag == 1) {
        [self.chatInputView showEmotionView:YES];
        self.chatInputView.inputView.inputView = self.faceView;
    }else {
        [self.chatInputView showEmotionView:NO];
        self.chatInputView.inputView.inputView = nil;
    }
    [self.chatInputView.inputView becomeFirstResponder];
    [self.chatInputView.inputView reloadInputViews];
}

//扩展功能按钮
- (void)addBtnAction:(UIButton *)button {
    if (button.tag == 3) {
        [self.chatInputView showMoreView:YES];
        self.chatInputView.inputView.inputView = self.addView;
        [self.chatInputView.inputView becomeFirstResponder];
        [self.chatInputView.inputView reloadInputViews];
    }else {
        [self.chatInputView showMoreView:NO];
        self.chatInputView.inputView.inputView = nil;
        [self.chatInputView.inputView endEditing:YES];
    }
}

#pragma mark - Record Action
// 开始录音
- (void)RecordBtnBegin:(UIButton *)button {
    NSString *fileName = [[NSUUID new] UUIDString];
    // 验证权限
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authorizationStatus) {
        case AVAuthorizationStatusNotDetermined:
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                
            }];
            break;
        case AVAuthorizationStatusAuthorized:
            self.indicatorView.isCount = false;
            [self.indicatorView changeViewStatus:QMIndicatorStatusNormal];
            [self.view addSubview:self.indicatorView];
            [self changeButtonStatus:YES];
            [[QMAudioRecorder sharedInstance] startAudioRecord:fileName maxDuration:60.0 delegate:self];
            break;
        case AVAuthorizationStatusRestricted:
            NSLog(@"麦克风访问受限!");
            break;
        case AVAuthorizationStatusDenied:
            NSLog(@"设置允许访问麦克风");
            break;
    }
}

// 结束录音
- (void)RecordBtnEnd:(UIButton *)button {
    [[QMAudioRecorder sharedInstance] stopAudioRecord];
}

// 取消录音
- (void)cancelRecord: (UIButton *)button {
    [[QMAudioRecorder sharedInstance] cancelAudioRecord];
    [self.indicatorView removeFromSuperview];
    [self changeButtonStatus:NO];
}

- (void)RecordBtnExit: (UIButton *)button {
    [self.indicatorView changeViewStatus:QMIndicatorStatusCancel];
}

- (void)RecordBtnEnter: (UIButton *)button {
    [self.indicatorView changeViewStatus:QMIndicatorStatusNormal];
}

// 更改按钮状态
- (void)changeButtonStatus:(BOOL)down {
    if (down == YES) {
        [self.chatInputView.RecordBtn setTitle:@"松开    发送" forState:UIControlStateNormal];
        [self.chatInputView.RecordBtn setTitleColor:[UIColor colorWithRed:50/255.0f green:167/255.0f blue:255/255.0f alpha:1.0] forState:UIControlStateNormal];
        self.chatInputView.RecordBtn.layer.borderColor = [[UIColor colorWithRed:50/255.0f green:167/255.0f blue:255/255.0f alpha:1.0] CGColor];
        [self.chatInputView.RecordBtn setTintColor:[UIColor colorWithRed:50/255.0f green:167/255.0f blue:255/255.0f alpha:1.0]];
    }else {
        [self.chatInputView.RecordBtn setTitle:@"按住    说话" forState:UIControlStateNormal];
        [self.chatInputView.RecordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.chatInputView.RecordBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    }
}

- (void)audioRecorderStart {
    
}

- (void)audioRecorderCompletion:(NSString *)fileName duration:(NSString *)duration {
    NSString * path = [NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(),@"Documents",fileName];
    [SJVoiceTransform stransformToMp3ByUrlWithUrl:path];
    [self sendAudio:fileName duration:duration];
    if (duration.intValue >= 60) {
        [self.indicatorView changeViewStatus:QMIndicatorStatusLong];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.indicatorView removeFromSuperview];
            [self changeButtonStatus:NO];
        });
    }else {
        [self.indicatorView removeFromSuperview];
        [self changeButtonStatus:NO];
    }
}

- (void)audioRecorderChangeInTimer:(NSTimeInterval)power total:(int)count {
    [self.indicatorView updateImageWithPower:power];
    self.indicatorView.count = count;
}

- (void)audioRecorderCancel {
    [self.indicatorView removeFromSuperview];
    [self changeButtonStatus:NO];
}

- (void)audioRecorderFail {
    [self.indicatorView changeViewStatus:QMIndicatorStatusShort];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.indicatorView removeFromSuperview];
        [self changeButtonStatus:NO];
    });
}

#pragma mark - MoreView Action
//通过摄像头获取图片
- (void)photoBtnAction {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

//相机代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImage * myImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:nil];
        UIImageWriteToSavedPhotosAlbum(myImage, nil, nil, nil);
        [self sendImage:myImage];
    }
}

//从相册获取图片
- (void)takePicBtnAction {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 delegate:nil];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isStop) {
        for (UIImage *image in photos) {
            [self sendImage:image];
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

// 获取文件
- (void)takeFileBtnAction {
    QMFileManagerController * fileViewController = [[QMFileManagerController alloc] init];
    [self.navigationController pushViewController:fileViewController animated:true];
}

// 满意度评价
- (void)evaluateBtnAction {
    UIAlertController * investigateAlertView = [UIAlertController alertControllerWithTitle:@"评价" message:nil preferredStyle:UIAlertControllerStyleAlert];
    for (NSDictionary * index in _investigateArray) {
        UIAlertAction * action = [UIAlertAction actionWithTitle:[index objectForKey:@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [QMConnect sdkSubmitInvestigate:[index objectForKey:@"name"] value:[index objectForKey:@"value"] successBlock:^{
                NSLog(@"评价成功");
            } failBlock:^{
                NSLog(@"评价失败");
            }];
        }];
        [investigateAlertView addAction:action];
    }
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [investigateAlertView addAction:cancelAction];
    [self presentViewController:investigateAlertView animated:YES completion:nil];
}

#pragma mark - Send Message
// 发送文本
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqual:@"\n"]) {
        if (![_chatInputView.inputView.text isEqualToString:@""]) {
            NSString *text = [_chatInputView.inputView.textStorage getRichString];
            [self sendText:text];
            _chatInputView.inputView.text = @"";
            return NO;
        }
        return NO;
    }
    return  YES;
}

//发送表情
- (void)sendBtnAction:(UIButton *)button  {
    if (![_chatInputView.inputView.text isEqualToString:@""]) {
        NSString *text = [_chatInputView.inputView.textStorage getRichString];
        [self sendText:text];
        _chatInputView.inputView.text = @"";
    }
}

- (void)sendText:(NSString *)text {
    [QMConnect sendMsgText:text successBlock:^{
        NSLog(@"发送成功");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createNSTimer];
        });
    } failBlock:^{
        NSLog(@"发送失败");
    }];
}

// 发送图片
- (void)sendImage:(UIImage *)image {
    [QMConnect sendMsgPic:image successBlock:^{
        NSLog(@"图片发送成功");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createNSTimer];
        });
    } failBlock:^{
        NSLog(@"图片发送失败");
    }];
}

// 发送语音
- (void)sendAudio:(NSString *)fileName duration:(NSString *)duration {
    NSString *filePath = [NSString stringWithFormat:@"%@.mp3", fileName];
    [QMConnect sendMsgAudio:filePath duration:duration successBlock:^{
        NSLog(@"语音发送成功");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createNSTimer];
        });
    } failBlock:^(NSString * _Nonnull reason) {
        NSLog(@"语音发送失败");
    }];
}

// 发送文件消息
- (void)sendFileMessageWithName:(NSString *)fileName AndSize:(NSString *)fileSize AndPath:(NSString *)filePath {
    [QMConnect sendMsgFile:fileName filePath:filePath fileSize:fileSize progressHander:^(float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.upProgress = progress;
            [self.chatTableView reloadData];
        });
    } successBlock:^{
        NSLog(@"文件上传成功");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createNSTimer];
            self.upProgress = 0;
        });
    } failBlock:^{
        NSLog(@"文件上传失败");
        dispatch_async(dispatch_get_main_queue(), ^{
            self.upProgress = 0;
        });
    }];
}

// 失败消息重新发送
- (void)resendAction:(QMTapGestureRecognizer *)gestureRecognizer {
    NSArray * dataArray = [[NSArray alloc] init];
    dataArray = [QMConnect getOneDataFromDatabase:gestureRecognizer.messageId];
    for (CustomMessage * custom in dataArray) {
        [QMConnect resendMessage:custom successBlock:^{
            NSLog(@"重新发送成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self createNSTimer];
            });
        } failBlock:^{
            NSLog(@"重新发送失败");
        }];
    }
}

// 表情代理及相关处理
- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele {
    if (dele) {
        [_chatInputView.inputView deleteBackward];
    }else {
        [self insertEmoji:faceStr];
    }
}

- (void)insertEmoji: (NSString *)code {
    QMTextAttachment * emojiTextAttemt = [QMTextAttachment new];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"QMEmoticon" ofType:@"bundle"];
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"expressionImage" ofType:@"plist"];
    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:fileName];
    
    if ([plistDict objectForKey:code] != nil) {
        emojiTextAttemt.emojiCode = code;
        emojiTextAttemt.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@", bundlePath, [plistDict objectForKey:code]]];
        emojiTextAttemt.bounds = CGRectMake(0, 0, 18, 18);
        
        NSAttributedString * attributeString = [NSAttributedString attributedStringWithAttachment:emojiTextAttemt];
        NSRange range = [_chatInputView.inputView selectedRange];
        if (range.length > 0) {
            [_chatInputView.inputView.textStorage deleteCharactersInRange:range];
        }
        
        [_chatInputView.inputView.textStorage insertAttributedString:attributeString atIndex:[_chatInputView.inputView selectedRange].location];
        _chatInputView.inputView.selectedRange = NSMakeRange(_chatInputView.inputView.selectedRange.location+1, 0);
    }
    
    [self resetTextStyle];
}

// 机器人帮助评价
- (void)sendRobotFeedback: (BOOL)isUseful questionId: (NSString *)questionId messageId: (NSString *)messageId {
    __weak QMChatRoomViewController *weakSelf = self;
    [QMConnect sdkSubmitRobotFeedback:isUseful questionId:questionId messageId:messageId successBlock:^{
        [weakSelf getData];
        [weakSelf.chatTableView reloadData];
    } failBlock:^{
        
    }];
}

- (void)resetTextStyle {
    NSRange wholeRange = NSMakeRange(0, _chatInputView.inputView.textStorage.length);
    [_chatInputView.inputView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [_chatInputView.inputView.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:wholeRange];
    _chatInputView.inputView.font = [UIFont systemFontOfSize:18];
}

#pragma mark - Multi Function
// 注销事件
- (void)logoutAction {
    [[QMAudioPlayer sharedInstance] stopAudioPlayer];
    [QMConnect logout];
    [self removeTimer];
    [self.navigationController popViewControllerAnimated:YES];
}

// 转人工客服
- (void)customClick {
    [QMConnect sdkConvertManual:^{
        NSLog(@"转人工客服成功");
    } failBlock:^{
        NSLog(@"转人工客服失败");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showGuestBookViewController];
        });
    }];
}

#pragma mark - 留言提示
- (void)showGuestBookViewController {
    [self.chatInputView setHidden:true];
    [self.manualButotn setHidden:true];
    self.chatTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - _navHeight);
    
    self.msg = [QMConnect leaveMessageAlert];
    if ([self.msg isEqualToString:@""]) {
        self.msg = @"客服目前已离线，请稍后咨询";
    }

    if ([QMConnect allowedLeaveMessage]) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"" message: self.msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"留言" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            QMChatRoomGuestBookViewController *guestBookViewController = [[QMChatRoomGuestBookViewController alloc] init];
            guestBookViewController.peerId = self.peerId;
            [self.navigationController pushViewController:guestBookViewController animated:YES];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self logoutAction];
        }];
        [alertView addAction:sureAction];
        [alertView addAction:cancel];
        [self presentViewController:alertView animated:YES completion:nil];
    }else {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"" message: self.msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertView addAction:cancel];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}

#pragma mark - 客服代理方法
/// 当前客服状态
- (void)currentAgentStatusWithStatus:(enum QMKStatus)status {
    switch (status) {
        case 0:
            _titleView.stateInfoLabel.text = @"机器人客服";
            self.manualButotn.hidden = NO;
            break;
        case 1:
            _titleView.stateInfoLabel.text = @"客服在线";
            self.manualButotn.hidden = YES;
            break;
        case 2:
            _titleView.stateInfoLabel.text = @"客服离线";
            self.manualButotn.hidden = NO;
            break;
        case 3:
            _titleView.stateInfoLabel.text = @"客服在线";
            self.manualButotn.hidden = YES;
            break;
        case 4:
            _titleView.stateInfoLabel.text = @"客服结束会话";
            break;
        default:
            break;
    }
}

/// 当前坐席信息
- (void)currentAgentInfoWithAgent:(QMAgent * _Nonnull)agent {
    NSString *string = [NSString stringWithFormat:@"%@(%@)", agent.name, agent.exten];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    _titleView.nameLabel.text = [NSString stringWithFormat:@"%@",string];
}

/// 当前会话排队数
- (void)currentSessionWaitNumberWithNumber:(NSInteger)number {
    _titleView.stateInfoLabel.text = [NSString stringWithFormat:@"目前排队人数: %ld", (long)number];
    self.manualButotn.hidden = YES;
}

/// 邀请评价
- (void)inviteEvaluate {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"" message:@"满意度评价" preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSDictionary *index in _investigateArray) {
        [alertController addAction:[UIAlertAction actionWithTitle:[index objectForKey:@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [QMConnect sdkSubmitInvestigate:[index objectForKey:@"name"] value:[index objectForKey:@"value"] successBlock:^{
                NSLog(@"评价成功");
            } failBlock:^{
                NSLog(@"评价失败");
            }];
        }]];
    };
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - Push Notification
// 键盘通知
- (void)keyboardFrameChange: (NSNotification *)notification {
    NSDictionary * userInfo =  notification.userInfo;
    NSValue * value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect newFrame = [value CGRectValue];
    if (newFrame.origin.y == [UIScreen mainScreen].bounds.size.height) {
        [UIView animateWithDuration:0.3 animations:^{
            self.chatInputView.frame = CGRectMake(0, kScreenHeight-kInputViewHeight-_navHeight, kScreenWidth, kInputViewHeight);
            self.chatTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-_navHeight-kInputViewHeight);
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.chatInputView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-kInputViewHeight-newFrame.size.height-_navHeight, kScreenWidth, kInputViewHeight);
            self.chatTableView.frame = CGRectMake(0, 0, kScreenWidth, [UIScreen mainScreen].bounds.size.height-_navHeight-kInputViewHeight-newFrame.size.height);
            [self scrollToEnd];
        }];
    }
}

// 机器人客服
- (void)robotAction {
    NSLog(@"机器人客服");
    _titleView.stateInfoLabel.text = @"机器人客服";
    self.manualButotn.hidden = NO;
    self.isRobot = YES;
}

// 客服在线
- (void)customOnline {
    NSLog(@"客服在线");
    _titleView.stateInfoLabel.text = @"客服在线";
    self.manualButotn.hidden = YES;
    self.isRobot = NO;
    [self createNSTimer];
}

// 客服离线
- (void)customOffline {
    NSLog(@"客服离线");
    self.manualButotn.hidden = NO;
    _titleView.stateInfoLabel.text = @"客服离线";
    [self showGuestBookViewController];
}

// 会话领取
- (void)customClaim {
    NSLog(@"会话被坐席领取");
    _titleView.stateInfoLabel.text = @"客服在线";
    self.manualButotn.hidden = YES;
    self.isRobot = NO;
}

// 离线推送 （坐席在后台结束会话，返回上一界面）
- (void)customFinish {
    NSLog(@"客服结束会话");
    [self.chatInputView setHidden:true];
    self.chatTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - _navHeight);
    _titleView.stateInfoLabel.text = @"客服结束会话";
}

// 排队人数
- (void)customQueue: (NSNotification *)notification {
    NSLog(@"排队人数 %@", notification.object);
    _titleView.stateInfoLabel.text = [NSString stringWithFormat:@"目前排队人数: %@", notification.object];
    self.manualButotn.hidden = YES;
}

// 满意度推送
- (void)customInvestigate {
    NSLog(@"满意度通知");
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"" message:@"满意度评价" preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSDictionary *index in _investigateArray) {
        [alertController addAction:[UIAlertAction actionWithTitle:[index objectForKey:@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [QMConnect sdkSubmitInvestigate:[index objectForKey:@"name"] value:[index objectForKey:@"value"] successBlock:^{
                NSLog(@"评价成功");
            } failBlock:^{
                NSLog(@"评价失败");
            }];
        }]];
    };
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
    [self presentViewController:alertController animated:true completion:nil];
}

// 坐席信息 (坐席工号、坐席名称、坐席头像) 可能为空字符串需要判断
- (void)customAgentMessage: (NSNotification *)notification {
    QMAgent *agent = notification.object;
    NSString *string;
    if ([agent.type isEqualToString:@"robot"]) {
        string = [NSString stringWithFormat:@"%@", agent.name];
    }else {
        string = [NSString stringWithFormat:@"%@(%@)", agent.name, agent.exten];
    }
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    _titleView.nameLabel.text = [NSString stringWithFormat:@"%@",string];
}

// 访客无响应断开计时
- (void)createNSTimer{
    NSLog(@"开启无响应定时器");
//    [self removeTimer];
//    self.breakDuration = [QMConnect breakSessionDuration];
//    self.breakTipsDuration = [QMConnect breakSessionAlertDuration];
//    if (self.breakDuration && self.breakTipsDuration && [QMConnect allowedBreakSession]) {
//        breakTipTimer = [NSTimer scheduledTimerWithTimeInterval:self.breakTipsDuration * 60 target:self selector:@selector(breakTipTimerAction:) userInfo:nil repeats:NO];
//        breakTimer = [NSTimer scheduledTimerWithTimeInterval:self.breakDuration * 60 target:self selector:@selector(breakTimerAction:) userInfo:nil repeats:NO];
//        [[NSRunLoop mainRunLoop] addTimer:breakTimer forMode:NSRunLoopCommonModes];
//        [[NSRunLoop mainRunLoop] addTimer:breakTipTimer forMode:NSRunLoopCommonModes];
//    }
}

- (void)removeTimer {
    if (breakTipTimer) {
        [breakTipTimer invalidate];
        breakTipTimer = nil;
    }
    if (breakTimer) {
        [breakTimer invalidate];
        breakTimer = nil;
    }
}

- (void)breakTimerAction:(NSTimer *)time{
//    [self logoutAction];
    [self.chatInputView setHidden:true];
    [self.manualButotn setHidden:true];
    self.chatTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - _navHeight);
}

- (void)breakTipTimerAction:(NSTimer *)timer{
    [QMAlert showMessage:[QMConnect breakSessionAlert]];
    [breakTipTimer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
