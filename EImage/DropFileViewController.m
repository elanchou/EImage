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
#import "ProgressView.h"

@interface DropFileViewController ()

@property (weak) IBOutlet DropView *dropView;

@property (weak) IBOutlet NSTextField *errorTextField;

@property (weak) IBOutlet ProgressView *progressView;
@property (weak) IBOutlet NSTextField *progressLabel;

@property (weak) IBOutlet NSTextField *dragLabel;
@property (weak) IBOutlet NSImageView *dragImageView;

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
    [self endUpload];
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
    _errorTextField.hidden = NO;
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
    __weak typeof(self) weakSelf = self;
    [[ECQiNiuUploadManager sharedManager] uploadData:[self readDataFromFileAtURL:[NSURL URLWithString:file]] progress:^(float progress){
        NSLog(@"%.2f",progress);
        dispatch_async(dispatch_get_main_queue(),^{
            [weakSelf startUpload];
            weakSelf.progressLabel.stringValue = [NSString stringWithFormat:@"%.2f%%",progress * 100];
            weakSelf.progressView.progress = progress;
            [weakSelf.progressView setNeedsDisplay:YES];
        });
    } completion:^(NSError *error, NSString *link, NSInteger index){
        dispatch_async(dispatch_get_main_queue(),^{
            [weakSelf endUpload];
            [weakSelf writeToPasteBoard:link];
        });
    }];
    
}

- (BOOL) writeToPasteBoard:(NSString *)stringToWrite
{
    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
    return [pasteBoard setString:stringToWrite forType:NSStringPboardType];
}

- (void)startUpload
{
    _progressView.hidden = NO;
    _dragLabel.hidden = YES;
    _dragImageView.hidden = YES;
}

- (void)endUpload
{
    _progressView.hidden = YES;
    _dragLabel.hidden = NO;
    _dragImageView.hidden = NO;
}

- (NSData*)readDataFromFileAtURL:(NSURL*)anURL {
    NSFileHandle* aHandle = [NSFileHandle fileHandleForReadingFromURL:anURL error:nil];
    NSData* fileContents = nil;
    if (aHandle)
        fileContents = [aHandle readDataToEndOfFile];
    
    return fileContents;
}

@end
