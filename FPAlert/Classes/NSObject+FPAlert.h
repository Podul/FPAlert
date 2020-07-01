//
//  FPAlert.h
//  FPAlertDemo
//
//  Created by Podul on 2019/11/8.
//  Copyright © 2019 Geetol. All rights reserved.
//

#import <Foundation/NSObject.h>
#import <UIKit/UIView.h>
#import <UIKit/UIBarButtonItem.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FPAlertActionHandler)(UIAlertAction *);
typedef void(^FPAlertTextFieldHandler)(UITextField *);


@interface FPAlert : NSObject

- (FPAlert * (^)(NSString *))title;
- (FPAlert * (^)(NSString *))message;
- (FPAlert * (^)(_Nullable FPAlertTextFieldHandler))textField;

/// Action
- (FPAlert * (^)(NSString *, _Nullable FPAlertActionHandler))cancel;
- (FPAlert * (^)(NSString *, _Nullable FPAlertActionHandler))action;
- (FPAlert * (^)(NSString *, _Nullable FPAlertActionHandler))destructive;

/// 最后调用 show()
- (void (^)(void))show;
@end


#pragma mark - UIAlertController Category
@protocol ActionSheetViewProtocol;

@interface NSObject (FPAlert)

/// UIAlertControllerStyleAlert
+ (FPAlert *)alert;
- (FPAlert *)alert;

/// UIAlertControllerStyleActionSheet
+ (FPAlert * (^)(id<ActionSheetViewProtocol>, CGRect) )actionSheet;
- (FPAlert * (^)(id<ActionSheetViewProtocol>, CGRect) )actionSheet;
@end

#pragma mark - Protocol
@protocol ActionSheetViewProtocol <NSObject>
@end

@interface UIView ()<ActionSheetViewProtocol>

@end

@interface UIBarButtonItem ()<ActionSheetViewProtocol>

@end

NS_ASSUME_NONNULL_END
