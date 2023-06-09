/***************************************************************************
 * 文件名称：CFileOperate.h
 * 内容摘要：文件存储类
 * 版本编号：1.0.1
 * 创建日期：2016年03月10日
 ***************************************************************************/

#import <Foundation/Foundation.h>

@interface CFileOperate : NSObject
{
    NSData       *m_data;        // 得到的二进制数据
    NSArray      *m_array;       // 得到的数组数据
    NSDictionary *m_dictionary;  // 得到的字典数据
    NSString     *m_string;      // 得到的字符串数据
}

// 得到Bundle文件
- (NSString *)fileInBundle:(NSString *)fileName withType:(NSString *)typeName;

// 得到文件的路径
- (NSString *)dataFilePath:(NSString *)fileName;

// 保存data到文件
- (BOOL)saveDataToFile:(NSData *)dataData withName:(NSString *)fileName;

// 保存数组到文件
- (BOOL)saveArrayToFile:(NSArray *)arrayData withName:(NSString *)fileName;

// 保存字典到文件
- (BOOL)saveDictionaryToFile:(NSDictionary *)dictionaryData withName:(NSString *)fileName;

// 保存字符串到文件
- (BOOL)saveStringToFile:(NSString *)stringData withName:(NSString *)fileName;

// 从文件中得到data数据
- (NSData *)getDataFromFile:(NSString *)fileName;

// 从文件中得到数组数据
- (NSArray *)getArrayFromFile:(NSString *)fileName;

// 从文件中得到字典数据
- (NSDictionary *)getDctionaryFromFile:(NSString *)fileName;

// 从文件中得到字符串数据
- (NSString *)getStringFromFile:(NSString *)fileName;


//使用示例

/*************************************************************************** 
 本示例以字典数据为准，如需要其他数据，您只要按照其他数据的规则并调用对应的方法即可
 
 // 导入头文件 #import "CFileOperations.h"
 // DEFAULT_DATA - 文件名
 
 CFileOperations *CFile = [[CFileOperations alloc] init];
 NSMutableDictionary *testDic = [[NSMutableDictionary alloc] init];
 [testDic setObject:m_testField.text forKey:@"1"];
 
 // 保存数据（调用的方法）
 BOOL successed = [CFile saveDictionaryToFile:testDic withName:DEFAULT_DATA];
 [testDic release];
 
 // 得到数据（调用的方法）
 NSDictionary *testDic = [[NSDictionary alloc] initWithDictionary:[CFile getDctionaryFromFile:DEFAULT_DATA]];
 
 m_testView.text = [testDic objectForKey:@"1"];

 ***************************************************************************/

@end
