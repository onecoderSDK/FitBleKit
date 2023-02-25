/********************************************************************************
 * 文件名称：FBKApiOldScale.m
 * 内容摘要：旧秤API
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKApiOldScale.h"

@implementation FBKApiOldScale

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
    
    self.deviceType = BleDeviceOldScale;
    [self.managerController setManagerDeviceType:BleDeviceOldScale];
    
    return self;
}


#pragma mark - **************************** 对外接口 *****************************
/********************************************************************************
 * 方法名称：setUtc
 * 功能描述：设置时间
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setUtc
{
    [self.managerController receiveApiCmd:OldScaleCmdSetTime withObject:nil];
}


/********************************************************************************
 * 方法名称：setUserInfo
 * 功能描述：设置用户信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setUserInfo:(FBKDeviceScaleInfo *)userInfo
{
    [self.managerController receiveApiCmd:OldScaleCmdSetUserInfo withObject:userInfo];
}


/********************************************************************************
 * 方法名称：setUnits
 * 功能描述：设置设备单位
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setUnits:(ScaleUnitsType)unit
{
    NSString *unitsString = [NSString stringWithFormat:@"%i",unit];
    [self.managerController receiveApiCmd:OldScaleCmdSetUnit withObject:unitsString];
}


/********************************************************************************
 * 方法名称：setUnits
 * 功能描述：获取设备版本
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getVersion
{
    [self.managerController receiveApiCmd:OldScaleCmdGetInfo withObject:nil];
}


/********************************************************************************
 * 方法名称：addUserInfo
 * 功能描述：添加用户
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)addUserInfo:(FBKDeviceScaleInfo *)userInfo
{
    [self.managerController receiveApiCmd:OldScaleCmdAddUser withObject:userInfo];
}


/********************************************************************************
 * 方法名称：deleUserInfo
 * 功能描述：删除用户
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deleUserInfo:(FBKDeviceScaleInfo *)userInfo
{
    [self.managerController receiveApiCmd:OldScaleCmdDeleUser withObject:userInfo];
}


/********************************************************************************
 * 方法名称：tipUserInfo
 * 功能描述：指定用户
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)tipUserInfo:(FBKDeviceScaleInfo *)userInfo
{
    [self.managerController receiveApiCmd:OldScaleCmdTipUser withObject:userInfo];
}

#pragma mark - **************************** 协议回调 *****************************
/********************************************************************************
 * 方法名称：蓝牙连接状态
 * 功能描述：bleConnectStatus
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectStatus:(DeviceBleStatus)status
{
    if (status == DeviceBleConnected || status == DeviceBleSynchronization || status == DeviceBleSyncOver || status == DeviceBleSyncFailed)
    {
        self.isConnected = YES;
    }
    else
    {
        self.isConnected = NO;
    }
    
    [self.dataSource bleConnectStatus:status andDevice:self];
    
    if (status == DeviceBleConnected)
    {
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self setUtc];
            
        });
    }
}


/********************************************************************************
 * 方法名称：analyticalData
 * 功能描述：蓝牙结果数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalData:(id)resultData withResultNumber:(int)resultNumber
{
    FBKAnalyticalOScale resultType = (FBKAnalyticalOScale)resultNumber;
    
    switch (resultType)
    {
        case FBKAnalyOScaleVersion:
        {
            [self.delegate getDeviceVersion:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyOScaleDeviceTime:
        {
//            [self.delegate getScaleTime:(NSDictionary *)resultData];
            break;
        }
            
        case FBKAnalyOScaleUserInfo:
        {
//            [self.delegate getUserList:(NSDictionary *)resultData];
            break;
        }
            
        case FBKAnalyOScaleRealTime:
        {
            [self.delegate realTimeData:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyOScaleDetail:
        {
            [self.delegate stableData:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyOScaleRecord:
        {
            [self.delegate historyData:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        default:
        {
            break;
        }
    }
}


@end
