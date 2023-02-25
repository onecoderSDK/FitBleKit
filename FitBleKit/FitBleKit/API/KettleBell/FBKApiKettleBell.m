/********************************************************************************
 * 文件名称：FBKApiKettleBell.m
 * 内容摘要：壶铃API
 * 版本编号：1.0.1
 * 创建日期：2018年04月02日
 ********************************************************************************/

#import "FBKApiKettleBell.h"

@implementation FBKApiKettleBell

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
    
    self.deviceType = BleDeviceKettleBell;
    [self.managerController setManagerDeviceType:BleDeviceKettleBell];
    
    return self;
}


/********************************************************************************
 * 方法名称：setKettleBellTime
 * 功能描述：设置时间
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setKettleBellTime
{
    [self.managerController receiveApiCmd:KettleBellCmdSetTime withObject:nil];
}


/********************************************************************************
 * 方法名称：getKettleBellTotalHistory
 * 功能描述：获取所有历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getKettleBellTotalHistory
{
    [self.managerController receiveApiCmd:KettleBellCmdGetTotalRecord withObject:nil];
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
            [self.delegate kettleBellVersion:(NSString *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalBigData:
        {
            [self.delegate kettleBellDetailData:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        default:
        {
            break;
        }
    }
}


@end
