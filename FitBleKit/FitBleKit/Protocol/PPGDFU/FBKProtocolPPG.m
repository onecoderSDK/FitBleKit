/*-****************************************************************************************
* Copyright: Technology Co., Ltd 
* File Name: FBKProtocolPPG.m
* Function : PPG Ble Protocol
* Editor   : Pendy 
* Version  : 1.0.1
* Date     : 2021.07.09
******************************************************************************************/

#import "FBKProtocolPPG.h"
#import "FBKSpliceBle.h"

@implementation FBKProtocolPPG {
    NSString *m_dfuFilePath;
    NSMutableArray *m_cmdFileArray;
    FBKPPGCmd   *m_PPGCmd;
    int m_cmdCount;
    int m_sendCount;
}

#pragma mark - ****************************** Syetems *************************************
/*-****************************************************************************************
* Method: init
* Description: start here
* Parameter:
* Return Data:
 ******************************************************************************************/
- (id)init {
    self = [super init];
    m_dfuFilePath = [[NSString alloc] init];
    m_cmdFileArray = [[NSMutableArray alloc] init];
    m_PPGCmd = [[FBKPPGCmd alloc] init];
    m_cmdCount = 0;
    m_sendCount = 0;
    return self;
}


/*-****************************************************************************************
* Method: dealloc
* Description: end here
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)dealloc {
}


#pragma mark - ****************************** Receive Data ********************************
/*-****************************************************************************************
* Method: receiveBleCmd
* Description: receive ble command
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)receiveBleCmd:(int)cmdId withObject:(id)object {
    PPGCmdNumber ppgCmd = (PPGCmdNumber)cmdId;
    
    switch (ppgCmd) {
        case PPGDFUFilePath: {
            NSString *pathString = (NSString *)object;
            m_dfuFilePath = pathString;
            m_cmdFileArray = [[NSMutableArray alloc] initWithArray:[m_PPGCmd ppgDFUForFilePath:m_dfuFilePath withMTU:20]];
            m_cmdCount = (int)m_cmdFileArray.count;
            m_sendCount = 0;
            break;
        }
            
        case PPGStartDFU: {
            NSData *cmdData = [m_PPGCmd ppgEnterOtaMode];
            [self.delegate writeBleByte:cmdData];
            break;
        }
            
        default:
            break;
    }
}


/*-****************************************************************************************
* Method: receiveBleData
* Description: receive ble result
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)receiveBleData:(NSData *)hexData withUuid:(CBUUID *)uuid {
    if ([FBKSpliceBle compareUuid:uuid withUuid:FBK_DEVICE_OTA_NOTIFY]) {
        [self spliceData:hexData];
    }
}


/*-****************************************************************************************
* Method: bleErrorReconnect
* Description: receive ble error status
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)bleErrorReconnect {
    m_cmdCount = 0;
    m_dfuFilePath = @"";
    [m_cmdFileArray removeAllObjects];
}


/*-******************************************************************************
* 方法名称：getRateData
* 功能描述：解析心率数据
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)spliceData:(NSData *)resultData {
    const uint8_t *bytes = [resultData bytes];
    
    int length = (int)resultData.length;
    int lastNumber = bytes[length-1]&0xFF;
    int checkNumber = 0;
    for (int i = 0; i < length-1; i++) {
        int value = bytes[i];
        checkNumber = checkNumber + value;
    }
    
    if (lastNumber != checkNumber%256) {
        NSLog(@"checkNumber is error !!! ");
        return;
    }
    
    int headNumber = bytes[0]&0xFF;
    int cmdId = bytes[2]&0xFF;
    int status = bytes[3]&0xFF;
    if (headNumber == 16 && cmdId == 2 && status == 1) {
        if (m_cmdFileArray.count > 0) {
            NSArray *cmdArray = [m_cmdFileArray objectAtIndex:0];
            for (int i = 0; i < cmdArray.count; i++) {
                NSData *cmdData = [cmdArray objectAtIndex:i];
                [self.delegate writeBleByte:cmdData];
            }
            
            int progressNo = 0;
            [self.delegate analyticalBleData:[NSString stringWithFormat:@"%i",progressNo] withResultNumber:PPGDFUProgress];
        }
        else {
            [self.delegate analyticalBleData:@"0" withResultNumber:PPGDFUResult];
        }
    }
    else if (headNumber == 16 && cmdId == 3 && status == 0) {
        if (m_cmdFileArray.count > 0) {
            m_sendCount = m_sendCount+1;
            if (m_sendCount == 5) {
                NSData *cmdData = [m_PPGCmd ppgDFUComplete];
                [self.delegate writeBleByte:cmdData];
                return;
            }
            
            NSArray *cmdArray = [m_cmdFileArray objectAtIndex:0];
            for (int i = 0; i < cmdArray.count; i++) {
                NSData *cmdData = [cmdArray objectAtIndex:i];
                [self.delegate writeBleByte:cmdData];
            }
            
            int progressNo = 0;
            if (m_cmdCount != 0) {
                double myProgressNo = (double)(m_cmdCount-m_cmdFileArray.count) / (double)m_cmdCount;
                progressNo = (int)(round(myProgressNo*100));
            }
            [self.delegate analyticalBleData:[NSString stringWithFormat:@"%i",progressNo] withResultNumber:PPGDFUProgress];
        }
    }
    else if (headNumber == 16 && cmdId == 3 && status == 1) {
        m_sendCount = 0;
        if (m_cmdFileArray.count > 0) {
            [m_cmdFileArray removeObjectAtIndex:0];
            
            if (m_cmdFileArray.count > 0) {
                NSArray *cmdArray = [m_cmdFileArray objectAtIndex:0];
                for (int i = 0; i < cmdArray.count; i++) {
                    NSData *cmdData = [cmdArray objectAtIndex:i];
                    [self.delegate writeBleByte:cmdData];
                }
                
                int progressNo = 0;
                if (m_cmdCount != 0) {
                    double myProgressNo = (double)(m_cmdCount-m_cmdFileArray.count) / (double)m_cmdCount;
                    progressNo = (int)(round(myProgressNo*100));
                }
                [self.delegate analyticalBleData:[NSString stringWithFormat:@"%i",progressNo] withResultNumber:PPGDFUProgress];
            }
            else {
                NSData *cmdData = [m_PPGCmd ppgDFUComplete];
                [self.delegate writeBleByte:cmdData];
                return;
            }
        }
        else {
            NSData *cmdData = [m_PPGCmd ppgDFUComplete];
            [self.delegate writeBleByte:cmdData];
            return;
        }
    }
    else if (headNumber == 16 && cmdId == 5 && status == 0) {
        [self.delegate analyticalBleData:@"0" withResultNumber:PPGDFUResult];
    }
    else if (headNumber == 16 && cmdId == 5 && status == 1) {
        [self.delegate analyticalBleData:@"1" withResultNumber:PPGDFUResult];
    }
}


@end
