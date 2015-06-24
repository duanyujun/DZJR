//
//  FMSettings.m
//  FM_CZFW
//
//  Created by liyuhui on 14-4-14.
//  Copyright (c) 2014年 ETelecom. All rights reserved.
//

#import "FMSettings.h"

@interface FMSettings ()
/** 判断用户是否公开自己的位置
 
 *@See 若未进行设置，则默认为公开。
 *@See 若进行了设置，YES，表示公开位置；NO，表示不公开自己的位置
 ***/
- (BOOL)agreePublicLocation;
/** 初始化用户是否公开自己的位置参数
 
 *@See 若未进行设置，则默认为公开。
 *@See 若进行了设置，YES，表示公开位置；NO，表示不公开自己的位置
 ***/
- (void)setAgreePublicLocation:(BOOL)bAgree;

@end

@implementation FMSettings
+ (FMSettings *)sharedSettings
{
    static FMSettings *_sharedSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSettings = [[FMSettings alloc] init];
    });
    
    return _sharedSettings;
}
- (id)init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    //初始化表情数据
    _expressionNameArray = @[
                             @"微笑",@"撇嘴", @"色",@"发呆",@"得意",@"流泪",
                             @"害羞",@"闭嘴",@"睡", @"大哭",@"发怒",@"调皮",
                             @"龇牙", @"惊讶", @"快哭了",@"抓狂",@"吐",
                             @"偷笑",@"愉快",@"白眼",@"傲慢",@"饥饿",@"困",
                             @"惊恐",@"流汗",@"憨笑",@"大兵",@"奋斗",@"咒骂",
                             @"疑问",@"嘘",@"晕",@"疯了",@"衰",@"骷髅",
                             @"敲打",@"再见", @"擦汗",@"抠鼻",@"鼓掌",
                             @"糗大了",@"坏笑",@"左哼哼",@"右哼哼",@"哈欠",
                             @"鄙视",@"委屈",@"奸笑",@"亲亲",@"可怜",
                             @"菜刀",@"西瓜",@"啤酒",@"足球",@"咖啡",
                             @"饭", @"猪头",@"玫瑰",@"凋谢",@"嘴唇",
                             @"爱心",@"心碎",@"蛋糕",@"闪电", @"炸弹",
                             @"便便",@"月亮",@"太阳",@"抱抱",@"强",
                             @"弱",@"握手", @"胜利",@"抱拳",@"勾引",
                             @"拳头",@"差劲",@"爱你",@"沙发",@"药", @"奶瓶",
                             @"OK",@"NO",@"礼物",@"喝彩",@"彩球",@"打伞",
                             @"鞭炮",@"灯笼",@"祈祷",@"双喜",@"帅",@"熊猫",
                             @"青蛙",@"香蕉",@"钻戒",@"灯泡",@"闹钟",@"纸巾",
                             @"钞票",@"K歌",@"手枪",@"飞机",@"开车"];
    _expressionNameCodeArray = @[@"f_001",@"f_002",@"f_003",@"f_004",@"f_005",
                                 @"f_006",@"f_007",@"f_008",@"f_009",@"f_010",
                                 @"f_011",@"f_012",@"f_013",@"f_014",@"f_015",
                                 @"f_016",@"f_017",@"f_018",@"f_019",@"f_020",
                                 @"f_021",@"f_022",@"f_023",@"f_024",@"f_025",
                                 @"f_026",@"f_027",@"f_028",@"f_029",@"f_030",
                                 @"f_031",@"f_032",@"f_033",@"f_034",@"f_035",
                                 @"f_036",@"f_037",@"f_038",@"f_039",@"f_040",
                                 @"f_041",@"f_042",@"f_043",@"f_044",@"f_045",
                                 @"f_046",@"f_047",@"f_048",@"f_049",@"f_050",
                                 @"f_051",@"f_052",@"f_053",@"f_054",@"f_055",
                                 @"f_056",@"f_057",@"f_058",@"f_059",@"f_060",
                                 @"f_061",@"f_062",@"f_063",@"f_064",@"f_065",
                                 @"f_066",@"f_067",@"f_068",@"f_069",@"f_070",
                                 @"f_071",@"f_072",@"f_073",@"f_074",@"f_075",
                                 @"f_076",@"f_077",@"f_078",@"f_079",@"f_080",
                                 @"f_081",@"f_082",@"f_083",@"f_084",@"f_085",
                                 @"f_086",@"f_087",@"f_088",@"f_089",@"f_090",
                                 @"f_091",@"f_092",@"f_093",@"f_094",@"f_095",
                                 @"f_096",@"f_097",@"f_098",@"f_099",@"f_100",
                                 @"f_101",@"f_102",@"f_103",@"f_104",];
    
    _placeCodesArray = @[@"370102000000",
                         @"370103000000",
                         @"370104000000",
                         @"370105000000",
                         @"370112000000",
                         @"370197000000",
                         @"370190000000",
                         @"370113000000"];
    
    _placesNamesArray = @[@"历下区",
                          @"市中区",
                          @"槐荫区",
                          @"天桥区",
                          @"历城区",
                          @"高新区",
                          @"高架路",
                          @"长清区"];
    
    
    
    return self;
}

