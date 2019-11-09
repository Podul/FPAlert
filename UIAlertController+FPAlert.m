//
//  UIAlertController+FPAlert.m
//  FPAlert
//
//  Created by Podul on 2019/11/8.
//  Copyright © 2019 Geetol. All rights reserved.
//

#import "UIAlertController+FPAlert.h"


#pragma mark - FPAlertAction
@interface FPAlertAction : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) FPAlertActionHandler actionHandler;

+ (instancetype)actionWithTitle:(NSString *)title handler:(FPAlertActionHandler)handler;
@end

@implementation FPAlertAction
+ (instancetype)actionWithTitle:(NSString *)title handler:(FPAlertActionHandler)handler {
    FPAlertAction *alertAction = [[FPAlertAction alloc] init];
    alertAction.title = title;
    alertAction.actionHandler = handler;
    return alertAction;
}
@end



#pragma mark - FPAlert
@interface FPAlert ()
@property (nonatomic, copy) NSString *aTitle;
@property (nonatomic, copy) NSString *aMessage;
@property (nonatomic, assign) UIAlertControllerStyle style;

@property (nonatomic, strong) NSMutableArray<FPAlertTextFieldHandler> *textFieldHandlers;
@property (nonatomic, strong) NSMutableArray<FPAlertAction *> *defaultActions;
@property (nonatomic, strong) NSMutableArray<FPAlertAction *> *destructiveActions;


@property (nonatomic, copy) NSString *aCancel;
@property (nonatomic, copy) FPAlertActionHandler cancelHandler;

/// iPad ActionSheet 样式需要
@property (nonatomic, weak) UIView *sourceView;
@property (nonatomic, assign) CGRect sourceRect;
@property (nonatomic, weak) UIBarButtonItem *barButtonItem;

@end

@implementation FPAlert
#pragma Mark - Set & Get
- (NSMutableArray *)textFieldHandlers {
    if (_textFieldHandlers == nil) {
        _textFieldHandlers = [NSMutableArray array];
    }
    return _textFieldHandlers;
}

- (NSMutableArray<FPAlertAction *> *)defaultActions {
    if (_defaultActions == nil) {
        _defaultActions = [NSMutableArray array];
    }
    return _defaultActions;
}

- (NSMutableArray<FPAlertAction *> *)destructiveActions {
    if (_destructiveActions == nil) {
        _destructiveActions = [NSMutableArray array];
    }
    return _destructiveActions;
}


#pragma mark - Public
- (FPAlert * _Nonnull (^)(NSString * _Nonnull))title {
    return ^id(NSString *title) {
        self.aTitle = title;
        return self;
    };
}

- (FPAlert * _Nonnull (^)(NSString * _Nonnull))message {
    return ^id(NSString *title) {
        self.aMessage = title;
        return self;
    };
}

/// 添加 Cancel Action
- (FPAlert * _Nonnull (^)(NSString * _Nonnull, FPAlertActionHandler))cancel {
    return ^id(NSString *title, FPAlertActionHandler cancel) {
        self.aCancel = title;
        self.cancelHandler = cancel;
        return self;
    };
}

/// 添加 Default Action
- (FPAlert * _Nonnull (^)(NSString * _Nonnull, FPAlertActionHandler))action {
    return ^id(NSString *title, FPAlertActionHandler handler) {
        [self.defaultActions addObject:[FPAlertAction actionWithTitle:title handler:handler]];
        return self;
    };
}

/// 添加 Destructive Action
- (FPAlert * _Nonnull (^)(NSString * _Nonnull, FPAlertActionHandler))destructive {
    return ^id(NSString *title, FPAlertActionHandler handler) {
        [self.destructiveActions addObject:[FPAlertAction actionWithTitle:title handler:handler]];
        return self;
    };
}

/// 添加 UITextField
- (FPAlert * _Nonnull (^)(FPAlertTextFieldHandler))textField {
    return ^id(FPAlertTextFieldHandler handler) {
        [self.textFieldHandlers addObject:handler];
        return self;
    };
}

