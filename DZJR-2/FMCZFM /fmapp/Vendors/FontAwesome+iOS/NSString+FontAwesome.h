//
//  NSString+FontAwesome.h
//
//  Copyright (c) 2012 Alex Usbergo. All rights reserved.
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger,FMIconFont){
    FMIconNULL = 0,         /**< 空信息*/
    FMIconEditUser =1,      /**< 编辑信息*/
    FMIconList,             /**< 右上角更多操作*/
    FMIconFriend,           /**< 好友信息*/
    FMIconCenter,           /**< 中心位置*/
    FMIconCallPhone,        /**< 拨打电话*/
    FMIconActivityUser,     /**< 活动报名人数*/
    FMIconQRCode,           /**< 二维码扫描*/
    FMIconAddTie,           /**< 新建互动帖子*/
    FMIconHomeAddTie,       /**< 首页发互动帖子*/
    /**end 10****/
    FMIconLeftArrow,        /**< 向左侧箭头*/
    FMIconAttention,        /**< 关注*/
    FMIconShare,            /**< 分享*/
    FMIconMe,               /**< "我"模块*/
    FMIconMore,             /**< 更多*/
    FMIconBBS,/**< 不知道*/
    FMIconCancelCross,      /**< 交叉取消*/
    FMIconInteraction,      /**< 互动模块*/
    FMIconReplyCount,       /**< 回复数量*/
    FMIconVIPCard,          /**< 会员卡*/
    /**end 20****/
    FMIconRadio,            /**< 电台活动*/
    FMIconPriceList,        /**< 价目表*/
    FMIconKeyboard,         /**< 键盘*/
    FMIconMyPrize,          /**< 我的奖品*/
    FMIconCut,              /**< 截屏剪刀*/
    FMIconGoldCoin,         /**< 获取金币*/
    FMIconMale,             /**< 男性*/
    FMIconActivityInfor,    /**< 活动详情*/
    FMIconFemale,           /**< 女性*/
    FMIconRMB,              /**< 人民币*/
    /**end 30****/
    FMIconCancelLocation,   /**< 取消定位*/
    FMIconSubmitSend,       /**< 提交发送*/
    FMIconS,/**> 不清楚*/
    FMIconPullUp,           /**< 上拉*/
    FMIconSetup,            /**< 设置*/
    FMIconDateTime,         /**< 时间*/
    FMIconHome,             /**< 首页*/
    FMIconBigSearch,        /**< 大图搜索*/
    FMIconSearch,           /**< 小图搜索*/
    FMIconNewAdd,           /**< 新建添加*/
    /**end 40****/
    FMIconWZQuery,          /**< 违章查询*/
    FMIconPullDown,         /**< 下拉*/
    FMIconCamera,           /**< 相机*/
    FMIconReply,            /**< 回复提示*/
    FMIconMessage,          /**< 消息模块*/
    FMIconShakeList,        /**< 摇一摇列表*/
    FMIconShake,            /**< 摇一摇*/
    FMIconRightArrow,       /**< 向右侧箭头*/
    FMIconAgree,            /**< 点赞*/
    FMIconMapFriend,        /**< 地图上的车友*/
    /**end 50****/
    FMIconRadioPlay,        /**< 电台直播*/
    FMIconBusiness,         /**< 特约商户*/
    FMIconInsurance,        /**< 车险估算*/
    FMIconAnAgent,          /**< 年检代办*/
    FMIconSecondCar,        /**< 二手车评估*/
    FMIconDriving,          /**< 代驾*/
    FMIconMoreBreak,        /**< 违章多发*/
    FMIconAccident,         /**< 事故快处*/
    FMIconHighSpeed,        /**< 高速路况*/
    FMIconFreeCar,          /**< 都市顺风车*/
    /**end 60****/
    FMIconSearchModel,      /**< 找到了*/
    FMIconExpression,       /**< 表情按键*/
    FMIconExposure,         /**< 爆新鲜*/
    FMIconInfoNet,          /**< 信息网*/
    FMIconLuckyStar,        /**< 946幸运星*/
    FMIconBlinkLight,       /**< 幸运闪大灯*/
    FMIconMerchant,         /**< 商家信息*/
    FMIconWWW,              /**< 不清楚怎么用*/
    FMIconVoice,            /**< 语音图标*/
    FMIconHeart,             /**< 心形图标*/
    FMIconProject,           /**< 项目图标*/
    FMIconUpData             /**< 刷新图标*/
};


@interface NSString (FontAwesome)

/**
 @abstract Returns the correct enum for a font-awesome icon.
 @discussion The list of identifiers can be found here: http://fortawesome.github.com/Font-Awesome/#all-icons 
 */
+ (FMIconFont)fontAwesomeEnumForIconIdentifier:(NSString*)string;

/**
 @abstract Returns the font-awesome character associated to the icon enum passed as argument 
 */
+ (NSString*)fontAwesomeIconStringForEnum:(FMIconFont)value;

/* 
 @abstract Returns the font-awesome character associated to the font-awesome identifier.
 @discussion The list of identifiers can be found here: http://fortawesome.github.com/Font-Awesome/#all-icons
 */
+ (NSString*)fontAwesomeIconStringForIconIdentifier:(NSString*)identifier;

@end
