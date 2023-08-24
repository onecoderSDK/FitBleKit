/********************************************************************************
 * 文件名称：FBKApiErgometer.h
 * 内容摘要：拉力计 API
 * 版本编号：1.0.1
 * 创建日期：2023年02月28日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"

@protocol FBKApiERGDelegate <NSObject>
- (void)realTimeErg:(NSDictionary *)ergMap andDevice:(id)bleDevice;
- (void)enterZeroResult:(BOOL)status andDevice:(id)bleDevice;
- (void)zeroInfo:(NSDictionary *)infoMap andDevice:(id)bleDevice;
- (void)enterCalibrationResult:(BOOL)status andDevice:(id)bleDevice;
- (void)calibrationInfo:(NSDictionary *)infoMap andDevice:(id)bleDevice;
- (void)setFrequencyResult:(BOOL)status andDevice:(id)bleDevice;
- (void)samplingFrequency:(int)frequency andDevice:(id)bleDevice;
- (void)invalidCmd:(ErgometerCmdNumber)cmdId andDevice:(id)bleDevice;
@end

@interface FBKApiErgometer : FBKApiBsaeMethod

@property(assign,nonatomic)id <FBKApiERGDelegate> delegate;

// 进入零点模式
- (void)enterZeroMode;

// 获取零点信息
- (void)getZeroInfo;

// 进入标定模式
- (void)enterCalibrationMode;

// 获取标定信息
- (void)getCalibrationInfo;

// 设置采样频率
- (void)setSamplingFrequency:(int)frequency;

// 获取采样频率
- (void)getSamplingFrequency;

@end