#pragma mark - Core
- (void (^)(void))show {
    return ^void(void) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:self.aTitle message:self.aMessage preferredStyle:self.style];
        
        // UITextField
        for (FPAlertTextFieldHandler handler in self.textFieldHandlers) {
            [alertVC addTextFieldWithConfigurationHandler:handler];
        }
        
        // Cancel Action
        if (self.aCancel.length > 0) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:self.aCancel style:UIAlertActionStyleCancel handler:self.cancelHandler];
            [alertVC addAction:action];
        }
        
        // Default Action
        for (FPAlertAction *defaultAction in self.defaultActions) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:defaultAction.title style:UIAlertActionStyleDefault handler:defaultAction.actionHandler];
            [alertVC addAction:action];
        }
        
        // Destructive Action
        for (FPAlertAction *destructiveAction in self.destructiveActions) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:destructiveAction.title style:UIAlertActionStyleDestructive handler:destructiveAction.actionHandler];
            [alertVC addAction:action];
        }
        
        // sourceView sourceRect
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            alertVC.popoverPresentationController.sourceView = self.sourceView;
            alertVC.popoverPresentationController.sourceRect = self.sourceRect;
            alertVC.popoverPresentationController.barButtonItem = self.barButtonItem;
        }
        
        [self.class showAlertController:alertVC];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
    };
}

#pragma mark Private
static UIWindow *_oldKeyWindow = nil;
+ (UIViewController *)rootVC {
    static UIViewController *_rootVC = nil;
    if (_rootVC == nil) {
        _rootVC = [[UIViewController alloc] init];
        _rootVC.view.alpha = 0;
    }
    return _rootVC;
}


+ (UIWindow *)alertWindow {
    static UIWindow *_alertWindow = nil;
    if (_alertWindow == nil) {
        _alertWindow = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _alertWindow.rootViewController = [self rootVC];
        _alertWindow.windowLevel = UIWindowLevelAlert;
    }
    return _alertWindow;
}

+ (void)showWindow {
    _oldKeyWindow = UIApplication.sharedApplication.keyWindow;
    [[self alertWindow] makeKeyAndVisible];
}

+ (void)hideWindow {
    [[self alertWindow] setHidden:YES];
    [_oldKeyWindow makeKeyWindow];
}

+ (void)showAlertController:(UIAlertController *)alertVC {
    [self showWindow];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self alertWindow].rootViewController presentViewController:alertVC animated:YES completion:nil];
    });
}

+ (void)hideAlertController:(UIAlertController *)alertVC {
    [[self alertWindow].rootViewController dismissViewControllerAnimated:YES completion:nil];
    [self hideWindow];
}

@end



#pragma mark - UIAlertController
@implementation UIAlertController (FPAlert)

+ (FPAlert *)alert {
    FPAlert *fpAlert = [[FPAlert alloc] init];
    fpAlert.style = UIAlertControllerStyleAlert;
    return fpAlert;
}

+ (FPAlert *)actionSheet {
    FPAlert *fpAlert = [[FPAlert alloc] init];
    fpAlert.style = UIAlertControllerStyleActionSheet;
    return fpAlert;
}

+ (FPAlert * _Nonnull (^)(UIView * _Nonnull))actionSheet1 {
    return ^id(UIView *sourceView) {
        FPAlert *alert = [self actionSheet];
        alert.sourceView = sourceView;
        return alert;
    };
}

+ (FPAlert * _Nonnull (^)(UIBarButtonItem * _Nonnull))actionSheet2 {
    return ^id(UIBarButtonItem *barButtonItem) {
        FPAlert *alert = [self actionSheet];
        alert.barButtonItem = barButtonItem;
        return alert;
    };
}

+ (FPAlert * _Nonnull (^)(UIView * _Nonnull, CGRect))actionSheet3 {
    return ^id(UIView *sourceView, CGRect sourceRect) {
        FPAlert *alert = [self actionSheet];
        alert.sourceView = sourceView;
        alert.sourceRect = sourceRect;
        return alert;
    };
}

+ (FPAlert * _Nonnull (^)(UIBarButtonItem * _Nonnull, CGRect))actionSheet4 {
    return ^id(UIBarButtonItem *barButtonItem, CGRect sourceRect) {
        FPAlert *alert = [self actionSheet];
        alert.barButtonItem = barButtonItem;
        alert.sourceRect = sourceRect;
        return alert;
    };
}
@end
