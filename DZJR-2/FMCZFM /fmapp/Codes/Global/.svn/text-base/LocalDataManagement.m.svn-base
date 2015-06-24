//
//  LocalDataManagement.m
//  CheYouHui
//
//  Created by Ma Yiming on 12-11-22.
//
//

#import "LocalDataManagement.h"

@interface LocalDataManagement ()

//获得document路径
-(NSString *) getDocumentDirectory;

@end

@implementation LocalDataManagement

+ (LocalDataManagement* )sharedLocalManager
{
    static LocalDataManagement *_sharedLocalManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocalManager = [[LocalDataManagement alloc] init];
    });
    
    return _sharedLocalManager;
}

//将用户数据保存到文件中
- (void) writeUserDataToFileWithDictionary : (NSDictionary *) _userDataDictionary andUserDataType:(CYHUserFileType) userFileType
{
    NSDictionary *userDataDictionary = [[NSDictionary alloc] initWithDictionary:_userDataDictionary];
    
    NSString *fileDirectory = [[NSString alloc] initWithFormat:@"%@/UserData",[self getDocumentDirectory]];
    NSString *filePath = nil;
    
    //创建文件目录
    [self createDirectoryWithDirectory:fileDirectory];
    
    switch (userFileType) {
        case CYHUserLoginInfoFile:
            filePath = [[NSString alloc] initWithFormat:@"%@/userLoginInfo.plist",fileDirectory];
            break;
        case CYHUserDetailInfoFile:
            filePath = [[NSString alloc] initWithFormat:@"%@/userDetailInfo.plist",fileDirectory];
            break;
        case CYHCarLivingGuideInfoFile:
            filePath = [[NSString alloc] initWithFormat:@"%@/carLivingGuideInfoFile.plist",fileDirectory];
            break;
        case CYHCarLivingGuideInfoDetailFile:
            filePath = [[NSString alloc] initWithFormat:@"%@/carLivingGuideInfoDetailFile.plist",fileDirectory];
            break;
        case CYHOwnerQuestionsAndAnswersFile:
            filePath = [[NSString alloc] initWithFormat:@"%@/carOwnerQuestionsAndAnswersFile.data",fileDirectory];
            break;
        case FMEmceeAndServiceDataFile:
            filePath = [[NSString alloc] initWithFormat:@"%@/EmceeAndServiceData.plist",fileDirectory];
            break;
        default:
            break;
    }
    
    if (filePath) {
        [userDataDictionary writeToFile:filePath atomically:YES];
    }
}
- (void) writeUserDataToFileWithUserName :(NSString *)userName WithUserID:(NSString *)userID
{
    NSString *fileDirectory = [[NSString alloc] initWithFormat:@"%@/UserData/userInformation.plist",[self getDocumentDirectory]];
    
    
    NSMutableDictionary *userDataDictionary = nil;
    
    if([self isFileExistWithFilePath:fileDirectory])
    {
        userDataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:fileDirectory];
    }
    else
    {
        userDataDictionary=[[NSMutableDictionary alloc]init];
    }
    [userDataDictionary setValue:userName forKey:userID];

    [userDataDictionary writeToFile:fileDirectory atomically:YES];

}
-(NSString *)getUserNameWithUserId:(NSString *)userId
{
    NSDictionary *userDataDictionary = nil;

    NSString *fileDirectory = [[NSString alloc] initWithFormat:@"%@/UserData/userInformation.plist",[self getDocumentDirectory]];
    
    if([self isFileExistWithFilePath:fileDirectory])
    {
        userDataDictionary = [[NSDictionary alloc] initWithContentsOfFile:fileDirectory];
        
        NSString *userName=[userDataDictionary objectForKey:userId];
        
        if (userName) {
            return userName;
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
//获取用户数据文件路径
- (NSString *) getUserFilePathWithUserFileType : (CYHUserFileType) userFileType
{
    NSString *fileDirectory = [[NSString alloc] initWithFormat:@"%@/UserData",[self getDocumentDirectory]];
    NSString *filePath = nil;
    switch (userFileType) {
        case CYHUserLoginInfoFile:
            filePath = [[NSString alloc] initWithFormat:@"%@/userLoginInfo.plist",fileDirectory];
            break;
        case CYHUserDetailInfoFile:
            filePath = [[NSString alloc] initWithFormat:@"%@/userDetailInfo.plist",fileDirectory];
            break;
        case CYHCarLivingGuideInfoFile:
            filePath = [[NSString alloc] initWithFormat:@"%@/carLivingGuideInfoFile.plist",fileDirectory];
            break;
        case CYHCarLivingGuideInfoDetailFile:
            filePath = [[NSString alloc] initWithFormat:@"%@/carLivingGuideInfoDetailFile.plist",fileDirectory];
            break;
        case CYHOwnerQuestionsAndAnswersFile:
            filePath = [[NSString alloc] initWithFormat:@"%@/carOwnerQuestionsAndAnswersFile.data",fileDirectory];
            break;
        default:
            break;
    }
    return filePath;
}

//获取用户数据文件
-(NSDictionary *) getUserFileWithUserFileType:(CYHUserFileType) userFileType
{
    NSDictionary *userDataDictionary = nil;
    
    NSString *fileDirectory = [[NSString alloc] initWithFormat:@"%@/UserData",[self getDocumentDirectory]];
    NSString *filePath = nil;
    switch (userFileType) {
        case CYHUserLoginInfoFile:
            filePath = [[NSString alloc] initWithFormat:@"%@/userLoginInfo.plist",fileDirectory];
            break;
        case CYHUserDetailInfoFile:
            filePath = [[NSString alloc] initWithFormat:@"%@/userDetailInfo.plist",fileDirectory];
            break;
        case CYHCarLivingGuideInfoFile:
            filePath = [[NSString alloc] initWithFormat:@"%@/carLivingGuideInfoFile.plist",fileDirectory];
            break;
        case CYHCarLivingGuideInfoDetailFile:
            filePath = [[NSString alloc] initWithFormat:@"%@/carLivingGuideInfoDetailFile.plist",fileDirectory];
            break;
        case CYHOwnerQuestionsAndAnswersFile:
            filePath = [[NSString alloc] initWithFormat:@"%@/carOwnerQuestionsAndAnswersFile.data",fileDirectory];
            break;
        case FMEmceeAndServiceDataFile:
            filePath = [[NSString alloc] initWithFormat:@"%@/EmceeAndServiceData.plist",fileDirectory];
            break;
        default:
            break;
    }
    
    if([self isFileExistWithFilePath:filePath])
    {
        userDataDictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    }
    
    return userDataDictionary;
}

//如果没有目录则创建目录
-(void) createDirectoryWithDirectory:(NSString *) _directory
{
    NSString *directory = [[NSString alloc] initWithString:_directory];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:directory]) {//没有此目录则创建给目录
        [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

//判断文件是否存在
-(BOOL) isFileExistWithFilePath:(NSString *) filePath
{
    BOOL isFileExist = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        isFileExist = YES;
    }
    
    return isFileExist;
}

//获得Document路径
-(NSString *) getDocumentDirectory{
    return [NSString stringWithFormat:@"%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
}

@end
