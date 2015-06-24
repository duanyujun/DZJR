//
//  FMNavigationGestureRecognizer.m
//  fmapp
//
//  Created by 张利广 on 14-6-11.
//  Copyright (c) 2014年 yk. All rights reserved.
//



#import "FMNavigationGestureRecognizer.h"

@interface FMNavigationGestureRecognizer ()
@property (nonatomic , assign)      NSInteger               intBtnCount;
@property (nonatomic , assign)      CGFloat                 floatButtonLengthSize;
@property (nonatomic , weak)        UIImageView             *indicatorImageView;
@property (nonatomic , assign)      NSInteger               formerSelectedTypeButtonTag;

@property (nonatomic,assign)       CGFloat    heightScale;

@property (nonatomic , assign)      id<GestureRecognizerDelegate> gestureDelegate;


- (void)initUserPersonalOperationEvent:(id)sender;
@end

@implementation FMNavigationGestureRecognizer

- (id)initWithFrame:(CGRect)frame
      withViewContr:(UIViewController *)parentControl
   withBtnNameArray:(NSArray *)nameArray
       withDelegate:(id<GestureRecognizerDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        
      self.heightScale=(CGFloat)KProjectScreenHeight/568;
        
        if(self.heightScale<1)
        {
            self.heightScale=1;
        }
        
        // Initialization code
        self.intBtnCount = [nameArray count];
        self.floatButtonLengthSize = KProjectScreenWidth/self.intBtnCount;
        [self setBackgroundColor:KDefaultOrNightScrollViewColor];
        [self setUserInteractionEnabled:YES];
        self.gestureDelegate = delegate;
        //滑动指示图片
        UIImageView *indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 33.5f*self.heightScale, self.floatButtonLengthSize-20,1.0f)];
//        [indicatorImageView setImage:createImageWithColor([UIColor colorWithRed:45.0f/255.0f
//                                                                          green:188.0f/255.0f
//                                                                           blue:150.0f/255.0f
//                                                                          alpha:1.0])];
        [indicatorImageView setImage:createImageWithColor(KDefaultOrNightBaseColor)];

        self.indicatorImageView = indicatorImageView;
        [self addSubview:self.indicatorImageView];
        
        ///底部横线
        UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 34.5f*self.heightScale, KProjectScreenWidth, 0.50f)];
//        [lineImageView setBackgroundColor:[UIColor colorWithRed:45.0f/255.0f
//                                                          green:188.0f/255.0f
//                                                           blue:150.0f/255.0f
//                                                          alpha:1.0]];
        [lineImageView setBackgroundColor:KSepLineColorSetup];
        [lineImageView setUserInteractionEnabled:YES];
        [self addSubview:lineImageView];
        self.formerSelectedTypeButtonTag = KGestureButtonBaseTag;
        for (NSInteger btnIndex = 0; btnIndex<nameArray.count; btnIndex++) {
            UIButton *claimOperationButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [claimOperationButton setTag:KGestureButtonBaseTag + btnIndex];
            [claimOperationButton setTitle:[nameArray objectAtIndex:btnIndex]
                                  forState:UIControlStateNormal];
            claimOperationButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [claimOperationButton setFrame:CGRectMake(self.
                                                      floatButtonLengthSize*btnIndex,0,
                                                      self.floatButtonLengthSize,34.5f*self.heightScale)];
            [claimOperationButton setTitleColor:[UIColor colorWithRed:83/255.0f
                                                                green:92/255.0f
                                                                 blue:103/255.0f
                                                                alpha:1]
                                       forState:UIControlStateNormal];
            

            if (btnIndex == 0) {
                
//                [claimOperationButton setTitleColor:[UIColor colorWithRed:45.0f/255.0f
//                                                                    green:188.0f/255.0f
//                                                                     blue:150.0f/255.0f
//                                                                    alpha:1.0]
//                                           forState:UIControlStateNormal];
                [claimOperationButton setTitleColor:KDefaultOrNightBaseColor                                       forState:UIControlStateNormal];

                claimOperationButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            }
            [claimOperationButton setTitleColor:[UIColor grayColor]
                                       forState:UIControlStateHighlighted];
            [claimOperationButton addTarget:self
                                     action:@selector(initUserPersonalOperationEvent:)
                           forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:claimOperationButton];
        }
    }
    return self;
}


- (void)initWithUserGestureRecognizerOperationButtonEvent:(id)sender{
    UIButton    *button = (UIButton *)sender;
    if (button.tag != self.formerSelectedTypeButtonTag) {
        
        UIButton *formerButton = (UIButton *)[self viewWithTag:self.formerSelectedTypeButtonTag];
        [formerButton setTitleColor:[UIColor colorWithRed:83/255.0f green:92/255.0f blue:103/255.0f alpha:1] forState:UIControlStateNormal];
        formerButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [UIView animateWithDuration:0.5f animations:^(){
            self.indicatorImageView.frame = CGRectMake((button.tag - KGestureButtonBaseTag)*self.floatButtonLengthSize+10, 33.5f*self.heightScale, self.floatButtonLengthSize-20.0f, 1.0f);
        } completion:^(BOOL finished){
            
            if (finished) {
                [button setTitleColor:KDefaultOrNightBaseColor forState:UIControlStateNormal];

                button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
                self.formerSelectedTypeButtonTag = button.tag;
            }
        }];
    }
    
//    [self.gestureDelegate initWithUserGestureRecognizerOperationButtonEvent:sender];

}

- (void)initUserPersonalOperationEvent:(id)sender{
    UIButton    *button = (UIButton *)sender;
    if (button.tag != self.formerSelectedTypeButtonTag) {
        
        UIButton *formerButton = (UIButton *)[self viewWithTag:self.formerSelectedTypeButtonTag];
        [formerButton setTitleColor:[UIColor colorWithRed:83/255.0f green:92/255.0f blue:103/255.0f alpha:1] forState:UIControlStateNormal];
        formerButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [UIView animateWithDuration:0.5f animations:^(){
            self.indicatorImageView.frame = CGRectMake((button.tag - KGestureButtonBaseTag)*self.floatButtonLengthSize+10, 33.5f*self.heightScale, self.floatButtonLengthSize-20.0f, 1.0f);
        } completion:^(BOOL finished){
            
            if (finished) {
                [button setTitleColor:KDefaultOrNightBaseColor forState:UIControlStateNormal];

                button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
                self.formerSelectedTypeButtonTag = button.tag;
            }
        }];
    }
    
    [self.gestureDelegate initWithUserGestureRecognizerOperationButtonEvent:sender];
}


- (void)initWithChangedWithUserSelectedIndex:(NSInteger)intIndex{
    UIButton    *button = (UIButton *)[self viewWithTag:intIndex];
    [self initWithUserGestureRecognizerOperationButtonEvent:button];
}
@end