#pragma mark -
- (BOOL)agreePublicLocation
{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"AgreeOpenUserLocation"]) {
        return YES;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"AgreeOpenUserLocation"];
}

/** 初始化用户是否公开自己的位置参数
 
 *@See 若未进行设置，则默认为公开。
 *@See 若进行了设置，YES，表示公开位置；NO，表示不公开自己的位置
 ***/
- (void)setAgreePublicLocation:(BOOL)bAgree
{
    [[NSUserDefaults standardUserDefaults] setBool:bAgree forKey:@"AgreeOpenUserLocation"];
}


- (void)setUserShakeAndShakeAudioClosed:(BOOL)userShakeAndShakeAudioClosed{
    [[NSUserDefaults standardUserDefaults] setBool:userShakeAndShakeAudioClosed forKey:@"UserShakedCloseAudio"];
}

- (BOOL)userShakeAndShakeAudioClosed{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"UserShakedCloseAudio"]) {
        return NO;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"UserShakedCloseAudio"];
    
}

//TODO:1. 启动页广告内容
- (BOOL)appDelegateAdvertisementBool{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"AdvertisementBoolInfor"]) {
        return NO;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"AdvertisementBoolInfor"];
}

- (void)setAppDelegateAdvertisementBool:(BOOL)appDelegateAdvertisementBool{
    [[NSUserDefaults standardUserDefaults]setBool:appDelegateAdvertisementBool forKey:@"AdvertisementBoolInfor"];
}

- (void)setAppDelegateAdvertisementImageURL:(NSString *)appDelegateAdvertisementImageURL{
    [[NSUserDefaults standardUserDefaults] setObject:appDelegateAdvertisementImageURL forKey:@"AdvertisementImageURL"];
}

- (NSString *)appDelegateAdvertisementImageURL{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"AdvertisementImageURL"]) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"AdvertisementImageURL"];
}

- (void)setAppDelegateAdvertisementIdentifier:(NSString *)appDelegateAdvertisementIdentifier{
    [[NSUserDefaults standardUserDefaults] setObject:appDelegateAdvertisementIdentifier forKey:@"AdvertisementIdentifier"];
    
    }

- (NSString *)appDelegateAdvertisementIdentifier{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"AdvertisementIdentifier"]) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"AdvertisementIdentifier"];
}

//TODO:2.系统版本信息内容
- (void)setAppProgramiPhoneVersionNumber:(CGFloat)appProgramiPhoneVersionNumber{
    [[NSUserDefaults standardUserDefaults] setFloat:appProgramiPhoneVersionNumber forKey:@"VersionNumber"];
}

- (CGFloat)appProgramiPhoneVersionNumber{
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"VersionNumber"];
}

//TODO:3.摇一摇奖品列表相关内容
- (void)setAppPushPrizeListInforLatestIdentifier:(NSInteger)appPushPrizeListInforLatestIdentifier{
    
    //获取原有的ID
    NSInteger oldInteger = [[NSUserDefaults standardUserDefaults] integerForKey:@"PrizeListInforLatestId"];
    
    //比较大小，若新的ID大于现在的，则将写入本地，并记为可标记小红点
    if (appPushPrizeListInforLatestIdentifier > oldInteger) {
        [[NSUserDefaults standardUserDefaults] setInteger:appPushPrizeListInforLatestIdentifier forKey:@"PrizeListInforLatestId"];
        [FMShareSetting setAppPushPrizeListInforBool:YES];
    }
}

