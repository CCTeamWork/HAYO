//
//  LoginOrRegist.m
//  temp
//
//  Created by 清正 on 2017/3/23.
//  Copyright © 2017年 清正. All rights reserved.
//

#import "LoginOrRegist.h"
#import <NIMSDK/NIMSDK.h>
#import "NIMServerAPI.h"

#define UserInfo_ID @"user_info_key"
#define UserInfo_Password @"userInfo_Existence"

#define UserDefailt [NSUserDefaults standardUserDefaults]

#define Password @"NIMSDK/NIMSDK_User_PassWord"

static LoginOrRegist *_userInfo;

@implementation LoginOrRegist {
    
}

+ (instancetype)shareUserInfo {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userInfo = [[self alloc] init];
    });
    return _userInfo;
}
/** 登录
 *  @param account 账号ID
 *  @param result 登录结果
 */
- (void)login:(NSString*)account result:(LoginRegist)result {
    [[[NIMSDK sharedSDK] loginManager] login:account token:Password completion:^(NSError *error) {
        self.result = result;
        if (error) {
            _result(@"登录失败", error.code);
        } else {
            _result(@"登录成功", 200);
            if (_userInfo) {
                _userInfo.userID =account;
                _userInfo.userPswd =Password;
            }
            [_userInfo saveCurrentAccount];
        }
    }];
}

/** 注册
 *  @param account 账号ID
 *  @param result 注册结果
 */
- (void)regist:(NSString*)account result:(LoginRegist)result {
    
    NSDictionary *params =@{@"accid":account,
                            @"props":@"",
                            @"token":Password,
                            @"icon":@""};
    [[NIMServerAPI sharedAPI] request:@"https://api.netease.im/nimserver/user/create.action" params:params completion:^(NSError *error, NSDictionary *resultDict) {
        self.result = result;
        if (error) {
            _result(@"注册失败", error.code);
        } else {
            _result(@"注册成功", 200);
        }
    }];
}

/**
 * 保存本地
 */
- (void)saveCurrentAccount {
    [UserDefailt setObject:_userInfo.userID forKey:UserInfo_ID];
    [UserDefailt setObject:_userInfo.userPswd forKey:UserInfo_Password];
    [UserDefailt synchronize];
}

/**
 * 删除本地
 */
- (void)removeCurrentAccount {
    [UserDefailt removeObjectForKey:UserInfo_ID];
    [UserDefailt removeObjectForKey:UserInfo_Password];
    [UserDefailt synchronize];
}


@end
