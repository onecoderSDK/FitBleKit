/********************************************************************************
 * 文件名称：FBKProOldScaleCmd.h
 * 内容摘要：老秤命令拼接
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "FBKDeviceUserInfo.h"

@protocol FBKProOldScaleCmdDelegate <NSObject>

// 传输写入的数据
- (void)sendBleCmdData:(NSData *)byteData;

@end


@interface FBKProOldScaleCmd : NSObject

// 回调协议
@property(assign,nonatomic)id <FBKProOldScaleCmdDelegate> delegate;

// 设置时间
- (void)setWeightTimeData;

// 设置用户信息
- (void)setUserInfo:(FBKDeviceScaleInfo *)sacleInfo;

// 设置设备单位
- (void)setDeviceUnit:(NSString *)unit;

// 获取设备基本信息
- (void)getDeviceBaseInfo;

// 添加、删除、指定用户信息命令
- (void)editUserNumberData:(FBKDeviceScaleInfo *)sacleInfo andEditState:(NSString *)state;

// 应答命令
- (void)ackCmd:(NSString *)ackNumber;

@end
