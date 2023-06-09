/***************************************************************************
 * 文件名称：CFileOperate.m
 * 内容摘要：文件存储类
 * 版本编号：1.0.1
 * 创建日期：2016年03月10日
 ***************************************************************************/

#import "CFileOperate.h"

@implementation CFileOperate

/***********************************************************************
 * 方法名称： fileInBundle：
 * 功能描述： 得到Bundle文件
 * 输入参数： fileName - 文件名称   typeName - 文件格式
 * 输出参数： 文件路径（字符串）
 ***********************************************************************/ 
- (NSString *)fileInBundle:(NSString *)fileName withType:(NSString *)typeName
{
    if (![fileName isMemberOfClass:[NSNull class]] &&
        fileName != nil &&
        ![typeName isMemberOfClass:[NSNull class]] &&
        typeName != nil)
    {
        return [[NSBundle mainBundle] pathForResource:fileName ofType:typeName];
    }
    else
    {
        return nil;
    }
}

/***********************************************************************
 * 方法名称： dataFilePath：
 * 功能描述： 获取文件路径
 * 输入参数： fileName - 文件名称
 * 返回数据： 文件路径（字符串）
 ***********************************************************************/
- (NSString *)dataFilePath:(NSString *)fileName
{
    if (![fileName isMemberOfClass:[NSNull class]] && fileName != nil )
    {
        if (fileName.length != 0)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            return [documentsDirectory stringByAppendingPathComponent:fileName];
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}

/***********************************************************************
 * 方法名称： saveDataToFile：withName：
 * 功能描述： 保存data文件
 * 输入参数： dataData - data数据     fileName - 文件名称
 * 返回数据： 返回YES保存成功  返回NO保存失败
 ***********************************************************************/
- (BOOL)saveDataToFile:(NSData *)dataData withName:(NSString *)fileName
{
    if ([self dataFilePath:fileName] != nil &&
        dataData != nil &&
        ![dataData isMemberOfClass:[NSNull class]])
    {
        if (dataData.length != 0)
        {
            [dataData writeToFile:[self dataFilePath:fileName] atomically:YES];
            return YES;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return NO;
    }
}

/***********************************************************************
 * 方法名称： saveArrayToFile：withName：
 * 功能描述： 保存数组文件
 * 输入参数： arrayData - 数组数据     fileName - 文件名称
 * 返回数据： 返回YES保存成功  返回NO保存失败
 ***********************************************************************/
- (BOOL)saveArrayToFile:(NSArray *)arrayData withName:(NSString *)fileName
{
    if ([self dataFilePath:fileName] != nil &&
        arrayData != nil &&
        ![arrayData isMemberOfClass:[NSNull class]])
    {
        if (arrayData.count != 0)
        {
            [arrayData writeToFile:[self dataFilePath:fileName] atomically:YES];
            return YES;
        }
        else
        {
            [arrayData writeToFile:[self dataFilePath:fileName] atomically:YES];
            return YES;
        }
    }
    else
    {
        return NO;
    }
}

/***********************************************************************
 * 方法名称： saveDictionaryToFile：withName：
 * 功能描述： 保存字典文件
 * 输入参数： dictionaryData - 字典数据     fileName - 文件名称
 * 返回数据： 返回YES保存成功  返回NO保存失败
 ***********************************************************************/
- (BOOL)saveDictionaryToFile:(NSDictionary *)dictionaryData withName:(NSString *)fileName
{    
    if ([self dataFilePath:fileName] != nil &&
        dictionaryData != nil &&
        ![dictionaryData isMemberOfClass:[NSNull class]])
    {
        if (dictionaryData.allKeys.count != 0)
        {
            [dictionaryData writeToFile:[self dataFilePath:fileName] atomically:YES];
            return YES;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return NO;
    }
}

/***********************************************************************
 * 方法名称： saveStringToFile：withName：
 * 功能描述： 保存字符串文件
 * 输入参数： stringData - 字符串型数据     fileName - 文件名称
 * 返回数据： 返回YES保存成功  返回NO保存失败
 ***********************************************************************/
- (BOOL)saveStringToFile:(NSString *)stringData withName:(NSString *)fileName
{    
    if ([self dataFilePath:fileName] != nil &&
        stringData != nil &&
        ![stringData isMemberOfClass:[NSNull class]])
    {
        if (stringData.length != 0)
        {
            [stringData writeToFile:[self dataFilePath:fileName]
                         atomically:YES
                           encoding:NSUTF8StringEncoding
                              error:nil];
            return YES;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return NO;
    }
}

/***********************************************************************
 * 方法名称： getDataFromFile:
 * 功能描述： 从文件中得到data数据
 * 输入参数： fileName - 文件名称
 * 返回数据： NSData数据
 ***********************************************************************/
- (NSData *)getDataFromFile:(NSString *)fileName
{
    NSString *filePath = [self dataFilePath:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        m_data = [[NSData alloc] initWithContentsOfFile:filePath];
        return m_data;
    }
    else
    {
        return nil;
    }
}

/***********************************************************************
 * 方法名称： getArrayFromFile:
 * 功能描述： 从文件中得到数组数据
 * 输入参数： fileName - 文件名称
 * 返回数据： NSArray数据
 ***********************************************************************/
- (NSArray *)getArrayFromFile:(NSString *)fileName
{
    NSString *filePath = [self dataFilePath:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        m_array = [[NSArray alloc] initWithContentsOfFile:filePath];
        return m_array;
    }
    else
    {
        return nil;
    }
}

/***********************************************************************
 * 方法名称： getDctionaryFromFile:
 * 功能描述： 从文件中得到字典数据
 * 输入参数： fileName - 文件名称
 * 返回数据： NSDictionary数据
 ***********************************************************************/
- (NSDictionary *)getDctionaryFromFile:(NSString *)fileName
{
    NSString *filePath = [self dataFilePath:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        m_dictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        return m_dictionary;
    }
    else
    {
        return nil;
    }
}

/***********************************************************************
 * 方法名称： getStringFromFile:
 * 功能描述： 从文件中得到字符串数据
 * 输入参数： fileName - 文件名称
 * 返回数据： NSString数据
 ***********************************************************************/
- (NSString *)getStringFromFile:(NSString *)fileName
{
    NSString *filePath = [self dataFilePath:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        m_string = [[NSString alloc] initWithContentsOfFile:filePath
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
        return m_string;
    }
    else
    {
        return nil;
    }
}

@end
