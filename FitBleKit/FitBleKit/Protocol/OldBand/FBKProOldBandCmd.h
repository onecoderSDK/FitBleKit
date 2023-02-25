/********************************************************************************
 * 文件名称：FBKProOldBandCmd.h
 * 内容摘要：老手环命令拼接
 * 版本编号：1.0.1
 * 创建日期：2017年11月21日
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "FBKDeviceUserInfo.h"

@protocol FBKProOldBandCmdDelegate <NSObject>

// 传输写入的数据
- (void)sendBleCmdData:(NSData *)byteData;

@end


@interface FBKProOldBandCmd : NSObject

// 回调协议
@property(assign,nonatomic)id <FBKProOldBandCmdDelegate> delegate;

// 回复的万能信息
- (void)ackCmd:(NSString *)writeNum;

// 写入手环的个人信息
- (void)setUserInfo:(NSString *)writeNum andNowInfo:(FBKDeviceUserInfo *)userInfo;

// 获取写入手环的时间
- (void)getTimeHand:(NSString *)writeNum;

// 写入手环的设置信息
- (void)setPramInfo:(NSString *)writeNum andNowInfo:(FBKDeviceSleepInfo *)sleepInfo andBikeInfo:(NSString *)bikeWhell;

// 获取写入手环的限制信息
- (void)getLimitData:(NSString *)writeNum andNowInfo:(FBKDeviceLimit *)limitInfo;

@end
