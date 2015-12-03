//
//  DSParseQRCodeFromImage.h
//  QRCodeScaningDemo
//
//  Created by LS on 12/3/15.
//  Copyright © 2015 LS. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  从图片中解析二维码
 */
@protocol DSParseQRCodeFromImageDelegate;

@interface DSParseQRCodeFromImage : NSObject

@property (nonatomic, copy) NSString *parseTipContent;
@property (nonatomic, weak) id<DSParseQRCodeFromImageDelegate> delegate;

+ (instancetype)parseQRCodeWithImage:(UIImage *)image;
- (instancetype)initWithImage:(UIImage *)image;

- (void)parse;

@end

@protocol DSParseQRCodeFromImageDelegate <NSObject>

@optional
- (void)parseQRCodeFromImage:(DSParseQRCodeFromImage *)parse parseSuccessful:(NSString *)result;

@end
