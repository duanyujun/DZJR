//
//  RichTextLabel.m
//  CoreTextDemo
//
//  Created by MaYiming on 13-11-17.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "RichTextLabel.h"
#import <CoreText/CoreText.h>
#import "NSAttributedString+Height.h"

@implementation RichTextLabel
@synthesize attString;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    //表情夜间模式
    if(ThemeCategory==5)
    {
        self.alpha=0.6;
    }
    else
    {
         self.alpha=1;
    }
    [super drawTextInRect:rect];
    
    if (attString == nil) {
        return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, rect.size.height), 1.0f, -1.0f));
    
    //CFStringRef cfStringRef = CFAttributedStringGetString((CFAttributedStringRef)self.attString);
    //CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, cfStringRef, NULL);
    
    //[self.attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, self.attString.length)];
    
    CFAttributedStringRef currentText = CFAttributedStringCreateCopy(NULL, (CFAttributedStringRef)attString);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    CFRelease(currentText);
    
    //设置CTFramesetter
    //CTFramesetterRef framesetter =  CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, rect.size.width, rect.size.height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attString.length), path, NULL);
    
    //获取画出来的内容的行数
    CFArrayRef lines = CTFrameGetLines(frame);
    
    //获取每行的原点坐标
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        @autoreleasepool {
            CTLineRef line = CFArrayGetValueAtIndex(lines, i);
            CGFloat lineAscent;
            CGFloat lineDescent;
            CGFloat lineLeading;
            //获取每行的宽度和高度
            CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
            //获取每个CTRun
            CFArrayRef runs = CTLineGetGlyphRuns(line);
            
            for (int j = 0; j < CFArrayGetCount(runs); j++) {
                @autoreleasepool {
                    CGFloat runAscent;
                    CGFloat runDescent;
                    CGPoint lineOrigin = lineOrigins[i];
                    //获取每个CTRun
                    CTRunRef run = CFArrayGetValueAtIndex(runs, j);
                    NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
                    
                    CGRect runRect;
                    //调整CTRun的rect
                    runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
                    
                    runRect = CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL), lineOrigin.y - runDescent, runRect.size.width, runAscent + runDescent);
                    
                    NSString *imageName = [attributes objectForKey:@"imageName"];
                    //图片渲染逻辑，把需要被图片替换的字符位置画上图片
                    if (imageName) {

                        UIImage *image = [UIImage imageNamed:imageName];
                        if (image) {
                            CGRect imageDrawRect;
                            imageDrawRect.size = CGSizeMake(20, 20);
                            imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x;
                            imageDrawRect.origin.y = lineOrigin.y - 2;
                            

                            CGContextDrawImage(ctx, imageDrawRect, image.CGImage);
                        }
                        
                    }
                }
            }
        }
    }
    CFRelease(path);
    CFRelease(framesetter);
    
    CTFrameDraw(frame, ctx);
    CFRelease(frame);
}

- (void) dealloc{
    [attString release];
    
    [super dealloc];
}

@end
