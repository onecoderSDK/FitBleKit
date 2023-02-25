/********************************************************************************
 * 文件名称：FBKApiOldBand.m
 * 内容摘要：旧手环API
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKApiOldBand.h"

@implementation FBKApiOldBand

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
    
    self.deviceType = BleDeviceOldBand;
    [self.managerController setManagerDeviceType:BleDeviceOldBand];
    
    return self;
}


#pragma mark - **************************** 对外接口 *****************************
/********************************************************************************
 * 方法名称：setUserInfoApi
 * 功能描述：设置个人基本信息
 * 输入参数：userInfo-个人信息
 * 返回数据：
 ********************************************************************************/
- (void)setUserInfoApi:(FBKDeviceUserInfo *)userInfo
{
    [self.managerController receiveApiCmd:OTrackerCmdSetUserInfo withObject:userInfo];
}


/********************************************************************************
 * 方法名称：setSleepInfoApi
 * 功能描述：设置个人睡眠信息
 * 输入参数：sleepInfo-个人睡眠信息
 * 返回数据：
 ********************************************************************************/
- (void)setSleepInfoApi:(FBKDeviceSleepInfo *)sleepInfo
{
    [self.managerController receiveApiCmd:OTrackerCmdSetSleepInfo withObject:sleepInfo];
}

/********************************************************************************
 * 方法名称：setBikeInfoApi
 * 功能描述：设置单车参数
 * 输入参数：whellDiameter-单车参数
 * 返回数据：
 ********************************************************************************/
- (void)setBikeInfoApi:(NSString *)whellDiameter
{
    [self.managerController receiveApiCmd:OTrackerCmdSetBikeInfo withObject:whellDiameter];
}


/********************************************************************************
* 方法名称：setLimitInfoApi
* 功能描述：设置限制参数
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)setLimitInfoApi:(FBKDeviceLimit *)limitInfo {
    [self.managerController receiveApiCmd:OTrackerCmdLimitInfo withObject:limitInfo];
}


/********************************************************************************
 * 方法名称：getRecordData
 * 功能描述：获取历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getRecordData
{
    [self editCharacteristicNotifyApi:YES withCharacteristic:FBKOLDBANDNOTIFYFC20];
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
    FBKAnalyticalOldBand resultType = (FBKAnalyticalOldBand)resultNumber;
    
    switch (resultType)
    {
        case FBKAnalyticalOldBandRTHR:
        {
            [self.delegate getRealTimeHeartRate:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalOldBandRTSteps:
        {
            [self.delegate getRealTimeStepsData:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalOldBandFindPhone:
        {
            BOOL status = NO;
            NSString *statusString = (NSString *)resultData;
            if ([statusString intValue])
            {
                status = YES;
            }
            [self.delegate findPhone:status andDevice:self];
            break;
        }
            
        case FBKAnalyticalOldBandBigData:
        {
            [self editCharacteristicNotifyApi:NO withCharacteristic:FBKOLDBANDNOTIFYFC20];
            [self.delegate getBigData:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        default:
        {
            break;
        }
    }
}


@end
