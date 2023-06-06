/********************************************************************************
 * 文件名称：FBKApiRosary.h
 * 内容摘要：念珠API
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"

@protocol FBKApiRosaryDelegate <NSObject>

//  实时计数
- (void)realTimeBeadNumber:(NSDictionary *)info andDevice:(id)bleDevice;

//  电量
- (void)powerInfo:(NSDictionary *)info andDevice:(id)bleDevice;

//  提醒模式
- (void)remindMode:(NSDictionary *)info andDevice:(id)bleDevice;

//  佛珠个数
- (void)circelBeadNumber:(NSDictionary *)info andDevice:(id)bleDevice;

//  实时步数
- (void)realTimeSteps:(NSDictionary *)info andDevice:(id)bleDevice;

//  历史
- (void)rosaryRecord:(NSDictionary *)info andDevice:(id)bleDevice;

//  计数
- (void)nowBeadNumber:(NSDictionary *)info andDevice:(id)bleDevice;

//  配对
- (void)connectAncs:(NSDictionary *)info andDevice:(id)bleDevice;

//  历史状态
- (void)recordStatus:(NSDictionary *)info andDevice:(id)bleDevice;

//  连接状态
- (void)beadStatus:(NSDictionary *)info andDevice:(id)bleDevice;

@end


@interface FBKApiRosary : FBKApiBsaeMethod

// 协议
@property(assign,nonatomic)id <FBKApiRosaryDelegate> delegate;

// 切换念珠模式
- (void)startRosaryOn:(BOOL)status;

// 查询来电提醒
- (void)searchNotice:(NSString *)noticeType;

// 设置来电提醒
- (void)setNotice:(NSString *)noticeType;

// 查询电量命令
- (void)searchPower;

// 查询念珠一圈颗数
- (void)searchBeadNumber:(NSString *)beadNumber;

// 设置念珠一圈颗数
- (void)setBeadNumber:(NSString *)beadNumber;

// 获取实时步数
- (void)getRealTimeSteps;

// 获取念珠计数
- (void)getBeadNumbers;

// 获取非正常退出念珠模式时念珠计数
- (void)getErrorBeadNumbers;

// 设置设备时间命令
- (void)setDeviceTime;

// 设置闪灯或震动提示
- (void)setNoticeSetting:(NSDictionary *)setDictionary;

// 设置当前经书ID
- (void)setBookId:(NSString *)bookId;

// 打开/关闭蓝牙配对功能
- (void)bluetoothANCS:(BOOL)status;

// 获取念珠历史数据
- (void)getBeadHistory;

// 获取念珠模式
- (void)getBeadMode;

@end
