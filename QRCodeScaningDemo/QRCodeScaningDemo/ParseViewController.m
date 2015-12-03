//
//  ParseViewController.m
//  QRCodeScaningDemo
//
//  Created by LS on 12/3/15.
//  Copyright © 2015 LS. All rights reserved.
//

#import "ParseViewController.h"
#import "DSParseQRCodeFromImage.h"

@interface ParseViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,DSParseQRCodeFromImageDelegate>

@property (nonatomic, strong) DSParseQRCodeFromImage *parse;

@end

@implementation ParseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    _parse = [DSParseQRCodeFromImage parseQRCodeWithImage:image];
    _parse.delegate = self;
    [_parse parse];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)parseQRCodeFromImage:(DSParseQRCodeFromImage *)parse parseSuccessful:(NSString *)result
{
    NSLog(@"%@",result);

    [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"结果:%@",result] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}

@end
