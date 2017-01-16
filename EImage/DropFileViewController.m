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
#import "PreferencesWindowController.h"

@interface DropFileViewController ()

@property (weak) IBOutlet NSTextField *errorTextField;
@property (weak) IBOutlet DropView *dropView;

@property (strong) PreferencesWindowController *preferencesWindowsController;

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
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    if ([self setup]){
        
    }
}

- (BOOL)setup
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"bucketName"]){
        [[ECQiNiuUploadManager sharedManager] registerWithScope:[defaults objectForKey:@"bucketName"] accessKey:[defaults objectForKey:@"accessKey"] secretKey:[defaults objectForKey:@"secrectKey"] liveTime:5];
        [ECQiNiuUploadManager sharedManager].domain = [defaults objectForKey:@"domain"];
        [[ECQiNiuUploadManager sharedManager] createToken];
        return YES;
    }
    return NO;
}

- (void)multiFilesDrop
{
    _errorTextField.alphaValue = 1.0;
}
- (IBAction)onPreferenceBtn:(NSButton *)sender
{
    self.preferencesWindowsController = [[PreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindowController"];
    [_preferencesWindowsController showWindow:self];
    [NSApp activateIgnoringOtherApps:YES];
    [_preferencesWindowsController.window makeKeyAndOrderFront:self];
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
