//
//  SendMessageView.m
//  fmapp
//
//  Created by SDYK on 14-9-18.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "SendMessageView.h"
#import <CoreText/CoreText.h>
#import "FBShimmeringView.h"
#import "CurrentUserInformation.h"
#import "FMSettings.h"
#import "HTTPClient+Interaction.h"
#import "LoginController.h"
#import "FontAwesome.h"
#import "NSString+FontAwesome.h"
#import "JSBadgeView.h"
#import "ChatViewController.h"
#import "FMMessage.h"

#define kPublishViewMargin              4
#define kPublishViewButtonSize          35

#define KPublishExpressHeight           216         // 表情键盘高度
#define kCancelButtonItemTag            100
#define kPublishButtonItemTag           101
#define kKeyboardButtonTag              102
#define kExpressButtonTag               103
#define kCameraButtonTag                104
#define kVoiceButtonTag                 105

#define kFloatRecordImageUpTime (0.5f)
#define kFloatRecordImageRotateTime (0.17f)
#define kFloatRecordImageDownTime (0.5f)
#define kFloatGarbageAnimationTime (.3f)
#define kFloatGarbageBeginY (45.0f)
#define kFloatCancelRecordingOffsetX  (100.0f)

void setViewFixedAnchorPoint(CGPoint anchorPoint, UIView *view)
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

// 动画
@interface FMSlideView : UIView

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

- (void)updateLocation:(CGFloat)offsetX;

@end

@implementation FMSlideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    self.clipsToBounds = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.text = @"滑动删除";
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    self.textLabel = label;
    
    UIImageView *bkimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SlideArrow"]];
    CGRect frame = bkimageView.frame;
    frame.origin.x = self.frame.size.width / 2.0 + 33;
    frame.origin.y += 10;
    [bkimageView setFrame:frame];
    [self addSubview:bkimageView];
    self.arrowImageView = bkimageView;
}

- (void)updateLocation:(CGFloat)offsetX
{
    CGRect labelFrame = self.textLabel.frame;
    labelFrame.origin.x += offsetX;
    self.textLabel.frame = labelFrame;
    
    CGRect imageFrame = self.arrowImageView.frame;
    imageFrame.origin.x += offsetX;
    self.arrowImageView.frame = imageFrame;
}

@end

// 垃圾桶
@interface FMGarbageView : UIView

@property (nonatomic, strong) UIImageView *bodyView;
@property (nonatomic, strong) UIImageView *headerView;

@end

@implementation FMGarbageView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 18, 26)];
    if (self) {
        self.bodyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BucketBodyTemplate"]];
        self.headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BucketLidTemplate"]];
        CGRect frame = self.bodyView.frame;
        frame.origin.y = 1;
        [self.bodyView setFrame:frame];
        [self addSubview:self.headerView];
        setViewFixedAnchorPoint(CGPointMake(0, 1), self.headerView);
        [self addSubview:self.bodyView];
    }
    return self;
}

@end


@interface SendMessageView() <ExpressViewDelegate, UITextViewDelegate>

@property (nonatomic, assign) NSInteger                 lastRow;
@property (nonatomic, strong) NSMutableArray            *imageList;                 //图片显示列表
@property (nonatomic, assign) Boolean                   imageMode;                  //是否在图像编辑模式

@property (nonatomic, weak)   UIButton                  *keyboardOrExpressionButton;
@property (nonatomic, weak)   UIButton                  *cameraButton;
@property (nonatomic, weak)   UIButton                  *voiceButton;
@property (nonatomic, weak)   UIButton                  *sendMessageButton;

@property (nonatomic, strong) UIButton                  *recordBtn;
@property (nonatomic, strong) UILabel                   *timeLabel;
@property (nonatomic, strong) FBShimmeringView          *slideView;
@property (nonatomic, assign) CGPoint                   trackTouchPoint;
@property (nonatomic, assign) CGPoint                   firstTouchPoint;
@property (nonatomic, strong) FMGarbageView             *garbageImageView;
@property (nonatomic, assign) BOOL                      canCancelAnimation;
@property (nonatomic, assign) BOOL                      isCanceling;
@property (nonatomic, strong) NSTimer                   *countTimer;
@property (nonatomic, assign) NSUInteger                currentSeconds;

