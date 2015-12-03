//
//  DSParseQRCodeFromImage.m
//  QRCodeScaningDemo
//
//  Created by LS on 12/3/15.
//  Copyright © 2015 LS. All rights reserved.
//

#import "DSParseQRCodeFromImage.h"
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>

@interface DSParseQRCodeFromImage ()

@property (nonatomic, strong) UIImage *sourceImage;

@end

@implementation DSParseQRCodeFromImage

+ (instancetype)parseQRCodeWithImage:(UIImage *)image
{
    return [[self alloc] initWithImage:image];
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if(self)
    {
        _sourceImage = image;
        _parseTipContent = @"未解析到内容";
    }
    
    return self;
}

- (void)parse
{
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES),
                                                         kCIContextPriorityRequestLow : @(NO)}];
    
    NSData *imageData = UIImageJPEGRepresentation(self.sourceImage, 1);

    CIImage *image = [CIImage imageWithData:imageData];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:nil];
    NSArray *fetures = [detector featuresInImage:image options:@{CIDetectorImageOrientation : [[image properties] valueForKey:(__bridge NSString *)kCGImagePropertyOrientation]}];
    if(fetures.count > 0)
    {
        CIQRCodeFeature *resultFeature = [fetures firstObject];
        NSString *result = resultFeature.messageString ?: self.parseTipContent;
        if(self.delegate && [self.delegate respondsToSelector:@selector(parseQRCodeFromImage:parseSuccessful:)])
        {
            [self.delegate parseQRCodeFromImage:self parseSuccessful:result];
        }
    }
}

@end
