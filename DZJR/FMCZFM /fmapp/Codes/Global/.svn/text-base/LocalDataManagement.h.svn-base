//
//  LocalDataManagement.h
//  CheYouHui
//
//  Created by Ma Yiming on 12-11-22.
//
//

#import <Foundation/Foundation.h>

#define  FMLocalManager [LocalDataManagement sharedLocalManager]

typedef enum {
    CYHUserLoginInfoFile,               //用户登录文件信息
    CYHUserDetailInfoFile,              //用户详情文件信息
    CYHCarLivingGuideInfoFile,          //车生活指南缓存文件数据
    CYHCarLivingGuideInfoDetailFile,    //车生活指南缓存文件详细数据
    CYHOwnerQuestionsAndAnswersFile,    //车主问答数据
    FMEmceeAndServiceDataFile,           //主持人和客服数据文件
    FMAPPPushDataFile,                  /**<请求推送参数内容*/
} CYHUserFileType;

@interface LocalDataManagement : NSObject

+ (LocalDataManagement* )sharedLocalManager;

//将用户的数据写入文件中
- (void) writeUserDataToFileWithDictionary : (NSDictionary *) userDataDictionary andUserDataType:(CYHUserFileType) userFileType;

//获取用户数据文件
-(NSDictionary *) getUserFileWithUserFileType:(CYHUserFileType) userFileType;

//获取用户数据文件路径
- (NSString *) getUserFilePathWithUserFileType : (CYHUserFileType) userFileType;

- (void) writeUserDataToFileWithUserName :(NSString *)userName WithUserID:(NSString *)userID;

-(NSString *)getUserNameWithUserId:(NSString *)userId;


@end