@end

@implementation SendMessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.lastRow = 1;
        ///默认背景色
        self.backgroundColor = [[FMThemeManager skin] backgroundColor];
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOpacity = 0.4f;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowRadius = 2.0f;
        
        //表情或键盘按钮
        UIButton *m_keyboardOrExpressionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        m_keyboardOrExpressionButton.tag = kExpressButtonTag;
        m_keyboardOrExpressionButton.titleLabel.font = [UIFont systemFontOfSize:30.0];
        [m_keyboardOrExpressionButton simpleButtonWithImageColor:[FMThemeManager.skin baseTintColor]];
        [m_keyboardOrExpressionButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [m_keyboardOrExpressionButton setFrame:CGRectMake(kPublishViewMargin,
                                                        8,
                                                        kPublishViewButtonSize,
                                                        kPublishViewButtonSize)];
        [m_keyboardOrExpressionButton addAwesomeIcon:FMIconExpression beforeTitle:YES];
        m_keyboardOrExpressionButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:m_keyboardOrExpressionButton];
        self.keyboardOrExpressionButton = m_keyboardOrExpressionButton;
        
        // 拍照按钮
        UIButton *m_cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        m_cameraButton.tag = kCameraButtonTag;
        m_cameraButton.titleLabel.font = [UIFont systemFontOfSize:25.0];
        [m_cameraButton simpleButtonWithImageColor:[FMThemeManager.skin baseTintColor]];
        [m_cameraButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [m_cameraButton setFrame:CGRectMake(kPublishViewMargin*2+kPublishViewButtonSize,
                                          8,
                                          kPublishViewButtonSize,
                                          kPublishViewButtonSize)];
        [m_cameraButton addAwesomeIcon:FMIconCamera beforeTitle:YES];
        m_cameraButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:m_cameraButton];
        self.cameraButton = m_cameraButton;
        
        //文本框
        UITextView *commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.keyboardOrExpressionButton.frame)*2 + kPublishViewMargin*2,
                                                                                   kPublishViewMargin,
                                                                                   frame.size.width - kPublishViewButtonSize * 3 - 5 * kPublishViewMargin ,
                                                                                   frame.size.height - 2 * kPublishViewMargin)];
        commentTextView.font = kFontWithDefaultSize;
        [commentTextView setDelegate:self];
        commentTextView.layer.borderWidth = 0.8;
        commentTextView.layer.borderColor = [[[FMThemeManager skin] baseTintColor] CGColor];
        commentTextView.backgroundColor = [UIColor clearColor];
        commentTextView.textColor = [[FMThemeManager skin] textColor];
        commentTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        commentTextView.returnKeyType = UIReturnKeySend;
        self.commentView = commentTextView;
        [self addSubview:commentTextView];
        
        //语音按钮
        UIButton *m_voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        m_voiceButton.tag = kVoiceButtonTag;
        m_voiceButton.titleLabel.font = [UIFont systemFontOfSize:23.0];
        [m_voiceButton simpleButtonWithImageColor:[FMThemeManager.skin baseTintColor]];
        [m_voiceButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        /*
        [m_voiceButton addTarget:self
                          action:@selector(beginRecord:forEvent:)
                forControlEvents:UIControlEventTouchDown];
        [m_voiceButton addTarget:self
                          action:@selector(mayCancelRecord:forEvent:)
                forControlEvents:UIControlEventTouchDragOutside | UIControlEventTouchDragInside];
        [m_voiceButton addTarget:self
                          action:@selector(finishedRecord:forEvent:)
                forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
         */
        
        [m_voiceButton setFrame:CGRectMake(frame.size.width - kPublishViewButtonSize - kPublishViewMargin,
                                            8,
                                            kPublishViewButtonSize,
                                            kPublishViewButtonSize)];
        m_voiceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [m_voiceButton addAwesomeIcon:FMIconVoice
                          beforeTitle:YES];
        [m_voiceButton setHidden:NO];
        [self addSubview:m_voiceButton];
        self.voiceButton = m_voiceButton;
        
        // 发送按钮
        UIButton *m_sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        m_sendMessageButton.tag = kPublishButtonItemTag;
        m_sendMessageButton.titleLabel.font = [UIFont systemFontOfSize:23.0];
        [m_sendMessageButton simpleButtonWithImageColor:[FMThemeManager.skin baseTintColor]];
        [m_sendMessageButton addTarget:self
                              action:@selector(sendMessage)
                    forControlEvents:UIControlEventTouchUpInside];
        [m_sendMessageButton setFrame:CGRectMake(frame.size.width - kPublishViewButtonSize - kPublishViewMargin,
                                               8,
                                               kPublishViewButtonSize,
                                               kPublishViewButtonSize)];
        m_sendMessageButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [m_sendMessageButton addAwesomeIcon:FMIconRadio beforeTitle:YES];
        [m_sendMessageButton setHidden:YES];
        [self addSubview:m_sendMessageButton];
        self.sendMessageButton = m_sendMessageButton;
        
        
        self.canCancelAnimation = NO;
        
    }
    return self;
}