- (NSInteger)appPushPrizeListInforLatestIdentifier{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"PrizeListInforLatestId"];
}

- (void)setAppPushPrizeListInforBool:(BOOL)appPushPrizeListInforBool{
    [[NSUserDefaults standardUserDefaults]setBool:appPushPrizeListInforBool forKey:@"PrizeListInforBool"];
}

- (BOOL)appPushPrizeListInforBool{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"PrizeListInforBool"]) {
        return YES;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"PrizeListInforBool"];
}

//TODO:4.电台活动列表相关内容
- (void)setAppPushRadioActivityLatestIdentifier:(NSInteger)appPushRadioActivityLatestIdentifier{
    //获取原有的ID
    NSInteger oldInteger = [[NSUserDefaults standardUserDefaults] integerForKey:@"RadioActivityLatestId"];
    if (appPushRadioActivityLatestIdentifier > oldInteger) {
        [[NSUserDefaults standardUserDefaults] setInteger:appPushRadioActivityLatestIdentifier forKey:@"RadioActivityLatestId"];
        [FMShareSetting setAppPushRadioActivityBool:YES];
    }
}

- (NSInteger)appPushRadioActivityLatestIdentifier{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"RadioActivityLatestId"];
}

- (BOOL)appPushRadioActivityBool{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"RadioActivityBool"]) {
        return YES;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"RadioActivityBool"];
}

- (void)setAppPushRadioActivityBool:(BOOL)appPushRadioActivityBool{
    [[NSUserDefaults standardUserDefaults]setBool:appPushRadioActivityBool forKey:@"RadioActivityBool"];
}


//TODO:5.最新电台资讯内容
- (void)setAppPushRadioAnnouncementLatestIdentifier:(NSInteger)appPushRadioAnnouncementLatestIdentifier{
    //获取原有的ID
    NSInteger oldInteger = [[NSUserDefaults standardUserDefaults] integerForKey:@"RadioAnnouncementLatestId"];
    if (appPushRadioAnnouncementLatestIdentifier > oldInteger) {
        [[NSUserDefaults standardUserDefaults]setInteger:appPushRadioAnnouncementLatestIdentifier forKey:@"RadioAnnouncementLatestId"];
        [FMShareSetting setAppPushRadioAnnouncementBool:YES];
    }
}

- (NSInteger)appPushRadioAnnouncementLatestIdentifier{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"RadioAnnouncementLatestId"];
}

- (BOOL)appPushRadioAnnouncementBool{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"RadioAnnouncementBool"]) {
        return YES;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"RadioAnnouncementBool"];
}

- (void)setAppPushRadioAnnouncementBool:(BOOL)appPushRadioAnnouncementBool{
    [[NSUserDefaults standardUserDefaults]setBool:appPushRadioAnnouncementBool forKey:@"RadioAnnouncementBool"];
}

- (void)setAppDelegateAdvertisementImageSize:(CGSize)appDelegateAdvertisementImageSize{
    
    NSDictionary *imageSizeDicionary = @{@"width":[NSNumber numberWithFloat:appDelegateAdvertisementImageSize.width], @"height":[NSNumber numberWithFloat:appDelegateAdvertisementImageSize.height]};
    [[NSUserDefaults standardUserDefaults] setObject:imageSizeDicionary forKey:@"AdvertisementImageSize"];
}

- (CGSize)appDelegateAdvertisementImageSize{
    
//    if (HUIIsIPhone5()) {
//        return CGSizeMake(320.0f, 483.0f);
//    }else{
//        return CGSizeMake(320.0f, 398);
//    }
    
    if (HUIIsIPhone5()) {
        if(KProjectScreenWidth>=414)
        {
            return CGSizeMake(KProjectScreenWidth, KProjectScreenHeight-112);

        }
        else if (KProjectScreenWidth>=375&&KProjectScreenWidth<414)
        {
            return CGSizeMake(KProjectScreenWidth, KProjectScreenHeight-100);
 
        }
        else
        {
            return CGSizeMake(KProjectScreenWidth, KProjectScreenHeight-85);
 
        }
    }else{
        
        return CGSizeMake(KProjectScreenWidth, KProjectScreenHeight-82);
    }

}

