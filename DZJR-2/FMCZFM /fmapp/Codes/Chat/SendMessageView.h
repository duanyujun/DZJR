//
//  SendMessageView.h
//  fmapp
//
//  Created by SDYK on 14-9-18.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressView.h"
#import "FMMessage.h"
@class SendMessageView;

@protocol SendMessageViewDelegate <NSObject>

- (void)didSendMessageViewLayoutChanged:(CGFloat)bottom withHeight:(CGFloat)height;
- (void)initImagePicker;
- (void)sendMessage;
- (void)settingVoiceRecordingView;

@required

//tell you that you should begin recording
- (void)chatPanelViewShouldBeginRecord:(SendMessageView *)view;
//tell you that you view should cancel recording
- (void)chatPanelViewShouldCancelRecord:(SendMessageView *)view;
//tell you that you view should finish recording
- (void)chatPanelViewShouldFinishedRecord:(SendMessageView *)view;

@end

@interface SendMessageView : UIView

@property (nonatomic, weak)   UITextView        *commentView;
@property (nonatomic, weak)   ExpressView       *expressView;
@property (nonatomic, weak)   FMMessage         *message;           //聊天对象
@property (nonatomic, copy)   NSString          *replyUserId;       //回复车友ID
@property (nonatomic, assign) CGFloat           keyboardHeight;

@property (weak, nonatomic) id<SendMessageViewDelegate> delegate;

+ (CGFloat)textViewAndKeyboardHeight;

- (void)resetButton;

- (void)showInView:(UIView *)view;
//you should call this method when you have prepared for record
- (void)didBeginRecord;


@end