- (void)beginRecord:(UIButton *)btn forEvent:(UIEvent *)event
{
    self.commentView.hidden = YES;
    self.keyboardOrExpressionButton.hidden = YES;
    self.cameraButton.hidden = YES;
    UITouch *touch = [[event touchesForView:btn] anyObject];
    self.trackTouchPoint = [touch locationInView:self];
    self.firstTouchPoint = self.trackTouchPoint;
    self.isCanceling = NO;
    
    [self showSlideView];
    [self showRecordImageView];
    
    if ([self.delegate respondsToSelector:@selector(chatPanelViewShouldBeginRecord:)]) {
        [self.delegate chatPanelViewShouldBeginRecord:self];
    }
}

- (void)mayCancelRecord:(UIButton *)btn forEvent:(UIEvent *)event
{
    UITouch *touch = [[event touchesForView:btn] anyObject];
    CGPoint curPoint = [touch locationInView:self];
    if (curPoint.x < self.voiceButton.frame.origin.x) {
        [(FMSlideView *)self.slideView.contentView updateLocation:(curPoint.x - self.trackTouchPoint.x)];
    }
    self.trackTouchPoint = curPoint;
    if ((self.firstTouchPoint.x - self.trackTouchPoint.x ) > kFloatCancelRecordingOffsetX) {
        self.isCanceling = YES;
        [btn cancelTrackingWithEvent:event];
        [self cancelRecord];
    }
}

- (void)finishedRecord:(UIButton *)btn forEvent:(UIEvent *)event
{
    if (self.isCanceling) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(chatPanelViewShouldFinishedRecord:)]) {
        [self.delegate chatPanelViewShouldFinishedRecord:self];
    }
    
    [self endRecord];
    
    self.recordBtn.hidden = YES;
}

- (void)cancelRecord
{
    if ([self.delegate respondsToSelector:@selector(chatPanelViewShouldCancelRecord:)]) {
        [self.delegate chatPanelViewShouldCancelRecord:self];
    }
    
    [self.recordBtn.layer removeAllAnimations];
    self.slideView.hidden = YES;
    [self.voiceButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    CGRect orgFrame = self.recordBtn.frame;
    
    if (!self.canCancelAnimation) {
        [self endRecord];
        return;
    }
    
    [UIView animateWithDuration:kFloatRecordImageUpTime delay:.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.recordBtn.frame;
        frame.origin.y -= (1.5 * self.recordBtn.frame.size.height);
        self.recordBtn.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            
            [self showGarbage];
            
            [UIView animateWithDuration:kFloatRecordImageRotateTime delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                CGAffineTransform transForm = CGAffineTransformMakeRotation(-1 * M_PI);
                self.recordBtn.transform = transForm;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kFloatRecordImageDownTime delay:.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.recordBtn.frame = orgFrame;
                    self.recordBtn.alpha = 0.1f;
                }completion:^(BOOL finished) {
                    self.recordBtn.hidden = YES;
                    [self dismissGarbage];
                }];
            }];
        }
    }];
}

