//
//  PreferencesWindowController.m
//  EImage
//
//  Created by ELANCHOU on 1/16/17.
//  Copyright © 2017 ELANCHOU. All rights reserved.
//

#import "PreferencesWindowController.h"

@interface PreferencesWindowController ()

@property (weak) IBOutlet NSTextField *domainTextField;
@property (weak) IBOutlet NSTextField *bucketNameTextField;
@property (weak) IBOutlet NSTextField *accessKeyTextField;
@property (weak) IBOutlet NSTextField *secrectKeyTextField;

@property (weak) IBOutlet NSButton *cancelBtn;
@property (weak) IBOutlet NSButton *confirmBtn;

@property (strong) NSUserDefaults *defaults;

@end

@implementation PreferencesWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.defaults = [NSUserDefaults standardUserDefaults];
    [self setup];
}

- (IBAction)onConfirmBtn:(NSButton *)sender
{
    if ([self saveSettings]){
        [self close];
    }else{
        
    };
}
- (IBAction)onCancelBtn:(NSButton *)sender
{
    [self close];
}

- (void)setup
{
    _domainTextField.stringValue = [_defaults objectForKey:@"domain"];
    _bucketNameTextField.stringValue = [_defaults objectForKey:@"bucketName"];
    _accessKeyTextField.stringValue = [_defaults objectForKey:@"accessKey"];
    _secrectKeyTextField.stringValue = [_defaults objectForKey:@"secrectKey"];
}

- (BOOL)saveSettings
{
    if ([[_domainTextField stringValue] isEqualToString:@""] || [[_bucketNameTextField stringValue] isEqualToString:@""] || [[_accessKeyTextField stringValue] isEqualToString:@""] || [[_secrectKeyTextField stringValue] isEqualToString:@""]) return NO;
    [_defaults setObject:[_domainTextField stringValue] forKey:@"domain"];
    [_defaults setObject:[_bucketNameTextField stringValue] forKey:@"bucketName"];
    [_defaults setObject:[_accessKeyTextField stringValue] forKey:@"accessKey"];
    [_defaults setObject:[_secrectKeyTextField stringValue] forKey:@"secrectKey"];
    return YES;
}

@end
