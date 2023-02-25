/********************************************************************************
 * 文件名称：FBKApiFight.h
 * 内容摘要：Fight API
 * 版本编号：1.0.1
 * 创建日期：2022年08月23日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"

@protocol FBKApiFightDelegate <NSObject>
- (void)bleConnectStatus:(DeviceBleStatus)status andDevice:(id)bleDevice;
- (void)bleConnectError:(id)error andDevice:(id)bleDevice;
- (void)bleConnectLog:(NSString *)logString andDevice:(id)bleDevice;

- (void)realTimeFight:(FBKFightInfo *)fightInfo andDevice:(id)bleDevice;
- (void)enterDfuResult:(BOOL)status andDevice:(id)bleDevice;
- (void)turnOffDeviceResult:(BOOL)status andDevice:(id)bleDevice;
- (void)setSandbagResult:(BOOL)status andDevice:(id)bleDevice;
@end

@interface FBKApiFight : FBKApiBsaeMethod

@property(assign,nonatomic)id <FBKApiFightDelegate> delegate;

- (void)enterDfuMode;

- (void)turnOffDevice;

- (void)setSandbag:(FBKFightSandbag *)sandbag;

@end