- (void)dismissGarbage
{
    [UIView animateWithDuration:kFloatGarbageAnimationTime delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.garbageImageView.headerView.transform = CGAffineTransformIdentity;
        CGRect frame = self.garbageImageView.frame;
        frame.origin.y = kFloatGarbageBeginY;
        self.garbageImageView.frame = frame;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self endRecord];
        });
    }];
}

- (void)showGarbage
{
    [self garbageImageView];
    [UIView animateWithDuration:kFloatGarbageAnimationTime delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGAffineTransform transForm = CGAffineTransformMakeRotation(-1 * M_PI_2);
        self.garbageImageView.headerView.transform = transForm;
        CGRect frame = self.garbageImageView.frame;
        frame.origin.y = (self.bounds.size.height - frame.size.height) / 2.0;
        self.garbageImageView.frame = frame;
    } completion:^(BOOL finished) {
    }];
}

- (FMGarbageView *)garbageImageView
{
    if (!_garbageImageView) {
        FMGarbageView *imageView = [[FMGarbageView alloc] init];
        CGRect frame = imageView.frame;
        frame.origin = CGPointMake(_recordBtn.center.x - frame.size.width / 2.0f, kFloatGarbageBeginY);
        [imageView setFrame:frame];
        [self addSubview:imageView];
        _garbageImageView = imageView;
    }
    return _garbageImageView;
}


- (void)showSlideView
{
    self.slideView.hidden = NO;
    CGRect frame = self.slideView.frame;
    CGRect orgFrame = {CGPointMake(CGRectGetMaxX(self.voiceButton.frame),CGRectGetMinY(frame)),frame.size};
    self.slideView.frame = orgFrame;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.slideView.frame = frame;
    } completion:NULL];
}

- (void)showRecordImageViewGradient
{
    CABasicAnimation *basicAnimtion = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [basicAnimtion setRepeatCount:1000000];
    [basicAnimtion setDuration:1.0];
    basicAnimtion.autoreverses = YES;
    basicAnimtion.fromValue = [NSNumber numberWithFloat:1.0f];
    basicAnimtion.toValue = [NSNumber numberWithFloat:0.1f];
    [self.recordBtn.layer addAnimation:basicAnimtion forKey:nil];
}

