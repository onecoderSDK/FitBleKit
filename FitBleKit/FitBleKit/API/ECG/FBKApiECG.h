/********************************************************************************
 * 文件名称：FBKApiECG.h
 * 内容摘要：ECG API
 * 版本编号：1.0.1
 * 创建日期：2021年01月20日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"

@protocol FBKApiECGDelegate <NSObject>
- (void)realTimeECG:(NSArray *)ECGArray withSort:(int)sortNo andDevice:(id)bleDevice;
- (void)realTimeHeartRate:(NSDictionary *)HRInfo andDevice:(id)bleDevice;
- (void)setColorResult:(BOOL)status andDevice:(id)bleDevice;
- (void)ecgSwitchResult:(BOOL)status andDevice:(id)bleDevice;
- (void)ECGHRVData:(BOOL)status withData:(NSDictionary *)hrvMap andDevice:(id)bleDevice;
- (void)ECGListData:(BOOL)status withData:(NSArray *)ecgArray andDevice:(id)bleDevice;
@end


@interface FBKApiECG : FBKApiBsaeMethod

@property(assign,nonatomic)id <FBKApiECGDelegate> delegate;

- (void)setDeviceColor:(ECGShowColor)showColor;

- (void)enterHRVMode:(BOOL)status;

- (void)enterECGMode:(BOOL)status;

- (void)ecgDataSwitch:(BOOL)status;

@end

