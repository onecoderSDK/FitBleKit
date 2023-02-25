/********************************************************************************
 * 文件名称：FBKApiNewScale.m
 * 内容摘要：新秤API
 * 版本编号：1.0.1
 * 创建日期：2017年11月08日
 ********************************************************************************/

#import "FBKApiNewScale.h"

@implementation FBKApiNewScale

#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：init
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (id)init
{
    self = [super init];
    
    self.deviceType = BleDeviceNewScale;
    [self.managerController setManagerDeviceType:BleDeviceNewScale];
    
    return self;
}


/********************************************************************************
 * 方法名称：setUtc
 * 功能描述：设置时间
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setUtc
{
    [self.managerController receiveApiCmd:NScaleCmdSetTime withObject:nil];
}


/********************************************************************************
 * 方法名称：setScaleUnit
 * 功能描述：设置秤单位
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setScaleUnit:(ScaleUnitsType)unit
{
    NSString *unitsString = [NSString stringWithFormat:@"%i",unit];
    [self.managerController receiveApiCmd:NScaleCmdSetUnit withObject:unitsString];
}


/********************************************************************************
 * 方法名称：setBabyMode
 * 功能描述：设置为抱婴模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setBabyMode
{
    [self.managerController receiveApiCmd:NScaleCmdSetType withObject:@"2"];
}


/********************************************************************************
 * 方法名称：setStandardMode
 * 功能描述：设置为标准模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setStandardMode
{
    [self.managerController receiveApiCmd:NScaleCmdSetType withObject:@"1"];
}


/********************************************************************************
 * 方法名称：setStandardMode
 * 功能描述：加载历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)loadHistory
{
    [self.managerController receiveApiCmd:NScaleCmdSetType withObject:@"4"];
}


#pragma mark - **************************** 协议回调 *****************************
/********************************************************************************
 * 方法名称：analyticalData
 * 功能描述：蓝牙结果数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalData:(id)resultData withResultNumber:(int)resultNumber
{
    FBKAnalyticalNumber resultType = (FBKAnalyticalNumber)resultNumber;
    
    switch (resultType)
    {
        case FBKAnalyticalDeviceVersion:
        {
            [self.delegate getDeviceVersion:(NSString *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalRTWeight:
        {
            [self.delegate realTimeData:(NSDictionary *)resultData andDevice:self];
            break;
        }

            
        case FBKAnalyticalBigData:
        {
            [self.delegate getWeightData:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        default:
        {
            break;
        }
    }
}


@end