- (void)showRecordImageView
{
    self.recordBtn.alpha = 1.0;
    self.recordBtn.hidden = NO;
    CGRect frame = self.recordBtn.frame;
    CGRect orgFrame = CGRectMake(CGRectGetMinX(self.voiceButton.frame), frame.origin.y, frame.size.width, frame.size.height);
    self.recordBtn.frame = orgFrame;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.recordBtn.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)endRecord
{
    self.commentView.hidden = NO;
    self.isCanceling = NO;
    self.canCancelAnimation = NO;
    [self invalidateCountTimer];
    
    if (_recordBtn) {
        [self.recordBtn.layer removeAllAnimations];
        [self.recordBtn removeFromSuperview];
        self.recordBtn = nil;
    }
    
    if (_slideView) {
        [self.slideView removeFromSuperview];
        self.slideView = nil;
    }
    
    if (_timeLabel) {
        [self.timeLabel removeFromSuperview];
        self.timeLabel = nil;
    }
    
    if (_garbageImageView) {
        [self.garbageImageView removeFromSuperview];
        self.garbageImageView = nil;
    }
    
    [self.voiceButton addTarget:self action:@selector(beginRecord:forEvent:) forControlEvents:UIControlEventTouchDown];
    [self.voiceButton addTarget:self action:@selector(mayCancelRecord:forEvent:) forControlEvents:UIControlEventTouchDragOutside | UIControlEventTouchDragInside];
    [self.voiceButton addTarget:self action:@selector(finishedRecord:forEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    
    CGRect frame = self.keyboardOrExpressionButton.frame;
//    CGRect keyboardOrExpressionButtonFrame = self.keyboardOrExpressionButton.frame;
//    CGRect cameraButtonFrame = self.cameraButton.frame;
    CGFloat offset = self.commentView.frame.origin.x - frame.origin.x;
    frame.origin.x -= 100;
    [self.keyboardOrExpressionButton setFrame:frame];
    self.keyboardOrExpressionButton.hidden = NO;
    self.cameraButton.hidden = NO;
    
    CGFloat textFieldMaxX = CGRectGetMaxX(self.commentView.frame);
    self.commentView.hidden = NO;
    frame = self.commentView.frame;
    frame.origin.x = self.keyboardOrExpressionButton.frame.origin.x + offset;
    frame.size.width = textFieldMaxX - frame.origin.x;
    [self.commentView setFrame:frame];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect nframe = self.keyboardOrExpressionButton.frame;
        nframe.origin.x += 100;
        [self.keyboardOrExpressionButton setFrame:nframe];
        
        nframe = self.commentView.frame;
        nframe.origin.x = self.keyboardOrExpressionButton.frame.origin.x + offset;
        nframe.size.width = textFieldMaxX - nframe.origin.x;
        [self.commentView setFrame:nframe];
    }];
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 81, 45)];
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.font = [UIFont systemFontOfSize:17.0f];
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (FBShimmeringView *)slideView
{
    if (!_slideView) {
        _slideView = [[FBShimmeringView alloc] initWithFrame:CGRectMake(90, self.commentView.frame.origin.y, 120, self.commentView.frame.size.height)];
        FMSlideView *contentView = [[FMSlideView alloc] initWithFrame:_slideView.bounds];
        _slideView.contentView = contentView;
        [self addSubview:_slideView];
        
        _slideView.shimmeringDirection = FBShimmerDirectionLeft;
        _slideView.shimmeringSpeed = 60.0f;
        _slideView.shimmeringHighlightWidth = 0.29f;
        _slideView.shimmering = YES;
    }
    
    return _slideView;
}

- (UIButton *)recordBtn
{
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_recordBtn setImage:[UIImage imageNamed:@"MicRecBtn"] forState:UIControlStateNormal];
        CGRect frame = self.keyboardOrExpressionButton.frame;
        [_recordBtn setFrame:frame];
        [_recordBtn setTintColor:[UIColor redColor]];
        [self addSubview:_recordBtn];
    }
    
    return _recordBtn;
}

- (void)showInView:(UIView *)view
{
    if (view) {
        CGRect frame = self.frame;
        frame.origin.x = 0;
        frame.origin.y = view.bounds.size.height - frame.size.height;
        [self setFrame:frame];
        
        [view addSubview:self];
    }
}

- (void)didBeginRecord
{
    self.canCancelAnimation = YES;
    [self startCountTimer];
    [self showRecordImageViewGradient];
}

- (NSTimer *)countTimer
{
    if (!_countTimer) {
        _countTimer = [NSTimer timerWithTimeInterval:1.0 target:self
                                            selector:@selector(updateRecordTime:)
                                            userInfo:nil repeats:YES];
    }
    return _countTimer;
}

- (void)invalidateCountTimer
{
    self.currentSeconds = 0;
    [_countTimer invalidate];
    self.countTimer = nil;
}

- (void)startCountTimer
{
    self.currentSeconds = 0;
    [[NSRunLoop currentRunLoop] addTimer:self.countTimer forMode:NSDefaultRunLoopMode];
    [self.countTimer fire];
}

- (void)updateRecordTime:(NSTimer *)timer
{
    self.currentSeconds++;
    NSUInteger sec = self.currentSeconds % 60;
    NSString *secondStr = nil;
    if (sec < 10) {
        secondStr = [NSString stringWithFormat:@"0%lu",(unsigned long)sec];
    }
    else{
        secondStr = [NSString stringWithFormat:@"%lu",(unsigned long)sec];
    }
    NSString *mims = [NSString stringWithFormat:@"%lu",self.currentSeconds / (unsigned long)60];
    self.timeLabel.text = [NSString stringWithFormat:@"%@:%@",mims,secondStr];
}



