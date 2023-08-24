/********************************************************************************
 * 版权所有：深圳市一非科技有限公司
 * 文件名称：FitBleKit.h
 * 内容摘要：手环蓝牙类头文件
 * 编辑作者：彭于
 * 版本编号：1.0.1
 * 创建日期：2017年11月11日
 ********************************************************************************/

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double FCSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char FCSDKVersionString[];

// Tools
#import "FBKEnumList.h"
#import "FBKDateFormat.h"
#import "FBKSpliceBle.h"
#import "FBKTemAlgorithm.h"
#import "FBKHRRecordAnaly.h"
#import "FBKECGHeartRate.h"
#import "FBKECGFilter.h"

// Devices
#import "FBKDeviceNewScale.h"
#import "FBKDeviceNewBand.h"
#import "FBKDeviceUserInfo.h"
#import "FBKDeviceBaseInfo.h"

// Ble
#import "FBKBleScan.h"
#import "FBKSpliceBle.h"

// Manager
#import "FBKManagerController.h"
#import "FBKManagerCmd.h"
#import "FBKManagerAnaly.h"

// Protocol Api Common
#import "FBKProtocolBase.h"
#import "FBKProNTrackerCmd.h"
#import "FBKProNTrackerAnalytical.h"
#import "FBKProNTrackerBigData.h"
#import "FBKAnalyticalHubConfig.h"
#import "FBKApiBsaeMethod.h"
#import "FBKApiBaseInfo.h"
#import "FBKApiScanDevices.h"

// Protocol Api OldBand
#import "FBKProtocolOldBand.h"
#import "FBKProOldBandCmd.h"
#import "FBKProOldBandAnalytical.h"
#import "FBKApiOldBand.h"

// Protocol Api NewBand
#import "FBKProtocolNTracker.h"
#import "FBKApiNewBand.h"

// Protocol Api OldScale
#import "FBKProtocolOldScale.h"
#import "FBKProOldScaleCmd.h"
#import "FBKProOldScaleAnalytical.h"
#import "FBKApiOldScale.h"

// Protocol Api NewScale
#import "FBKProtocolNScale.h"
#import "FBKApiNewScale.h"

// Protocol Api HeartRate
#import "FBKApiHeartRate.h"

// Protocol Api Cadence
#import "FBKProtocolCadence.h"
#import "FBKApiCadence.h"
#import "FBKCadenceData.h"

// Protocol Api Skipping
#import "FBKProtocolSkipping.h"
#import "FBKApiSkipping.h"

// Protocol Api Rosary
#import "FBKProtocolRosary.h"
#import "FBKProRosaryCmd.h"
#import "FBKProRosaryAnalytical.h"
#import "FBKApiRosary.h"

// Protocol Api BikeComputer
#import "FBKProtocolBikeComputer.h"
#import "FBKApiBikeComputer.h"

// Protocol Api ArmBand
#import "FBKProtocolArmBand.h"
#import "FBKArmBandPara.h"
#import "FBKArmBandCmd.h"
#import "FBKApiArmBand.h"

// Protocol Api KettleBell
#import "FBKProtocolKettleBell.h"
#import "FBKApiKettleBell.h"

// Protocol Api HubConfig
#import "FBKProtocolHubConfig.h"
#import "FBKApiHubConfig.h"

// Protocol Api Boxing
#import "FBKProtocolBoxing.h"
#import "FBKBoxingSet.h"
#import "FBKApiBoxing.h"

// Protocol Api BroadcastingScale
#import "FBKApiBroadcastScale.h"

// Protocol Api Power
#import "FBKProtocolPower.h"
#import "FBKPowerCmd.h"
#import "FBKPowerAnaly.h"
#import "FBKApiPower.h"

// Protocol Api ECG
#import "FBKProtocolECG.h"
#import "FBKECGCmd.h"
#import "FBKApiECG.h"

// Protocol Api BleFunction
#import "FBKBleFunction.h"

// Protocol Api Running
#import "FBKProtocolRun.h"
#import "FBKApiRunning.h"

// Protocol Api PPG
#import "FBKProtocolPPG.h"
#import "FBKPPGCmd.h"
#import "FBKApiPPGDFU.h"

// Protocol Api Fight
#import "FBKProtocolFight.h"
#import "FBKFightCmd.h"
#import "FBKFightClass.h"
#import "FBKApiFight.h"

// Protocol Api ERG
#import "FBKProtocolErgometer.h"
#import "FBKErgometerCmd.h"
#import "FBKApiErgometer.h"

