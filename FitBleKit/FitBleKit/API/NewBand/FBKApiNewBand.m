/********************************************************************************
 * 文件名称：FBKApiNewScale.m
 * 内容摘要：新手环API
 * 版本编号：1.0.1
 * 创建日期：2017年11月08日
 ********************************************************************************/

#import "FBKApiNewBand.h"

@implementation FBKApiNewBand

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
    
    self.deviceType = BleDeviceNewBand;
    [self.managerController setManagerDeviceType:BleDeviceNewBand];
    
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
    [self.managerController receiveApiCmd:NTrackerCmdSetTime withObject:nil];
}


/********************************************************************************
 * 方法名称：setUserInfoApi
 * 功能描述：设置个人基本信息
 * 输入参数：userInfo-个人信息
 * 返回数据：
 ********************************************************************************/
- (void)setUserInfoApi:(FBKDeviceUserInfo *)userInfo
{
    [self.managerController receiveApiCmd:NTrackerCmdSetUserInfo withObject:userInfo];
}


/********************************************************************************
 * 方法名称：setSleepInfoApi
 * 功能描述：设置个人睡眠信息
 * 输入参数：sleepInfo-个人睡眠信息
 * 返回数据：
 ********************************************************************************/
- (void)setSleepInfoApi:(FBKDeviceSleepInfo *)sleepInfo
{
    [self.managerController receiveApiCmd:NTrackerCmdSetSleepInfo withObject:sleepInfo];
}


/********************************************************************************
 * 方法名称：setWaterInfoApi
 * 功能描述：设置个人喝水信息
 * 输入参数：waterInfo-喝水信息
 * 返回数据：
 ********************************************************************************/
- (void)setWaterInfoApi:(FBKDeviceIntervalInfo *)waterInfo
{
    [self.managerController receiveApiCmd:NTrackerCmdSetWaterInfo withObject:waterInfo];
}


/********************************************************************************
 * 方法名称：setSitInfoApi
 * 功能描述：设置个人久坐信息
 * 输入参数：sitInfo-久坐信息
 * 返回数据：
 ********************************************************************************/
- (void)setSitInfoApi:(FBKDeviceIntervalInfo *)sitInfo
{
    [self.managerController receiveApiCmd:NTrackerCmdSetSitInfo withObject:sitInfo];
}


/********************************************************************************
 * 方法名称：setNoticeInfoApi
 * 功能描述：设置个人通知信息
 * 输入参数：noticeInfo-通知信息
 * 返回数据：
 ********************************************************************************/
- (void)setNoticeInfoApi:(FBKDeviceNoticeInfo *)noticeInfo
{
    [self.managerController receiveApiCmd:NTrackerCmdSetNoticeInfo withObject:noticeInfo];
}


/********************************************************************************
 * 方法名称：setAlarmInfoApi
 * 功能描述：设置个人闹钟信息
 * 输入参数：alarmInfoArray-闹钟信息
 * 返回数据：
 ********************************************************************************/
- (void)setAlarmInfoApi:(NSArray *)alarmInfoArray
{
    [self.managerController receiveApiCmd:NTrackerCmdSetAlarmInfo withObject:alarmInfoArray];
}


/********************************************************************************
 * 方法名称：setBikeInfoApi
 * 功能描述：设置单车参数
 * 输入参数：whellDiameter-单车参数
 * 返回数据：
 ********************************************************************************/
- (void)setBikeInfoApi:(NSString *)whellDiameter
{
    [self.managerController receiveApiCmd:NTrackerCmdSetBikeInfo withObject:whellDiameter];
}


/********************************************************************************
 * 方法名称：setHeartRateMaxApi
 * 功能描述：设置心率最大值
 * 输入参数：maxRate-心率最大值
 * 返回数据：
 ********************************************************************************/
- (void)setHeartRateMaxApi:(NSString *)maxRate
{
    [self.managerController receiveApiCmd:NTrackerCmdSetHRMax withObject:maxRate];
}


/********************************************************************************
 * 方法名称：openRealTimeStepsApi
 * 功能描述：实时数据
 * 输入参数：status-状态
 * 返回数据：
 ********************************************************************************/
- (void)openRealTimeStepsApi:(BOOL)status
{
    NSString *statusString = @"0";
    if (status)
    {
        statusString = @"1";
    }
    
    [self.managerController receiveApiCmd:NTrackerCmdOpenRealTImeSteps withObject:statusString];
}


