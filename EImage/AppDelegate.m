//
//  AppDelegate.m
//  EImage
//
//  Created by ELANCHOU on 1/16/17.
//  Copyright © 2017 ELANCHOU. All rights reserved.
//

#import "AppDelegate.h"
#import "DropFileViewController.h"
#import "NSView+VisualEffect.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSPopover *popover;

@property (strong, nonatomic) NSEvent *popoverTransiencyMonitor;

@property (nonatomic, strong) DropFileViewController *dropVC;
@property (nonatomic, strong) NSWindowController *windowController;

@end

@implementation AppDelegate{
    BOOL _isWindowMode;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:-2];
    if (_statusItem){
        NSButton *statusBtn = _statusItem.button;
        statusBtn.image = [NSImage imageNamed:@"menu"];
        statusBtn.action = @selector(onStatusBarBtn:);
    }
    self.popover = [[NSPopover alloc] init];
    self.dropVC = [[DropFileViewController alloc] initWithNibName:@"DropFileViewController" bundle:nil];
    _popover.contentViewController = _dropVC;
    _popover.behavior = NSPopoverBehaviorTransient;
    
    _isWindowMode = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modeChange:) name:DropFileViewControllerModeChangeNotification object:nil];
}

- (void)modeChange:(NSNotification *)notification
{
    if (_isWindowMode){
        _windowController.window.contentViewController = nil;
        _popover.contentViewController = _dropVC;
        [_dropVC.view removeVibrancyView];
        [self.windowController close];
        _statusItem.button.action = @selector(onStatusBarBtn:);
        [self showPopover];
        _isWindowMode = NO;
    }else{
        NSWindow *window = [[NSWindow alloc] init];
        [window setFrame:_dropVC.view.window.frame display:YES];
        _popover.contentViewController = nil;
        window.contentViewController = _dropVC;
        [_dropVC.view insertVibrancyViewBlendingMode:NSVisualEffectBlendingModeBehindWindow];
        [window setLevel:NSStatusWindowLevel];
        window.titlebarAppearsTransparent = true;
        window.titleVisibility = YES;
        window.title = @"EImage";
        window.styleMask |= NSWindowStyleMaskClosable | NSFullSizeContentViewWindowMask;
        self.windowController = [[NSWindowController alloc] initWithWindow:window];
        [self.windowController showWindow:self];
        [NSApp activateIgnoringOtherApps:YES];
        [self.windowController.window makeKeyAndOrderFront:self];
        _statusItem.button.action = nil;
        _isWindowMode = YES;
    }
}

- (void)onStatusBarBtn:(id)sender
{
    [self showPopover];
    if(self.popoverTransiencyMonitor == nil)
    {
        self.popoverTransiencyMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseUpMask | NSRightMouseDownMask  handler:^(NSEvent* event)
                                    {
                                        BOOL isInside = [_dropVC.view mouse:event.locationInWindow inRect:_dropVC.view.window.frame];
                                        if (event.type == NSLeftMouseUp){
                                            if (isInside){
                                                return;
                                            }
                                        }
                                        [self closePopover:sender];
                                    }];
    }
}

- (void)showPopover
{
    [_popover showRelativeToRect:_statusItem.button.bounds ofView:_statusItem.button preferredEdge:NSMinYEdge];
}

- (IBAction)closePopover:(id)sender
{
    if(self.popoverTransiencyMonitor)
    {
        [NSEvent removeMonitor:self.popoverTransiencyMonitor];
        
        self.popoverTransiencyMonitor = nil;
    }
    [_popover performClose:sender];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