//TODO:6.新违章推送提醒
-(void)setAppPushMePersonalViolationMsgInforBool:(BOOL)appPushMePersonalViolationMsgInforBool{
    [[NSUserDefaults standardUserDefaults]setBool:appPushMePersonalViolationMsgInforBool forKey:@"ViolationMsgInforBool"];
}

- (BOOL)appPushMePersonalViolationMsgInforBool{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"ViolationMsgInforBool"]) {
        return NO;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ViolationMsgInforBool"];
}

//TODO:7.最新的二手车评估结果推送提醒
- (void)setAppPushExploreSecondCarResultInforBool:(BOOL)appPushExploreSecondCarResultInforBool{
    [[NSUserDefaults standardUserDefaults]setBool:appPushExploreSecondCarResultInforBool forKey:@"ExploreSecondCarResultInforBool"];
}

- (BOOL)appPushExploreSecondCarResultInforBool{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"ExploreSecondCarResultInforBool"]) {
        return NO;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ExploreSecondCarResultInforBool"];
    
}

//TODO:8.最新的特约内容提醒推送提醒

- (NSInteger)appPushExploreSpecialBusinessLatestIdentifier{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"SpecialBusinessLatestIdentifier"];
}

- (void)setAppPushExploreSpecialBusinessLatestIdentifier:(NSInteger)appPushExploreSpecialBusinessLatestIdentifier{
    //获取原有的ID
    NSInteger oldInteger = [[NSUserDefaults standardUserDefaults] integerForKey:@"SpecialBusinessLatestIdentifier"];
    if (appPushExploreSpecialBusinessLatestIdentifier > oldInteger) {
        [[NSUserDefaults standardUserDefaults]setInteger:appPushExploreSpecialBusinessLatestIdentifier forKey:@"SpecialBusinessLatestIdentifier"];
        [FMShareSetting setAppPushExploreSpecialBusinessInforBool:YES];
    }
}

- (void)setAppPushExploreSpecialBusinessInforBool:(BOOL)appPushExploreSpecialBusinessInforBool{
    [[NSUserDefaults standardUserDefaults]setBool:appPushExploreSpecialBusinessInforBool forKey:@"SpecialBusinessInforBool"];
}

- (BOOL)appPushExploreSpecialBusinessInforBool{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"SpecialBusinessInforBool"]) {
        return NO;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"SpecialBusinessInforBool"];
}

- (void)setAppProgramPersonalityThemeIndexInteger:(NSInteger)appProgramPersonalityThemeIndexInteger{
    [[NSUserDefaults standardUserDefaults] setInteger:appProgramPersonalityThemeIndexInteger forKey:@"PersonalityThemeIndexInteger"];
}

- (NSInteger)appProgramPersonalityThemeIndexInteger{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"PersonalityThemeIndexInteger"]) {
        return 3;
    }
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"PersonalityThemeIndexInteger"];
}

- (void)setUserPersonalSendEditedContentString:(NSString *)userPersonalSendEditedContentString{
    [[NSUserDefaults standardUserDefaults] setObject:userPersonalSendEditedContentString forKey:@"PersonalSendEditedContent"];
}

- (NSString *)userPersonalSendEditedContentString{
    if (![[NSUserDefaults standardUserDefaults]stringForKey:@"PersonalSendEditedContent"]) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"PersonalSendEditedContent"];
}

- (void)setUserOperationAliPayNSURLInformation:(NSURL *)userOperationAliPayNSURLInformation{
    
    Log(@" setup userOperationAliPayNSURLInformation is %@",userOperationAliPayNSURLInformation);
    [[NSUserDefaults standardUserDefaults] setURL:userOperationAliPayNSURLInformation forKey:@"UserOperationAliPayNSURLInformation"];
}