/********************************************************************************
 * 方法名称：openTakePhotoApi
 * 功能描述：拍照
 * 输入参数：status-状态
 * 返回数据：
 ********************************************************************************/
- (void)openTakePhotoApi:(BOOL)status
{
    NSString *statusString = @"0";
    if (status)
    {
        statusString = @"1";
    }
    
    [self.managerController receiveApiCmd:NTrackerCmdOpenTakePhoto withObject:statusString];
}


/********************************************************************************
 * 方法名称：openHeartRateModeApi
 * 功能描述：心率模式
 * 输入参数：status-状态
 * 返回数据：
 ********************************************************************************/
- (void)openHeartRateModeApi:(BOOL)status
{
    NSString *statusString = @"0";
    if (status)
    {
        statusString = @"1";
    }
    
    [self.managerController receiveApiCmd:NTrackerCmdOpenHRMode withObject:statusString];
}


/********************************************************************************
 * 方法名称：openHRTenModeApi
 * 功能描述：心率模式10分钟采集
 * 输入参数：status-状态
 * 返回数据：
 ********************************************************************************/
- (void)openHRTenModeApi:(BOOL)status
{
    NSString *statusString = @"0";
    if (status)
    {
        statusString = @"1";
    }
    
    [self.managerController receiveApiCmd:NTrackerCmdOpenHRTenMode withObject:statusString];
}


/********************************************************************************
 * 方法名称：openANCSModeApi
 * 功能描述：开启配对
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)openANCSModeApi:(BOOL)status
{
    NSString *statusString = @"0";
    if (status)
    {
        statusString = @"1";
    }
    
    [self.managerController receiveApiCmd:NTrackerCmdOpenANCSMode withObject:statusString];
}


/********************************************************************************
 * 方法名称：getTotalHistory
 * 功能描述：获取所有历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getTotalHistory
{
    [self.managerController receiveApiCmd:NTrackerCmdGetTotalRecord withObject:nil];
}


/********************************************************************************
 * 方法名称：getStepHistory
 * 功能描述：获取运动历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getStepHistory
{
    [self.managerController receiveApiCmd:NTrackerCmdGetStepRecord withObject:nil];
}


/********************************************************************************
 * 方法名称：getHeartRateHistory
 * 功能描述：获取心率历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getHeartRateHistory
{
    [self.managerController receiveApiCmd:NTrackerCmdGetHRRecord withObject:nil];
}


/********************************************************************************
 * 方法名称：getBikeHistory
 * 功能描述：获取踏频历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getBikeHistory
{
    [self.managerController receiveApiCmd:NTrackerCmdGetBikeRecord withObject:nil];
}


/********************************************************************************
 * 方法名称：getTrainHistory
 * 功能描述：获取训练历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getTrainHistory
{
    [self.managerController receiveApiCmd:NTrackerCmdGetTrainRecord withObject:nil];
}


/********************************************************************************
 * 方法名称：getSleepHistory
 * 功能描述：获取睡眠历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getSleepHistory
{
    [self.managerController receiveApiCmd:NTrackerCmdGetSleepRecord withObject:nil];
}


/********************************************************************************
 * 方法名称：getEverydayHistory
 * 功能描述：获取每天步数总和历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getEverydayHistory
{
    [self.managerController receiveApiCmd:NTrackerCmdGetEverydayRecord withObject:nil];
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
            
        case FBKAnalyticalRealTimeHR:
        {
            [self.delegate getRealTimeHeartRate:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalFindPhone:
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
            
        case FBKAnalyticalTakePhoto:
        {
            [self.delegate takePhoto:self];
            break;
        }
            
        case FBKAnalyticalMusicStatus:
        {
            NSString *statusString = (NSString *)resultData;
            MusicStatus musicStatus = (MusicStatus)[statusString intValue];
            [self.delegate getMusicStatus:musicStatus andDevice:self];
            break;
        }
            
        case FBKAnalyticalLastSyncTime:
        {
            [self.delegate getLastSyncTime:(NSString *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalDeviceVersion:
        {
            [self.delegate getDeviceVersion:(NSString *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalRealTimeSteps:
        {
            [self.delegate getRealTimeStepsData:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalBigData:
        {
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

