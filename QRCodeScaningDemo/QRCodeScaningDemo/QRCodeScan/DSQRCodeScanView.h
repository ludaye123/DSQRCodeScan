//
//  DSQRCodeScanView.h
//  QRCodeScaningDemo
//
//  Created by LS on 12/2/15.
//  Copyright © 2015 LS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DSQRCodeScanViewDelegate;

@interface DSQRCodeScanView : UIView
{
}

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, weak) id<DSQRCodeScanViewDelegate> delegate;

+ (instancetype)scanViewWithFrame:(CGRect)frame;

- (void)startScan;
- (void)stopScan;

@end

@protocol DSQRCodeScanViewDelegate <NSObject>

@optional
- (void)qrcodeScanView:(DSQRCodeScanView *)view scanSuccessful:(NSString *)result;

@end