- (NSURL *)userOperationAliPayNSURLInformation{
    if (![[NSUserDefaults standardUserDefaults]URLForKey:@"UserOperationAliPayNSURLInformation"]) {
        return Nil;
    }
    
    Log(@"getup is %@",[[NSUserDefaults standardUserDefaults] URLForKey:@"UserOperationAliPayNSURLInformation"]);
    return [[NSUserDefaults standardUserDefaults] URLForKey:@"UserOperationAliPayNSURLInformation"];
}

// 命令流水号(messageId)
- (void)setAppUserPersonalSEQForIMNSinteger:(NSInteger)appUserPersonalSEQForIMNSinteger{
    [[NSUserDefaults standardUserDefaults] setInteger:appUserPersonalSEQForIMNSinteger forKey:@"appUserPersonalSEQForIMNSintegerTag"];
}

- (NSInteger)appUserPersonalSEQForIMNSinteger{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"appUserPersonalSEQForIMNSintegerTag"]) {
        return 1;
    }
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"appUserPersonalSEQForIMNSintegerTag"];
}


#pragma mark - SystemMessage系统通知提醒信息ID

- (void)setAppUserSystemMessagePushLatestId:(NSString *)appUserSystemMessagePushLatestId{
    [[NSUserDefaults standardUserDefaults] setObject:appUserSystemMessagePushLatestId forKey:@"AppUserSystemMessagePushLatestID"];
}


- (NSString *)appUserSystemMessagePushLatestId{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"AppUserSystemMessagePushLatestID"]) {
        return @"0";
    }
    
    return [[NSUserDefaults standardUserDefaults]stringForKey:@"AppUserSystemMessagePushLatestID"];
}


- (void)setAppUserSystemMessageHasNORead:(BOOL)appUserSystemMessageHasNORead{
    [[NSUserDefaults standardUserDefaults] setBool:appUserSystemMessageHasNORead forKey:@"AppUserSystemMessageHasNORead"];
}

- (BOOL)appUserSystemMessageHasNORead{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"AppUserSystemMessageHasNORead"]) {
        return YES;
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"AppUserSystemMessageHasNORead"];
}

#pragma mark - 精品推荐通知提醒信息ID

- (void)setAppUserBusinessRecommendPushLatestId:(NSString *)appUserBusinessRecommendPushLatestId{
    [[NSUserDefaults standardUserDefaults] setObject:appUserBusinessRecommendPushLatestId forKey:@"AppUserBusinessRecommendPushLatestID"];
}

- (NSString *)appUserBusinessRecommendPushLatestId{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"AppUserBusinessRecommendPushLatestID"]) {
        return @"0";
    }
    
    return [[NSUserDefaults standardUserDefaults]stringForKey:@"AppUserBusinessRecommendPushLatestID"];
}

- (void)setAppUserFriendCirclePushLatesQuestionID:(NSString *)appUserFriendCirclePushLatesQuestionID{
     [[NSUserDefaults standardUserDefaults] setObject:appUserFriendCirclePushLatesQuestionID forKey:@"AppUserFriendCirclePushLatesQuestionID"];
}
- (NSString *)appUserFriendCirclePushLatesQuestionID{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"AppUserFriendCirclePushLatesQuestionID"]) {
        return @"0";
    }
    
    return [[NSUserDefaults standardUserDefaults]stringForKey:@"AppUserFriendCirclePushLatesQuestionID"];
}


- (void)setAppUserBusinessRecommendHasNORead:(BOOL)appUserBusinessRecommendHasNORead{
    [[NSUserDefaults standardUserDefaults] setBool:appUserBusinessRecommendHasNORead forKey:@"AppUserBusinessRecommendHasNORead"];
}

- (BOOL)appUserBusinessRecommendHasNORead{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"AppUserBusinessRecommendHasNORead"]) {
        return YES;
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"AppUserBusinessRecommendHasNORead"];
}

#pragma mark -  车友聚会通知提醒信息ID

- (void)setAppUserCarFriendsPartyPushLatestId:(NSString *)appUserCarFriendsPartyPushLatestId{
    [[NSUserDefaults standardUserDefaults] setObject:appUserCarFriendsPartyPushLatestId forKey:@"AppUserCarFriendsPartyPushLatestID"];
}

- (NSString *)appUserCarFriendsPartyPushLatestId{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"AppUserCarFriendsPartyPushLatestID"]) {
        return @"0";
    }
    return [[NSUserDefaults standardUserDefaults]stringForKey:@"AppUserCarFriendsPartyPushLatestID"];
}

