//
//  ViewController.m
//  QRCodeScaningDemo
//
//  Created by LS on 12/2/15.
//  Copyright © 2015 LS. All rights reserved.
//

#import "ScanViewController.h"
#import "DSQRCodeScanView.h"
#import <CoreImage/CoreImage.h>

@interface ScanViewController () <DSQRCodeScanViewDelegate>

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DSQRCodeScanView *scanView = [DSQRCodeScanView scanViewWithFrame:self.view.bounds];
    scanView.delegate = self;
    [self.view addSubview:scanView];
}

- (void)qrcodeScanView:(DSQRCodeScanView *)view scanSuccessful:(NSString *)result
{
    NSLog(@"扫描结果:%@",result);
}

@end
