/********************************************************************************
 * 文件名称：FBKEnumList.h
 * 内容摘要：枚举类集合
 * 版本编号：1.0.1
 * 创建日期：2017年11月06日
 ********************************************************************************/

#import <Foundation/Foundation.h>

typedef enum{
    DeviceBleClosed = 0,      // 未开启蓝牙
    DeviceBleIsOpen,          // 蓝牙可用
    DeviceBleSearching,       // 搜索中...
    DeviceBleConnecting,      // 连接中...
    DeviceBleConnected,       // 已连接
    DeviceBleSynchronization, // 同步中...
    DeviceBleSyncOver,        // 同步完成
    DeviceBleSyncFailed,      // 同步失败
    DeviceBleDisconnecting,   // 断开中...
    DeviceBleDisconneced,     // 已断开
    DeviceBleReconnect,       // 重连中...
}DeviceBleStatus;


typedef enum{
    BleDeviceNewBand = 0,  // 新协议手环
    BleDeviceOldBand,      // 旧协议手环
    BleDeviceNewScale,     // 新协议秤
    BleDeviceOldScale,     // 旧协议秤
    BleDeviceHeartRate,    // 心率带
    BleDeviceSkipping,     // 跳绳
    BleDeviceCadence,      // 踏频传感器
    BleDeviceRosary,       // 念珠
    BleDeviceBikeComputer, // 码表
    BleDeviceArmBand,      // 臂带
    BleDeviceKettleBell,   // 壶铃
    BleDeviceHubConfig,    // Hub配置
    BleDeviceBoxing,       // 拳击
    BleDeviceBroadScale,   // 广播蓝牙秤
    BleDevicePower,        // 功率计
    BleDeviceECG,          // 功率计
    BleDeviceFunction,     // 设备功能
    BleDeviceRunning,      // 跑步
    BleDevicePPGDFU,       // PGG
    BleDeviceFight,        // Fight
}BleDeviceType;


typedef enum{
    CharacteristicRead = 0, // 读通道
    CharacteristicNotify,   // 广播通道
    CharacteristicWrite,    // 写通道
}CharacteristicEditType;


typedef enum{
    MusicStop = 0,  // 停止音乐
    MusicPlay,      // 播放音乐
    MusicPause,     // 暂停音乐
    MusicNext,      // 下一首
    MusicBefore,    // 上一首
    MusicMinVolume, // 减少音量
    MusicAddVolume, // 增加音量
}MusicStatus;


typedef enum{
    ScaleUnitsKG = 0, // KG
    ScaleUnitsLB,     // LB
    ScaleUnitsST,     // ST
    ScaleUnitsJin,    // 斤
}ScaleUnitsType;


typedef enum{
    DeviceIdUUID = 0,  // 以UUID为匹配条件
    DeviceIdMacAdress, // 以MAC地址为匹配条件
    DeviceIdName,      // 以名称为匹配条件
    DeviceIdOther,     // 以特殊字段为匹配条件
}DeviceIdType;