- (void)setAppUserCarFriendsPartyHasNORead:(BOOL)appUserCarFriendsPartyHasNORead{
    [[NSUserDefaults standardUserDefaults] setBool:appUserCarFriendsPartyHasNORead forKey:@"AppUserCarFriendsPartyHasNORead"];
}

- (BOOL)appUserCarFriendsPartyHasNORead{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"AppUserCarFriendsPartyHasNORead"]) {
        return YES;
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"AppUserCarFriendsPartyHasNORead"];
}




#pragma mark - 朋友圈消息通知提醒信息ID
- (void)setAppUserFriendCirclePushLatestId:(NSString *)appUserFriendCirclePushLatestId{
        [[NSUserDefaults standardUserDefaults] setObject:appUserFriendCirclePushLatestId forKey:@"AppUserFriendCirclePushLatestID"];
}

- (NSString *)appUserFriendCirclePushLatestId{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"AppUserFriendCirclePushLatestID"]) {
        return @"0";
    }
    return [[NSUserDefaults standardUserDefaults]stringForKey:@"AppUserFriendCirclePushLatestID"];
}

- (void)setAppUserFriendCircleHasNORead:(BOOL)appUserFriendCircleHasNORead{
    [[NSUserDefaults standardUserDefaults] setBool:appUserFriendCircleHasNORead forKey:@"AppUserFriendCircleHasNORead"];
}

- (BOOL)appUserFriendCircleHasNORead{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"AppUserFriendCircleHasNORead"]) {
        return YES;
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"AppUserFriendCircleHasNORead"];
}


- (void)setAppUserFriendCircleCountMemberInteger:(NSInteger)appUserFriendCircleCountMemberInteger{
    [[NSUserDefaults standardUserDefaults] setInteger:appUserFriendCircleCountMemberInteger forKey:@"AppUserFriendCircleCountMemberInteger"];
}

- (NSInteger)appUserFriendCircleCountMemberInteger{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"AppUserFriendCircleCountMemberInteger"]) {
        return 0;
    }
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"AppUserFriendCircleCountMemberInteger"];
}

- (void)setAppUserPersonalChatUserIdString:(NSString *)appUserPersonalChatUserIdString {
    [[NSUserDefaults standardUserDefaults] setObject:appUserPersonalChatUserIdString forKey:@"AppUserPersonalChatUserIdString"];
}

- (NSString *)appUserPersonalChatUserIdString{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"AppUserPersonalChatUserIdString"]) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults]stringForKey:@"AppUserPersonalChatUserIdString"];
}


- (void)setAppFMInteractionUnReadCountInteger:(NSInteger)appFMInteractionUnReadCountInteger{
    [[NSUserDefaults standardUserDefaults] setInteger:appFMInteractionUnReadCountInteger forKey:@"AppFMInteractionUnReadCountInteger"];
}

- (NSInteger)appFMInteractionUnReadCountInteger{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"AppFMInteractionUnReadCountInteger"]) {
        return 0;
    }
    
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"AppFMInteractionUnReadCountInteger"];
}

- (void)setAgreeGestures:(BOOL)agreeGestures
{
    [[NSUserDefaults standardUserDefaults] setBool:agreeGestures forKey:@"AppUserAgreeGestures"];
}
- (BOOL)agreeGestures
{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"AppUserAgreeGestures"]) {
        return YES;
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"AppUserAgreeGestures"];
}

- (void)setOpenGuideView:(BOOL)openGuideView
{
    [[NSUserDefaults standardUserDefaults] setBool:openGuideView forKey:@"AppopenGuideView"];
}

- (BOOL)openGuideView
{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"AppopenGuideView"]) {
        return YES;
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"AppopenGuideView"];
}

- (void)setTabbarSelectIndex:(NSInteger)tabbarSelectIndex
{
    [[NSUserDefaults standardUserDefaults] setInteger:tabbarSelectIndex forKey:@"tabbarSelectIndex"];
}

- (NSInteger)tabbarSelectIndex
{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"tabbarSelectIndex"]) {
        return 0;
    }
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"tabbarSelectIndex"];
}
@end