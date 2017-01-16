//
//  DropFileViewController.m
//  EImage
//
//  Created by ELANCHOU on 1/16/17.
//  Copyright © 2017 ELANCHOU. All rights reserved.
//

#import "DropFileViewController.h"
#import "DropView.h"
#import <QiniuSDK.h>
#import "ECQiNiuUploadManager.h"

@interface DropFileViewController ()

@property (weak) IBOutlet NSTextField *errorTextField;
@property (weak) IBOutlet DropView *dropView;

@end

@implementation DropFileViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _errorTextField.alphaValue = 0.0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(multiFilesDrop) name:DropViewErrorMultiFilesNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotTheFilePath:) name:DropViewDidGotFileNotification object:nil];
    [[ECQiNiuUploadManager sharedManager] registerWithScope:@"blog" accessKey:@"wPRgAg_Lr9WdzR66GWRMLohN7ujrsF18wGnNxPkS" secretKey:@"ztCAxQ-C6RvgjJ1JPKJMOZUPq__4dV8JIQicn1f0" liveTime:5];
    [[ECQiNiuUploadManager sharedManager] createToken];
}

- (void)multiFilesDrop
{
    _errorTextField.alphaValue = 1.0;
}

- (void)gotTheFilePath:(NSNotification *)notification
{
    NSString *file = notification.object;
    [[ECQiNiuUploadManager sharedManager] uploadData:[self readDataFromFileAtURL:[NSURL URLWithString:file]] progress:^(float progress){
        NSLog(@"progress:%f",progress);
    } completion:^(NSError *error, NSString *link, NSInteger index){
        NSLog(@"error:%@",error);
        NSLog(@"link:%@",link);
    }];
    
}

- (NSData*)readDataFromFileAtURL:(NSURL*)anURL {
    NSFileHandle* aHandle = [NSFileHandle fileHandleForReadingFromURL:anURL error:nil];
    NSData* fileContents = nil;
    if (aHandle)
        fileContents = [aHandle readDataToEndOfFile];
    
    return fileContents;
}

@end
