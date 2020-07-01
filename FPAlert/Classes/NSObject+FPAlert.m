//
//  FPAlert.m
//  FPAlertDemo
//
//  Created by Podul on 2019/11/8.
//  Copyright © 2019 Geetol. All rights reserved.
//

#import "FPAlert.h"


#pragma mark - FPAlertAction
@interface FPAlertAction : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) FPAlertActionHandler actionHandler;
@property (nonatomic, assign) UIAlertActionStyle style;

+ (instancetype)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(FPAlertActionHandler)handler;
@end

@implementation FPAlertAction
+ (instancetype)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(FPAlertActionHandler)handler {
    FPAlertAction *alertAction = [[FPAlertAction alloc] init];
    alertAction.title = title;
    alertAction.actionHandler = handler;
    alertAction.style = style;
    return alertAction;
}
@end



#pragma mark - FPAlert
@interface FPAlert ()
@property (nonatomic, copy) NSString *aTitle;
@property (nonatomic, copy) NSString *aMessage;
@property (nonatomic, assign) UIAlertControllerStyle style;

@property (nonatomic, strong) NSMutableArray<FPAlertTextFieldHandler> *textFieldHandlers;
@property (nonatomic, strong) NSMutableArray<FPAlertAction *> *allActions;

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

- (NSMutableArray<FPAlertAction *> *)allActions {
    if (_allActions == nil) {
        _allActions = [NSMutableArray array];
    }
    return _allActions;
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
        [self.allActions addObject:[FPAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:cancel]];
        return self;
    };
}

/// 添加 Default Action
- (FPAlert * _Nonnull (^)(NSString * _Nonnull, FPAlertActionHandler))action {
    return ^id(NSString *title, FPAlertActionHandler handler) {
        [self.allActions addObject:[FPAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:handler]];
        return self;
    };
}

/// 添加 Destructive Action
- (FPAlert * _Nonnull (^)(NSString * _Nonnull, FPAlertActionHandler))destructive {
    return ^id(NSString *title, FPAlertActionHandler handler) {
        [self.allActions addObject:[FPAlertAction actionWithTitle:title style:UIAlertActionStyleDestructive handler:handler]];
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
        
        // Add Action
        for (FPAlertAction *alertAction in self.allActions) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:alertAction.title style:alertAction.style handler:^(UIAlertAction * _Nonnull action) {
                [self.class hideAlertController:alertVC];
                alertAction.actionHandler ? alertAction.actionHandler(action) : nil;
            }];
            [alertVC addAction:action];
        }
        
        // sourceView sourceRect barButtonItem
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            alertVC.popoverPresentationController.sourceView = self.sourceView;
            alertVC.popoverPresentationController.sourceRect = self.sourceRect;
            alertVC.popoverPresentationController.barButtonItem = self.barButtonItem;
        }
        
        // alert
        [self.class showAlertController:alertVC];
    };
}

#pragma mark Private
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
    [[self alertWindow] setHidden:NO];
}

+ (void)hideWindow {
    [[self alertWindow] setHidden:YES];
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
@implementation NSObject (FPAlert)

+ (FPAlert *)alert {
    FPAlert *fpAlert = [[FPAlert alloc] init];
    fpAlert.style = UIAlertControllerStyleAlert;
    return fpAlert;
}

- (FPAlert *)alert {
    return [self.class alert];
}

+ (FPAlert * _Nonnull (^)(id<ActionSheetViewProtocol> _Nonnull, CGRect))actionSheet {
    return ^FPAlert *(id<ActionSheetViewProtocol> item, CGRect sourceRect) {
        FPAlert *alert = [[FPAlert alloc] init];
        if ([item isKindOfClass:UIView.class]) {
            alert.sourceView = (UIView *)item;
        }else {
            alert.barButtonItem = (UIBarButtonItem *)item;
        }
        alert.sourceRect = sourceRect;
        return alert;
    };
}

- (FPAlert * _Nonnull (^)(id<ActionSheetViewProtocol> _Nonnull, CGRect))actionSheet {
    return [self.class actionSheet];
}
@end