#pragma mark ------------------按钮点击事件-------------------

- (void) buttonClicked:(id) sender
{
    UIButton *button = (UIButton *)sender;
    
    UIView* superView = [self superview];
    CGRect rc = superView.bounds;
    
    if (button.tag == kVoiceButtonTag) {// 录音

        [self.delegate settingVoiceRecordingView];
        
    } else if (button.tag == kCancelButtonItemTag) { //取消
        [self.commentView resignFirstResponder];
    } else if (button.tag == kExpressButtonTag || button.tag == kKeyboardButtonTag){//表情或键盘按钮
        
        if (![self.commentView isFirstResponder]) {
            [self.commentView becomeFirstResponder];
            return;
        }
        
        //获取键盘视图
        UIView *keyboardView = GetKeyBoardView();
        
        self.keyboardHeight = 0; //键盘高度
        NSInteger buttonImageName;
        if(button.tag == kExpressButtonTag){//显示表情
            
            //创建表情键盘
            if (self.expressView == nil) {
                ExpressView* expressView = [[ExpressView alloc] initWithFrame:CGRectMake(0,
                                                                                         rc.size.height,
                                                                                         rc.size.width,KPublishExpressHeight)];
                expressView.delegate = self;
                [superView addSubview:expressView];
                self.expressView = expressView;
            }
            [superView bringSubviewToFront:self.expressView];
            [UIView beginAnimations:@"HiddenKeyboard" context:nil];
            [UIView setAnimationDuration:0.3f];
            
            //隐藏键盘
            CGRect keyboardFrame = keyboardView.frame;
            keyboardFrame.origin.y = [UIScreen mainScreen].bounds.size.height;
            keyboardView.frame = keyboardFrame;
            
            //显示表情
            self.expressView.frame = CGRectMake(0,
                                                rc.size.height - KPublishExpressHeight,
                                                rc.size.width,
                                                KPublishExpressHeight);
            [UIView commitAnimations];
            
            self.keyboardHeight = KPublishExpressHeight;
            button.tag = kKeyboardButtonTag;
            buttonImageName = FMIconKeyboard;
            
            
            if ([self.delegate respondsToSelector:@selector(didSendMessageViewLayoutChanged:withHeight:)]) {
                [self.delegate didSendMessageViewLayoutChanged:self.keyboardHeight withHeight:self.frame.size.height];
            }
            
        } else {//显示键盘
            
            
            [UIView beginAnimations:@"ShowKeyboard" context:nil];
            [UIView setAnimationDuration:0.3f];
            //隐藏表情
            if(self.expressView){
                self.expressView.frame = CGRectMake(0, rc.size.height, rc.size.width, KPublishExpressHeight);
            }
            
            //显示键盘
            if (keyboardView) {
                CGRect keyboardFrame = keyboardView.frame;
                keyboardFrame.origin.y = [UIScreen mainScreen].bounds.size.height - keyboardView.frame.size.height;
                keyboardView.frame = keyboardFrame;
                self.keyboardHeight = keyboardFrame.size.height;
            }
            
            [UIView commitAnimations];
            
            if (keyboardView) {
                if ([self.delegate respondsToSelector:@selector(didSendMessageViewLayoutChanged:withHeight:)]) {
                    [self.delegate didSendMessageViewLayoutChanged:self.keyboardHeight withHeight:self.frame.size.height];
                }
            }
            button.tag = kExpressButtonTag;
            buttonImageName = FMIconExpression;
            
        }
        [button setAwesomeIcon:buttonImageName];
    } else if (button.tag == kCameraButtonTag) { // 拍照按钮
        
        [self.delegate initImagePicker];
        
    }
}


#pragma mark --------------ExpressViewDelegate---------------

