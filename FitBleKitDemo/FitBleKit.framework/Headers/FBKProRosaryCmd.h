/********************************************************************************
 * 文件名称：FBKProRosaryCmd.h
 * 内容摘要：念珠蓝牙命令
 * 版本编号：1.0.1
 * 创建日期：2017年11月21日
 ********************************************************************************/

#import <Foundation/Foundation.h>

@protocol FBKProRosaryCmdDelegate <NSObject>

// 传输写入的数据
- (void)sendBleCmdData:(NSData *)byteData;

@end


@interface FBKProRosaryCmd : NSObject

// 回调协议
@property(assign,nonatomic)id <FBKProRosaryCmdDelegate> delegate;

// 切换念珠模式
- (void)changeDeviceMode:(NSString *)mode;

// 查询、设置来电提醒
- (void)SearchOrSetNotice:(NSString *)setType andNoticeType:(NSString *)noticeType;

// 查询电量命令
- (void)searchPower;

// 设置、查询念珠一圈颗数
- (void)searchBeadNumber:(NSString *)setType andBeadNumber:(NSString *)beadNumber;

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
- (void)bluetoothPairing:(NSString *)pairState;

// 获取念珠历史数据
- (void)getBeadHistory;

// 获取念珠模式
- (void)getBeadMode;

// 应答命令
- (void)callbackCMD:(NSString *)backCMD;

// 上传念经记录应答
- (void)callbackHis:(NSString *)backCMD andBagId:(NSString *)bagId;

@end
