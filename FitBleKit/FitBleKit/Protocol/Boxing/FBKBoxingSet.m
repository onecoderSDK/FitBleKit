/********************************************************************************
 * 文件名称：FBKBoxingSet.m
 * 内容摘要：拳击器设置类
 * 版本编号：1.0.1
 * 创建日期：2020年02月16日
 ********************************************************************************/

#import "FBKBoxingSet.h"

@implementation FBKBoxingSet

- (id)init {
    self.axisType  = AxisTypeAX;
    self.isReserve = true;
    self.lowZone   = 0;
    self.hightZone = 0;
    
    return self;
}

@end


@implementation FBKBoxingAxis

- (id)init {
    self.accelerationX  = 0.0;
    self.accelerationY  = 0.0;
    self.accelerationZ  = 0.0;
    self.angularX  = 0.0;
    self.angularY  = 0.0;
    self.angularZ  = 0.0;
    
    return self;
}

@end
