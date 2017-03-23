//
//  LoginOrRegist.h
//  temp
//
//  Created by 清正 on 2017/3/23.
//  Copyright © 2017年 清正. All rights reserved.
//

#import <Foundation/Foundation.h>

/** message:自定义的消息
 *  code:错误代码 参考:http://dev.netease.im/docs?doc=nim_status_code
 */
typedef void(^LoginRegist)(NSString *message, NSInteger code);

@interface LoginOrRegist : NSObject

/// UserID(云信ID)
@property(nonatomic, copy) NSString *userID;
/// 回调block
@property(nonatomic, copy) LoginRegist result;

+ (instancetype)shareUserInfo;

@end
