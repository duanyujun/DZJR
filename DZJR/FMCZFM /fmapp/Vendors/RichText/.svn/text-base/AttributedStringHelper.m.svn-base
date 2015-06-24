//
//  AttributedStringHelper.m
//  CoreTextDemo
//
//  Created by MaYiming on 13-11-18.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "AttributedStringHelper.h"
#import <CoreText/CoreText.h>

#define KSystemFontOfSize 18.0f


@interface AttributedStringHelper ()
@property (nonatomic , assign)  BOOL        isSetupBool;
@property (nonatomic , assign)  CGFloat     customSystemFontOfSize;
@end


@implementation AttributedStringHelper

- (id)init{
    self = [super init];
    if (self) {
        self.isSetupBool = NO;
    }
    
    return self;
}

- (NSAttributedString *) getAttributedStringWithNSString:(NSString *) str textColor:(UIColor *)textColor
{
    if (str == nil) {
        return nil;
    }
    NSString *originalStr = [[NSString alloc] initWithString:str];//原始字符串
    
    NSMutableAttributedString *attriString = [[[NSMutableAttributedString alloc] initWithString:originalStr] autorelease];//属性字符串
    
    //设置字体大小(这行会导致IOS5下crash,主要是IOS5下UIFont和CTFontRef不兼容)--lyh
    //[attriString addAttribute:(NSString *)kCTFontAttributeName value:(id)[UIFont systemFontOfSize:17.0f] range:NSMakeRange(0, attriString.length)];
    //在IOS6以下,中文会被强制加粗,使用细字体代替
    NSString* strFontName;
    
    if(HUISystemVersionBelow(kHUISystemVersion_6_0)) {
        strFontName = kFontThinName;
    }else{
        strFontName = [UIFont systemFontOfSize:(self.isSetupBool == YES? self.customSystemFontOfSize : 18.0f)].fontName;
    }
    //CTFontRef fontRef = CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:17.0f].fontName, 17.0, NULL);
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)strFontName, (self.isSetupBool == YES? self.customSystemFontOfSize : 18.0f), NULL);
    [attriString addAttribute:(NSString *)kCTFontAttributeName value:(id)fontRef range:NSMakeRange(0, attriString.length)];
    [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)textColor.CGColor range:NSMakeRange(0, attriString.length)];
    
    //换行对齐方式
    CTLineBreakMode lineBreakMode = kCTLineBreakByCharWrapping;//换行模式
    CTTextAlignment alignment = kCTLeftTextAlignment;//对齐方式
    float lineSpacing = 4.0;//行间距
    CTParagraphStyleSetting paraStyles[3] = {
        {.spec = kCTParagraphStyleSpecifierLineBreakMode,.valueSize = sizeof(CTLineBreakMode), .value = (const void*)&lineBreakMode},
        
        {.spec = kCTParagraphStyleSpecifierAlignment,.valueSize = sizeof(CTTextAlignment), .value = (const void*)&alignment},
        
        {.spec = kCTParagraphStyleSpecifierLineSpacing,.valueSize = sizeof(CGFloat), .value = (const void*)&lineSpacing},
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(paraStyles,3);//第二个参数为paraStyles的长度
    [attriString addAttribute:(NSString *)kCTParagraphStyleAttributeName
                        value:(id)paragraphStyle
                        range:NSMakeRange(0, attriString.length)];

    CFRelease(paragraphStyle);
    
    //1.url正则表达式
    NSString *urlRegulaStr = @"([hH][tT][tT][pP][sS]?:\\/\\/[^ ,'\">\\]\\)]*[^\\. ,'\">\\]\\)])";
    NSRegularExpression *urlRegex = [NSRegularExpression regularExpressionWithPattern:urlRegulaStr options:NSRegularExpressionCaseInsensitive error:nil];
    ////符合url正则表达式的结果
    NSArray *urlArrayOfAllMatches = [urlRegex matchesInString:originalStr options:0 range:NSMakeRange(0, [originalStr length])];
    ////设置url颜色
    [urlArrayOfAllMatches enumerateObjectsUsingBlock:^(NSTextCheckingResult * obj, NSUInteger idx, BOOL *stop) {
        [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)KContentTextCanEditColor.CGColor range:obj.range];
    }];
    
    //2.@正则表达式
    NSString *atRegulaStr = @"@[\\u4e00-\\u9fa5\\w\\-]+";
    NSRegularExpression *atRegex = [NSRegularExpression regularExpressionWithPattern:atRegulaStr options:NSRegularExpressionCaseInsensitive error:nil];
    ////符合@正则表达式的结果
    NSArray *atArrayOfAllMatches = [atRegex matchesInString:originalStr options:0 range:NSMakeRange(0, [originalStr length])];
    ////设置@颜色
    [atArrayOfAllMatches enumerateObjectsUsingBlock:^(NSTextCheckingResult * obj, NSUInteger idx, BOOL *stop) {
        [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)KContentTextCanEditColor.CGColor range:obj.range];
    }];
    
    //3.#正则表达式
    NSString *poundRegulaStr = @"#([^\\#|.]+)#";//话题的正则表达式
    NSRegularExpression *poundRegex = [NSRegularExpression regularExpressionWithPattern:poundRegulaStr options:NSRegularExpressionCaseInsensitive error:nil];
    ////符合#正则表达式的结果
    NSArray *poundArrayOfAllMatches = [poundRegex matchesInString:originalStr options:0 range:NSMakeRange(0, [originalStr length])];
    ////设置#颜色
    [poundArrayOfAllMatches enumerateObjectsUsingBlock:^(NSTextCheckingResult * obj, NSUInteger idx, BOOL *stop) {
        [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)[UIColor colorWithRed:255/255.0 green:100/255.0 blue:0/255.0 alpha:1].CGColor range:obj.range];
    }];
    
    //4.表情正则表达式
    NSString *expressionRegulaStr = @"\\[f_\\w*\\]";//话题的正则表达式
    NSRegularExpression *expressionRegex = [NSRegularExpression regularExpressionWithPattern:expressionRegulaStr options:NSRegularExpressionCaseInsensitive error:nil];
    ////符合表情正则表达式的结果
    NSArray *expressionArrayOfAllMatches = [expressionRegex matchesInString:originalStr options:0 range:NSMakeRange(0, [originalStr length])];
    ////设置表情正则表达式属性
    [expressionArrayOfAllMatches enumerateObjectsUsingBlock:^(NSTextCheckingResult * obj, NSUInteger idx, BOOL *stop) {
        @autoreleasepool {
            CTRunDelegateCallbacks imageCallbacks;
            imageCallbacks.version = kCTRunDelegateVersion1;
            imageCallbacks.dealloc = RunDelegateDeallocCallback;
            imageCallbacks.getAscent = RunDelegateGetAscentCallback;
            imageCallbacks.getDescent = RunDelegateGetDescentCallback;
            imageCallbacks.getWidth = RunDelegateGetWidthCallback;
            
            //创建CTRun回调
            CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, [NSString stringWithFormat:@"Expression%d",idx]);
            
            //modified by liyh 2014-11-07 如果替换成空格会导致宽度不能正确计算(属于coreText的bug)
            //[attriString replaceCharactersInRange:NSMakeRange(obj.range.location - idx * 6, 7)  withString:@" "];//替换成空格
            unichar objectReplacementChar = 0xFFFC;
            NSString * objectReplacementString = [NSString stringWithCharacters:&objectReplacementChar length:1];
            [attriString replaceCharactersInRange:NSMakeRange(obj.range.location - idx * 6, 7)  withString:objectReplacementString];
            
            //设置图片预留字符使用CTRun回调
            [attriString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(id)runDelegate range:NSMakeRange(obj.range.location - idx * 6, 1)];
            //设置图片预留字符使用一个imageName的属性，区别于其他字符
            NSString *imageName = [NSString stringWithFormat:@"%@.png",[originalStr substringWithRange:NSMakeRange(obj.range.location + 1, 5)]];
            [attriString addAttribute:@"imageName" value:imageName range:NSMakeRange(obj.range.location - idx * 6, 1)];
            
            CFRelease(runDelegate);
        }
    }];
    
    [originalStr release];
    CFRelease(fontRef);
    return attriString;
}

void RunDelegateDeallocCallback( void* refCon ){
    
}

//CTRun的回调，获取高度
CGFloat RunDelegateGetAscentCallback( void *refCon){
    return 20;
}

CGFloat RunDelegateGetDescentCallback(void *refCon){
    return 5;
}

//CTRun的回调，获取宽度
CGFloat RunDelegateGetWidthCallback(void *refCon){
    return 20;
}


- (CGFloat) heightForString:(NSString *) string withWidth:(CGFloat)inWidth
{
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:string];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedStr);
    [attributedStr release];
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(inWidth, 10000), NULL);
    CFRelease(framesetter);
    return suggestedSize.height ;
}

- (void)initStringSystemFontOfSize:(CGFloat)stringFont withSetupFont:(BOOL)setFontBool{
    self.customSystemFontOfSize = stringFont;
    self.isSetupBool = YES;
}


@end
