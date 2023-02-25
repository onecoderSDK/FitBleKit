/*-****************************************************************************************
* Copyright: Technology Co., Ltd
* File Name: FBKPPGCmd.m
* Function : PPG Ble Command
* Editor   : Pendy
* Version  : 1.0.1
* Date     : 2021.07.09
 ******************************************************************************************/

#import "FBKPPGCmd.h"

@implementation FBKPPGCmd

/*-****************************************************************************************
* Method: ppgEnterOtaMode
* Description: PPG Enter Ota Mode
* Parameter:
* Return Data:
 ******************************************************************************************/
- (NSData *)ppgEnterOtaMode {
    int byteCount = 5;
    Byte bytes[byteCount];
    bytes[0] = (Byte) (0x10);
    bytes[1] = (Byte) (0x05);
    bytes[2] = (Byte) (0x01);
    bytes[3] = (Byte) (0x01);
    bytes[4] = (Byte) (0x00);
    
    int sunNumber = 0;
    for (int i = 0; i < byteCount; i++) {
        sunNumber = sunNumber + bytes[i];
    }
    bytes[byteCount-1] = (Byte) (sunNumber % 256);
    
    NSMutableData *resultData = [[NSMutableData alloc] init];
    [resultData appendBytes:bytes length:byteCount];
    return resultData;
}


/*-****************************************************************************************
* Method: ppgDFUComplete
* Description: PPG DFU Complete
* Parameter:
* Return Data:
 ******************************************************************************************/
- (NSData *)ppgDFUComplete {
    int byteCount = 5;
    Byte bytes[byteCount];
    bytes[0] = (Byte) (0x10);
    bytes[1] = (Byte) (0x05);
    bytes[2] = (Byte) (0x04);
    bytes[3] = (Byte) (0x01);
    bytes[4] = (Byte) (0x00);
    
    int sunNumber = 0;
    for (int i = 0; i < byteCount; i++) {
        sunNumber = sunNumber + bytes[i];
    }
    bytes[byteCount-1] = (Byte) (sunNumber % 256);
    
    NSMutableData *resultData = [[NSMutableData alloc] init];
    [resultData appendBytes:bytes length:byteCount];
    return resultData;
}


/*-****************************************************************************************
* Method: ppgDFUForFilePath
* Description: PPG DFU For File Path
* Parameter:
* Return Data:
 ******************************************************************************************/
- (NSArray *)ppgDFUForFilePath:(NSString *)filePath withMTU:(int)MTU {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    const uint8_t *fileBytes = [fileData bytes];
    int fileDataCount = (int)fileData.length;
    int oneBagCount = 4;
    int oneCmdCount = (MTU-4);
    int oneBagDataLength = oneCmdCount*oneBagCount;
    
    int cmdBagNumber = fileDataCount / oneBagDataLength;
    if (cmdBagNumber % oneBagDataLength != 0) {
        cmdBagNumber = cmdBagNumber + 1;
    }
    
    
    for (int i = 0; i < cmdBagNumber; i++) {
        NSMutableArray *bagCmdArray = [[NSMutableArray alloc] init];
        
        if (i == cmdBagNumber-1) {
            for (int j = 0; j < oneBagCount; j++) {
                int realCount = MTU;
                int startByte = i*oneBagDataLength + j*oneCmdCount;
                if (fileDataCount - startByte < MTU) {
                    realCount = fileDataCount - startByte + 4;
                }
                
                if (fileDataCount - startByte <= 0) {
                    realCount = 4;
                }
                
                Byte bytes[realCount];
                bytes[0] = (Byte) (j+17);
                bytes[1] = (Byte) (realCount);
                bytes[2] = (Byte) (i%256);
                bytes[realCount-1] = (Byte) (0);
                
                int cmdOffSet = 3;
                for (int h = startByte; h < startByte+oneCmdCount; h++) {
                    bytes[cmdOffSet] = fileBytes[h];
                    cmdOffSet = cmdOffSet + 1;
                }
                
                int sunNumber = 0;
                for (int i = 0; i < realCount; i++) {
                    sunNumber = sunNumber + bytes[i];
                }
                
                bytes[realCount-1] = (Byte) (sunNumber % 256);
                NSMutableData *resultData = [[NSMutableData alloc] init];
                [resultData appendBytes:bytes length:realCount];
                [bagCmdArray addObject:resultData];
            }
        }
        else {
            for (int j = 0; j < oneBagCount; j++) {
                Byte bytes[MTU];
                bytes[0] = (Byte) (j+17);
                bytes[1] = (Byte) (MTU);
                bytes[2] = (Byte) (i%256);
                bytes[MTU-1] = (Byte) (0);
                
                int startByte = i*oneBagDataLength + j*oneCmdCount;
                int cmdOffSet = 3;
                for (int h = startByte; h < startByte+oneCmdCount; h++) {
                    bytes[cmdOffSet] = fileBytes[h];
                    cmdOffSet = cmdOffSet + 1;
                }
                
                int sunNumber = 0;
                for (int i = 0; i < MTU; i++) {
                    sunNumber = sunNumber + bytes[i];
                }
                
                bytes[MTU-1] = (Byte) (sunNumber % 256);
                NSMutableData *resultData = [[NSMutableData alloc] init];
                [resultData appendBytes:bytes length:MTU];
                [bagCmdArray addObject:resultData];
            }
        }
        
        [resultArray addObject:bagCmdArray];
    }
    
    return resultArray;
}


@end
