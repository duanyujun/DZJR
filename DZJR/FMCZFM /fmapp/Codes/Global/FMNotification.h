//
//  FMNotification.h
//  fmapp
//
//  Created by 李 喻辉 on 14-6-15.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#ifndef fmapp_FMNotification_h
#define fmapp_FMNotification_h

#define FMInformationChangeNotification        @"FMInformationChangeNotification"

//定位成功后的消息
#define FMLocationSuccessNotification           @"FMLocationSuccessNotification"

//用户登陆成功后广播此消息
#define FMUserLoginNotification                 @"FMLoginNotification"

//用户发布新问题成功后广播此消息
#define FMPublishNewQuestionNotification        @"FMPublishNewQuestionNotification"

//用户回复问题成功后广播此消息
#define FMPublishNewAnswerNotification          @"FMPublishNewAnswerNotification"

//用户删除问题成功后广播此消息
#define FMDeleteQuestionNotification           @"FMDeleteQuestionNotification"

//用户删除问题回复成功后广播此消息
#define FMDeleteReplyNotification              @"FMDeleteReplyNotification"

//用户互动消息推送
#define FMInteractionNotification               @"FMInteractionNotification"

//上报新路况成功后的消息
#define FMAddRoadConditionNotification          @"FMAddRoadConditionNotification"


///退出登录时使用通知
#define FMUserLogoutNotification                @"FMLoginOutNotification"


//头像信息更新消息
#define FMUserAvatarModifyNotification          @"FMUserAvatarModifyNotification"

#define FMUserBrandImageModifyNotification       @"FMUserBrandImageModifyNotification"


///摇一摇奖品列表查看通知
#define FMUserShakeAndShakePrizeListNotification @"FMUserShakePrizeListNotification"
///二手车苹果结果通知
#define FMUserSecondHandCarResultNotification   @"FMSecondHandCarResultNotification"

///主题修改通知
#define FMThemeChangedNotification              @"FMThemeChangedNotification"
///设置支付宝快捷支付通知
#define FMAliPayOperationNotification           @"FMAliPayOperationNotification"

//IM p2p 结束聊天通知消息
#define FMIMP2PChatFinishNotification           @"FMIMP2PChatFinishNotification"

//圈子消息发布成功消息
#define FMCircleMessagePublishNotification      @"FMCircleMessagePublishNotification"

#define FMFriendCircleSendPostInforNotification @"FMFriendCircleSendPostInforNotification"

///用户切换圈子通知
#define FMUserChangedFriendCircleNotification   @"FMUserChangedFriendCircleNotification"


///刷新猜我喜欢数据
#define FMEnterForegroundNotificationn               @"FMEnterForegroundNotificationn"
///修改个人资料
#define FMChangeMyInformationNotification            @"FMChangeMyInformationNotification"

///首页小红点内容处理
#define FMHomeModulePushNotification            @"FMHomeModulePushNotification"

#define FMCloseLeftViewNotification             @"FMCloseLeftViewNotification"

#define FMLogNotification                          @"FMLogNotification"


#define FMManageGestureNotification               @"FMManageGestureNotification"

#endif
