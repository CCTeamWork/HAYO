//
//  ViewController.m
//  DuoFang
//
//  Created by Zhuge_Su on 2017/3/22.
//  Copyright © 2017年 Zhuge_Su. All rights reserved.
//

#import "ViewController.h"
#import "VideoController.h"
#import "PermissionTool.h"
#import "NTESGLView.h"


#define ACC1 @"abc_123"
#define PWD1 @"simidahaha"

#define ACC2 @"qwe_gaga"
#define PWD2 @"qwehaha"

#define MeetingName @"821437"

@interface ViewController ()<NIMNetCallManagerDelegate>
@property (nonatomic , weak) CALayer *localVideoLayer;
@property (nonatomic , strong)NTESGLView *videoView;

@end

//static NIMNetCallMeeting *meeting;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
    
    [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];

    self.videoView = [[NTESGLView alloc] initWithFrame:CGRectZero];
    _videoView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [self.view addSubview:self.videoView];
    
    [self btn1Login];
    [self meetingRoomStatus];
    [self controlVaBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _videoView.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)btn1Login{
    NSArray *accArr = @[@"账号1",@"账号2"];
    for (int i = 0; i < 2; i++) {
        UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        testBtn.frame = CGRectMake(50 + (200 * i), 64+20, 100, 30);
        testBtn.backgroundColor = [UIColor blueColor];
        testBtn.tag = i;
        [testBtn setTitle:accArr[i] forState:UIControlStateNormal];
        [testBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:testBtn];
        [testBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
  }

- (void)btnClick:(UIButton *)sender{
    if (sender.tag == 0) {
        [self MSULogWithAccount:ACC1 PWD:PWD1];

    }else{
        [self MSULogWithAccount:ACC2 PWD:PWD2];
    }
}


- (void)meetingRoomStatus{
    NSArray *staArr = @[@"创建会议",@"申请加入"];
    for (int i = 0; i < 2; i++) {
        UIButton *staBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        staBtn.frame = CGRectMake(150, 64+20+50 + 50 * i, 100, 30);
        staBtn.tag = 10+i;
        [staBtn setTitle:staArr[i] forState:UIControlStateNormal];
        staBtn.backgroundColor = [UIColor blueColor];
        [self.view addSubview:staBtn];
        [staBtn addTarget:self action:@selector(staBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void)staBtnClick:(UIButton *)sender{
    if (sender.tag == 10) {
        [self reserveMeetingWithRoomId:MeetingName];
    }else{
        [self MSUApplyForJoin];
    }
}

- (void)controlVaBtn{
    NSArray *vaArr = @[@"视频开关",@"音频开关",@"听筒切换",@"摄像头切换",@"成为主播"];
    for (int i = 0; i < vaArr.count; i++) {
        UIButton *vaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        vaBtn.frame = CGRectMake(50, 270 + 50*i, 100, 30);
        vaBtn.tag = 20+i;
        vaBtn.backgroundColor = [UIColor blueColor];
        [vaBtn setTitle:vaArr[i] forState:UIControlStateNormal];
        [self.view addSubview:vaBtn];
        [vaBtn addTarget:self action:@selector(vaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)vaBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case 20:
        {
            if (sender.selected) {
                [self MSUNetCallManagerCloseVideo];
            }else{
                [self MSUNetCallManagerOpenVideo];
            }
            
        }
            break;
        case 21:
        {
            if (sender.selected) {
                [self MSUNetCallManagerOpenMute];
            }else{
                [self MSUNetCallManagerCloseMute];
            }
            
        }
            break;
        case 22:
        {
            if (sender.selected) {
                [self MSUNetCallManagerOpenSpeaker];
            }else{
                [self MSUNetCallManagerCloseSpeaker];
            }
        }
            break;
        case 23:
        {
            if (sender.selected) {
                [self MSUNetCallManagerOpenBackCamera];
            }else{
                [self MSUNetCallManagerOpenFrontCamera];
            }
        }
            break;
        case 24:
        {
            if (sender.selected) {
                [[NIMAVChatSDK sharedSDK].netCallManager setMeetingRole:YES];
            }else{
                [[NIMAVChatSDK sharedSDK].netCallManager setMeetingRole:NO];
            }
        }
            
        default:
            break;
    }
}

/*===========================================================================================*/
- (void)createLeaveBtn{
    UIButton *leavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leavBtn.frame = CGRectMake(150, 64+20+30+20+30+20+30+20, 100, 30);
    leavBtn.backgroundColor = [UIColor blueColor];
    [leavBtn setTitle:@"离开会议" forState:UIControlStateNormal];
    [leavBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leavBtn addTarget:self action:@selector(leavBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:leavBtn];
}

- (void)leavBtnClick:(UIButton *)sender{
    [self MSUNetCallManagerLeaveMeeting];
    [sender removeFromSuperview];
    [_localVideoLayer removeFromSuperlayer];
    _videoView.backgroundColor =[UIColor clearColor];
    _videoView.layer.backgroundColor =(__bridge CGColorRef _Nullable)([UIColor clearColor]);
}

#pragma mark - 方法实现
/*
 **登录
*/
- (void)MSULogWithAccount:(NSString *)account PWD:(NSString *)pwd{
    [[[NIMSDK sharedSDK] loginManager] login:account token:pwd completion:^(NSError * _Nullable error) {
        if (error) {
            SLog(@"账户error=%@", error);
            
        } else {
            SLog(@"账户登录成功");
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
        }
    }];
}

/*
 **申请加入
*/
- (void)MSUApplyForJoin{
    [PermissionTool getCamerasPermission:^(NSInteger authStatus) {
        [PermissionTool getMicrophonePermission:^(NSInteger authStatus) {
            if (authStatus == 1) {
                NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
                meeting.name = MeetingName;
                [self joinNetCallWithRMeeting:meeting];
            }
        }];
    }];
}

/*
 **预约会议
*/
- (void)reserveMeetingWithRoomId:(NSString *)roomId{
    [PermissionTool getCamerasPermission:^(NSInteger authStatus) {
        [PermissionTool getMicrophonePermission:^(NSInteger authStatus) {
            if (authStatus == 1) {
                NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
                meeting.name = roomId;
                meeting.type = NIMNetCallTypeVideo;
                meeting.ext = @"哈哈哈哈";
                meeting.actor = NO;
        
                [[NIMAVChatSDK sharedSDK].netCallManager reserveMeeting:meeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
                    if (!error) {
                        SLog(@"meeting=%@", meeting);
                        
                        [self joinNetCallWithRMeeting:meeting];
                        //
                    } else {
                        SLog(@"分配视频会议失败，请重试");
                        //SLog(@"%@",[[NIMSDK sharedSDK] currentLogFilepath]);
                    }
                }];
                
            }else{
                
            }
        }];
    }];
}

/*
 **加入会议
*/
- (void)joinNetCallWithRMeeting:(NIMNetCallMeeting *)rMeeting{
    rMeeting.type =NIMNetCallMediaTypeVideo;
    NIMNetCallOption *callOption =[[NIMNetCallOption alloc]init];
    callOption.preferredVideoQuality =NIMNetCallVideoQualityDefault;
    callOption.disableVideoCropping =NO;
    callOption.autoRotateRemoteVideo =YES;
    callOption.preferredVideoEncoder =NIMNetCallVideoCodecDefault;
    callOption.preferredVideoDecoder =NIMNetCallVideoCodecDefault;
    callOption.startWithBackCamera =NO;
    callOption.enableBypassStreaming =YES;
    callOption.bypassStreamingUrl =@"";
    rMeeting.option = callOption;
    //进入房间聊天
    [[NIMAVChatSDK sharedSDK].netCallManager joinMeeting:rMeeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
        if (!error) {
            SLog(@"进入成功");
        } else {
            SLog(@"进入会议失败，请重试\n错误:%@", error);

        }
    }];
}

/*
 **离开会议
 */
- (void)MSUNetCallManagerLeaveMeeting{
    NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
    meeting.name = @"201703220000";
    [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:meeting];
}

/*
 **关闭视频
*/
- (void)MSUNetCallManagerCloseVideo{
    [[NIMAVChatSDK sharedSDK].netCallManager setCameraDisable:YES];
    //    [[NIMAVChatSDK sharedSDK].netCallManager setMeetingRole:NO];
    
//    [[NIMAVChatSDK sharedSDK].netCallManager setVideoMute:YES forUser:@"abc_123"];;
}

/*
 **开启视频
*/
- (void)MSUNetCallManagerOpenVideo{
    [[NIMAVChatSDK sharedSDK].netCallManager setCameraDisable:NO];
    
//    [[NIMAVChatSDK sharedSDK].netCallManager setVideoMute:YES forUser:@"abc_123"];;

}

/*
 **开启静音
*/
- (void)MSUNetCallManagerOpenMute{
    [[NIMAVChatSDK sharedSDK].netCallManager setMute:YES];
}

/*
 **关闭静音
*/
- (void)MSUNetCallManagerCloseMute{
    [[NIMAVChatSDK sharedSDK].netCallManager setMute:NO];
}

/*
 **开启扬声器
*/
- (void)MSUNetCallManagerOpenSpeaker{
    [[NIMAVChatSDK sharedSDK].netCallManager setSpeaker:NO];
}

/*
 **关闭扬声器
*/
- (void)MSUNetCallManagerCloseSpeaker{
    [[NIMAVChatSDK sharedSDK].netCallManager setSpeaker:YES];
}

/*
 **切换后置摄像头
*/
- (void)MSUNetCallManagerOpenBackCamera{
    [[NIMAVChatSDK sharedSDK].netCallManager switchCamera:NIMNetCallCameraBack];
}

/*
 **切换前置摄像头
*/
- (void)MSUNetCallManagerOpenFrontCamera{
    [[NIMAVChatSDK sharedSDK].netCallManager switchCamera:NIMNetCallCameraFront];
}

#pragma mark - 代理方法
- (void)onRemoteYUVReady:(NSData *)yuvData width:(NSUInteger)width  height:(NSUInteger)height from:(NSString *)user {
//    SLog(@"=====%@", user);
//    SLog(@"====%lu, ====%lu", (unsigned long)width, (unsigned long)height);

//    if ([user isEqualToString:@"qwe_gaga"]) {
//        [self.videoView render:yuvData width:width height:height];
//    }
    [self.videoView render:yuvData width:width height:height];
}

- (void)onLocalPreviewReady:(CALayer *)layer {

    if (self.localVideoLayer) {
        [self.localVideoLayer removeFromSuperlayer];
    }
    self.localVideoLayer = layer;
    layer.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    //    [self.view.layer addSublayer:layer];
    [self.view.layer insertSublayer:layer atIndex:0];

    [self createLeaveBtn];
}

- (void)onUserJoined:(NSString *)uid meeting:(NIMNetCallMeeting *)meeting {
    SLog(@"===%@ ==%@", uid, meeting);
}
/// 有人离开会议回调
- (void)onUserLeft:(NSString *)uid meeting:(NIMNetCallMeeting *)meeting {
    SLog(@"===%@ ==%@", uid, meeting);
}

@end
