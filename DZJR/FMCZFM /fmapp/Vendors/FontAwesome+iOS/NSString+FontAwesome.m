//
//  NSString+FontAwesome.m
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

#import "NSString+FontAwesome.h"

@implementation NSString (FontAwesome)

#pragma mark - Public API
+ (FMIconFont)fontAwesomeEnumForIconIdentifier:(NSString*)string {
    NSDictionary *enums = [self enumDictionary];
    return [enums[string] integerValue];
}

+ (NSString*)fontAwesomeIconStringForEnum:(FMIconFont)value {
    
    
    
    
    return [NSString fontAwesomeUnicodeStrings][value];
}

+ (NSString*)fontAwesomeIconStringForIconIdentifier:(NSString*)identifier {
    return [self fontAwesomeIconStringForEnum:[self fontAwesomeEnumForIconIdentifier:identifier]];
}


#pragma mark - Data Initialization
+ (NSArray *)fontAwesomeUnicodeStrings {
    
    static NSArray *fontAwesomeUnicodeStrings;
    
    static dispatch_once_t unicodeStringsOnceToken;
    dispatch_once(&unicodeStringsOnceToken, ^{
        
        fontAwesomeUnicodeStrings = @[@"\uf000", @"\uf001", @"\uf002", @"\uf003",
                                      @"\uf004", @"\uf005", @"\uf006", @"\uf007",
                                      @"\uf008", @"\uf009", @"\uf00a", @"\uf00b",
                                      @"\uf00c", @"\uf00d", @"\uf00e", @"\uf00f",
                                      @"\uf010", @"\uf011", @"\uf012", @"\uf013",
                                      @"\uf014", @"\uf015", @"\uf016", @"\uf017",
                                      @"\uf018", @"\uf019", @"\uf01a", @"\uf01b",
                                      @"\uf01c", @"\uf01d", @"\uf01e", @"\uf01f",
                                      @"\uf020", @"\uf021", @"\uf022", @"\uf023",
                                      @"\uf024", @"\uf025", @"\uf026", @"\uf027",
                                      @"\uf028", @"\uf029", @"\uf02a", @"\uf02b",
                                      @"\uf02c", @"\uf02d", @"\uf02e", @"\uf02f",
                                      @"\uf030", @"\uf031", @"\uf032", @"\uf033",
                                      @"\uf034", @"\uf035", @"\uf036", @"\uf037",
                                      @"\uf038", @"\uf039", @"\uf03a", @"\uf03b",
                                      @"\uf03c", @"\uf03d", @"\uf03e", @"\uf03f",
                                      @"\uf040", @"\uf041", @"\uf042", @"\uf043",
                                      @"\uf044", @"\uf045", @"\uf046", @"\uf047",];
    });
    
    return fontAwesomeUnicodeStrings;
}

+ (NSDictionary *)enumDictionary {
    
	static NSDictionary *enumDictionary;
    
    static dispatch_once_t enumDictionaryOnceToken;
    dispatch_once(&enumDictionaryOnceToken, ^{
        
		NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
		enumDictionary = tmp;
	});
    
    return enumDictionary;
}

@end
