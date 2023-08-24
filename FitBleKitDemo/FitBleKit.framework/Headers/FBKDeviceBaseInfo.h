/********************************************************************************
 * 文件名称：FBKDeviceBaseInfo.h
 * 内容摘要：设备基础信息
 * 版本编号：1.0.1
 * 创建日期：2017年11月01日
 ********************************************************************************/

// 设备基本信息
#define   FBK_DEVICER_SYSTEMID      @"2A23" // System ID
#define   FBK_DEVICER_MODEL         @"2A24" // Model信息
#define   FBK_DEVICER_SERIAL        @"2A25" // 序列号
#define   FBKDEVICEREFIRMVERSION    @"2A26" // 固件版本号
#define   FBKDEVICEREHARDVERSION    @"2A27" // 硬件版本号
#define   FBKDEVICERESOFTVERSION    @"2A28" // 软件版本号
#define   FBK_DEVICER_MANUFACTURER  @"2A29" // 制造商信息
#define   FBKALLDEVICEREPOWER       @"2A19" // 设备电量
#define   FBK_DEVICER_MAXOXY        @"2A96" // 最大耗氧量
#define   FBK_DEVICE_OTA_NOTIFY     @"FD09" // OTA数据
#define   FBK_DEVICE_OTA_WRITE      @"FD0A" // OTA写入

// 新手环
#define   FBKNEWBANDNOTIFYFD19      @"FD19"
#define   FBKNEWBANDWRITEFD1A       @"FD1A"

// 老手环
#define   FBKOLDBANDNOTIFYFC20      @"FC20"
#define   FBKOLDBANDNOTIFYFC22      @"FC22"
#define   FBKOLDBANDNOTIFYFD17      @"FD17"
#define   FBKOLDBANDWRITEFC21       @"FC21"

// 新秤
#define   FBKNEWSCALENOTIFYFD19     @"FD19"
#define   FBKNEWSCALEWRITEFD1A      @"FD1A"

// 老秤
#define   FBKOLDSCALENOTIFYFC22     @"FC22"
#define   FBKOLDSCALEWRITEFC23      @"FC23"

// 速度踏频
#define   FBKCADENCENOTIFY2A5B      @"2A5B"
#define   FBKCADENCEWRITE2A55       @"2A55"

// 跳绳
#define   FBKSKIPPINGNOTIFYFC25     @"8FC3FC25-F21D-11E3-976C-0002A5D5C51B"
#define   FBKSKIPPINGWRITEFC26      @"8FC3FC26-F21D-11E3-976C-0002A5D5C51B"

// 心率
#define   FBKHEARTRATENOTIFY2A37    @"2A37"

// 念珠
#define   FBKROSARYNOTIFYFD1B       @"FD1B"
#define   FBKROSARYWRITEFD1C        @"FD1C"

// 码表
#define   FBKBIKENOTIFYFD19         @"FD19"
#define   FBKBIKEWRITEFD1A          @"FD1A"

// 臂带
#define   FBKARMBANDNOTIFYFD19      @"FD19"
#define   FBKARMBANDWRITEFD1A       @"FD1A"
#define   FBKARMBANDNOTIFYFD09      @"FD09"
#define   FBKARMBANDWRITEFD0A       @"FD0A"
#define   FBKARMBANDNOTIFYFCA3      @"a430fca3-044b-c6e2-92b2-61774eff0f01"
#define   FBKARMBANDNOTIFYFCA2      @"a430fca2-044b-c6e2-92b2-61774eff0f01"

// 壶铃
#define   FBKKETTLEBELLNOTIFYFD19   @"FD19"
#define   FBKKETTLEBELLWRITEFD1A    @"FD1A"

// 拳击
#define   FBKBOXINGNOTIFYFD19         @"FD19"
#define   FBKBOXINGBIKEWRITEFD1A      @"FD1A"
#define   FBKBOXINGNOTIFYFD0D         @"FD0D"

// 功率计
#define   POWER_WRITE_NOTIFY_UUID    @"2A66"
#define   POWER_NOTIFY_CHAR_UUID     @"2A63"

// ECG
#define   ECG_SERVICE_UUID           @"EC00"
#define   ECG_NOTIFY_UUID            @"EC09"
#define   ECG_WRITE_UUID             @"EC0A"

// Run
#define   RUNNING_SERVER_UUID        @"1814" // 跑步服务
#define   RUNNING_NOTIFY_UUID        @"2A53" // 跑步通知

// Fight
#define   FIGHT_SERVICE_UUID         @"8FC3FC00-F21D-11E3-976C-0002A5D5C51B"
#define   FIGHT_NOTIFY_UUID          @"8FC3FC20-F21D-11E3-976C-0002A5D5C51B"
#define   FIGHT_WRITE_UUID           @"8FC3FC21-F21D-11E3-976C-0002A5D5C51B"

// Run
#define   RUNNING_SERVER_UUID        @"1814" // 跑步服务
#define   RUNNING_NOTIFY_UUID        @"2A53" // 跑步通知

// Ergometer 测力计
#define   ERG_SERVER_UUID            @"8FC3FC00-F21D-11E3-976C-0002A5D5C51B"// 测力计服务
#define   ERG_NOTIFY_UUID            @"8FC3FC20-F21D-11E3-976C-0002A5D5C51B"// 测力计通知
#define   ERG_WRITE_UUID             @"8FC3FC21-F21D-11E3-976C-0002A5D5C51B"// 测力计写入


#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "FBKEnumList.h"

@interface FBKDeviceBaseInfo : NSObject

// 设备状态
@property (assign,nonatomic) DeviceBleStatus deviceBleStatus;

// 连接状态
@property (assign,nonatomic) BOOL isBleConnect;

// 设备变量
@property (strong,nonatomic) CBPeripheral *blePeripheral;

// 设备ID
@property (strong,nonatomic) NSString *deviceId;

// 扫描UUID特征
@property (strong,nonatomic) NSArray *UUIDArray;

// 服务列表
@property (strong,nonatomic) NSArray *servicesArray;

// 通道列表
@property (strong,nonatomic) NSArray *characteristicsArray;

// 获取不同设备的UUID
- (NSArray *)getScanUuidArray:(BleDeviceType)deviceType andEditType:(CharacteristicEditType)charType;

@end

