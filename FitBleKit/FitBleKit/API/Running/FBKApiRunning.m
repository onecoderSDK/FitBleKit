/********************************************************************************
 * 文件名称：FBKApiRunning.h
 * 内容摘要：Run API
 * 版本编号：1.0.1
 * 创建日期：2021年05月25日
 ********************************************************************************/

#import "FBKApiRunning.h"

@implementation FBKApiRunning

#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：init
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (id)init {
    self = [super init];
    self.deviceType = BleDeviceRunning;
    [self.managerController setManagerDeviceType:BleDeviceRunning];
    return self;
}


#pragma mark - **************************** 协议回调 *****************************
/********************************************************************************
 * 方法名称：analyticalData
 * 功能描述：蓝牙结果数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalData:(id)resultData withResultNumber:(int)resultNumber {
    FBKAnalyticalNumber resultType = (FBKAnalyticalNumber)resultNumber;
    if (resultType == FBKRunningResultRealData) {
        NSDictionary *dataMap = (NSDictionary *)resultData;
        [self.delegate realTimeRunning:dataMap andDevice:self];
    }
}


@end