- (void)didExpressViewSelected:(NSInteger)tag isDelete:(BOOL)bDelete
{
    if (!bDelete) {//不是删除按钮
        
        NSString *contentText = [[NSString alloc] initWithFormat:@"%@[%@]",self.commentView.text,
                                 [[FMSettings sharedSettings].expressionNameArray objectAtIndex:tag-1]];
        self.commentView.text = contentText;
        [self textView:self.commentView shouldChangeTextInRange:NSMakeRange(0,0) replacementText:@""];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:nil];
        
    }else{//是删除按钮
        if (self.commentView.text.length > 0) {
            if ([[self.commentView.text substringFromIndex:self.commentView.text.length - 1] isEqualToString:@"]"]) {
                //正则表达式
                NSRegularExpression *textRegex = [NSRegularExpression regularExpressionWithPattern:@"\\[\\w*\\]" options:NSRegularExpressionCaseInsensitive error:nil];
                ////符合正则表达式的结果
                NSArray *textArrayOfAllMatches = [textRegex matchesInString:self.commentView.text options:0 range:NSMakeRange(0, [self.commentView.text length])];
                
                if (textArrayOfAllMatches.count > 0) {
                    NSTextCheckingResult *checkingResult = textArrayOfAllMatches.lastObject;
                    self.commentView.text = [self.commentView.text substringWithRange:NSMakeRange(0,checkingResult.range.location)];
                }
            }else{
                self.commentView.text = [self.commentView.text substringWithRange:NSMakeRange(0, self.commentView.text.length - 1)];
            }
        }
    }
    
    
    
}


- (void)resetComment
{
    self.commentView.text = nil;
    self.message = nil;
    self.lastRow = 1;
    if ([self.delegate respondsToSelector:@selector(didSendMessageViewLayoutChanged:withHeight:)]) {
        [self.delegate didSendMessageViewLayoutChanged:self.superview.bounds.size.height - CGRectGetMaxY(self.frame) withHeight:45.0];
    }
}
- (void)resetButton
{
    //隐藏表情
    if(self.expressView){
        
        [UIView beginAnimations:@"HideExpressBorad" context:nil];
        [UIView setAnimationDuration:0.3f];
        
        UIView* superView = [self superview];
        CGRect rc = superView.bounds;
        
        self.expressView.frame = CGRectMake(0, rc.size.height, rc.size.width, KPublishExpressHeight);
        
        [UIView commitAnimations];
    }
    
    UIButton *keyboardOrExpressionButton  = (UIButton* )[self viewWithTag:kKeyboardButtonTag];
    if (keyboardOrExpressionButton) {
        keyboardOrExpressionButton.tag = kExpressButtonTag;
        [keyboardOrExpressionButton setAwesomeIcon:FMIconExpression];
    }
}


#pragma mark -------------------发送消息---------------------

- (void)sendMessage
{
    [self.voiceButton setHidden:NO];
    [self.sendMessageButton setHidden:YES];
    [self.delegate sendMessage];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [self sendMessage];
        return NO;
    }
    int rows = 1;
    if (!IsStringEmptyOrNull(self.commentView.text)) {
        CGSize size = [self.commentView.text sizeWithFont:[self.commentView font]];
        rows  = self.commentView.contentSize.height/size.height;
    }
    if (rows != self.lastRow) {
        CGFloat h;
        if (rows == 1) {
            h = 45.0;
        }else if (rows == 2) {
            h = 60.0;
        }else {
            h = 70.0;
        }
        if ([self.delegate respondsToSelector:@selector(didSendMessageViewLayoutChanged:withHeight:)]) {
            [self.delegate didSendMessageViewLayoutChanged:self.superview.bounds.size.height - CGRectGetMaxY(self.frame) withHeight:h];
        }
    }
    self.lastRow = rows;
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
//    self.commentView = textView;
    
    if (IsStringEmptyOrNull(textView.text)) {
        [self.voiceButton setHidden:NO];
        [self.sendMessageButton setHidden:YES];
    } else {
        [self.voiceButton setHidden:YES];
        [self.sendMessageButton setHidden:NO];
    }
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.voiceButton setHidden:NO];
    [self.sendMessageButton setHidden:YES];
    
    [self resetButton];
    [self resetComment];
    return YES;
}

@end