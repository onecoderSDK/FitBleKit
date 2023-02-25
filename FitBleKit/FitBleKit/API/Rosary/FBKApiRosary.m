/********************************************************************************
 * 文件名称：FBKApiRosary.m
 * 内容摘要：念珠API
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKApiRosary.h"

@implementation FBKApiRosary

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
    
    self.deviceType = BleDeviceRosary;
    [self.managerController setManagerDeviceType:BleDeviceRosary];
    
    return self;
}


#pragma mark - **************************** 对外接口 *****************************
/********************************************************************************
 * 方法名称：startRosaryOn
 * 功能描述：切换念珠模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)startRosaryOn:(BOOL)status
{
    NSString *statusString = @"2";
    if (status)
    {
        statusString = @"1";
    }
    
    [self.managerController receiveApiCmd:RosaryCmdEditMode withObject:statusString];
}


/********************************************************************************
 * 方法名称：searchNotice
 * 功能描述：查询来电提醒
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)searchNotice:(NSString *)noticeType
{
    [self.managerController receiveApiCmd:RosaryCmdSearchRemind withObject:noticeType];
}


/********************************************************************************
 * 方法名称：setNotice
 * 功能描述：设置来电提醒
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setNotice:(NSString *)noticeType
{
    [self.managerController receiveApiCmd:RosaryCmdSetRemind withObject:noticeType];
}


/********************************************************************************
 * 方法名称：searchPower
 * 功能描述：查询电量命令
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)searchPower
{
    [self.managerController receiveApiCmd:RosaryCmdSearchPower withObject:nil];
}


/********************************************************************************
 * 方法名称：searchBeadNumber
 * 功能描述：查询念珠一圈颗数
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)searchBeadNumber:(NSString *)beadNumber
{
    [self.managerController receiveApiCmd:RosaryCmdSearchBeadNum withObject:beadNumber];
}


/********************************************************************************
 * 方法名称：setBeadNumber
 * 功能描述：设置念珠一圈颗数
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setBeadNumber:(NSString *)beadNumber
{
    [self.managerController receiveApiCmd:RosaryCmdSetBeadNum withObject:beadNumber];
}


/********************************************************************************
 * 方法名称：getRealTimeSteps
 * 功能描述：获取实时步数
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getRealTimeSteps
{
    [self.managerController receiveApiCmd:RosaryCmdGetRTSteps withObject:nil];
}


/********************************************************************************
 * 方法名称：getBeadNumbers
 * 功能描述：获取念珠计数
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getBeadNumbers
{
    [self.managerController receiveApiCmd:RosaryCmdRTNumber withObject:nil];
}


/********************************************************************************
 * 方法名称：getErrorBeadNumbers
 * 功能描述：获取非正常退出念珠模式时念珠计数
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getErrorBeadNumbers
{
//    [self.managerController receiveApiCmd:RosaryCmdRTNumber withObject:nil];
}


/********************************************************************************
 * 方法名称：setDeviceTime
 * 功能描述：设置设备时间命令
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setDeviceTime
{
    [self.managerController receiveApiCmd:RosaryCmdSetTime withObject:nil];
}


/********************************************************************************
 * 方法名称：setNoticeSetting
 * 功能描述：设置闪灯或震动提示
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setNoticeSetting:(NSDictionary *)setDictionary
{
    [self.managerController receiveApiCmd:RosaryCmdSetRemiadList withObject:setDictionary];
}


/********************************************************************************
 * 方法名称：setBookId
 * 功能描述：设置当前经书ID
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setBookId:(NSString *)bookId
{
    [self.managerController receiveApiCmd:RosaryCmdSetBookId withObject:bookId];
}


/********************************************************************************
 * 方法名称：bluetoothANCS
 * 功能描述：打开/关闭蓝牙配对功能
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bluetoothANCS:(BOOL)status
{
    NSString *statusString = @"2";
    if (status)
    {
        statusString = @"1";
    }
    [self.managerController receiveApiCmd:RosaryCmdSetAncs withObject:statusString];
}


/********************************************************************************
 * 方法名称：getBeadHistory
 * 功能描述：获取念珠历史数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getBeadHistory
{
    [self.managerController receiveApiCmd:RosaryCmdGetRecord withObject:nil];
}


/********************************************************************************
 * 方法名称：getBeadMode
 * 功能描述：获取念珠模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getBeadMode
{
    [self.managerController receiveApiCmd:RosaryCmdGetNowStatus withObject:nil];
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
    FBKAnalyticalRosary resultType = (FBKAnalyticalRosary)resultNumber;
    
    switch (resultType)
    {
        case FBKAnalyticalRosaryRTNumber:
        {
            [self.delegate realTimeBeadNumber:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalRosaryPower:
        {
            [self.delegate powerInfo:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalRosaryRemindMode:
        {
            [self.delegate remindMode:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalRosaryBeadNumber:
        {
            [self.delegate circelBeadNumber:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalRosarySteps:
        {
            [self.delegate realTimeSteps:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalRosaryRecord:
        {
            [self.delegate rosaryRecord:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalRosaryNumber:
        {
            [self.delegate nowBeadNumber:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalRosaryANCS:
        {
            [self.delegate connectAncs:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalRosaryRecordStatus:
        {
            [self.delegate recordStatus:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        case FBKAnalyticalRosaryStatus:
        {
            [self.delegate beadStatus:(NSDictionary *)resultData andDevice:self];
            break;
        }
            
        default:
        {
            break;
        }
    }
}


@end
