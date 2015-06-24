//
//  FontAwesome.h
//  FontAwesomeTools-iOS is Copyright 2013 TapTemplate and released under the MIT license.
//  www.taptemplate.com
//

#import <Foundation/Foundation.h>
#import "NSString+FontAwesome.h"

@interface FontAwesome : NSObject


+ (UILabel*)labelWithFAIcon:(FMIconFont)fa_icon
                       size:(CGFloat)size
                      color:(UIColor*)color;

//================================
// Image Methods
//================================

/*! Create a UIImage with a FontAwesome icon, with the image and the icon the same size
 */
+ (UIImage*)imageWithIcon:(FMIconFont)fa_icon
                iconColor:(UIColor*)iconColor
                 iconSize:(CGFloat)iconSize;

/*! Create a UIImage with a FontAwesome icon, and specify a square size for the icon, which will be centered within the CGSize specified for the image itself.
 */
+ (UIImage*)imageWithIcon:(FMIconFont)fa_icon
                iconColor:(UIColor*)color
                 iconSize:(CGFloat)iconSize
                imageSize:(CGSize)imageSize;

/*! The image and the icon inside it can be from a custom font:
 */
+ (UIImage*)imageWithText:(NSString*)characterCodeString
                     font:(UIFont*)font
                iconColor:(UIColor*)iconColor
                imageSize:(CGSize)imageSize;

@end
