//
//  UIAlertController+FPAlert.h
//  FPAlert
//
//  Created by Podul on 2019/11/8.
//  Copyright © 2019 Geetol. All rights reserved.
//

#import <UIKit/UIKit.h>

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


#pragma UIAlertController Category
@interface UIAlertController (FPAlert)

/// UIAlertControllerStyleAlert
+ (FPAlert *)alert;

/// UIAlertControllerStyleActionSheet
+ (FPAlert *)actionSheet;
+ (FPAlert * (^)(UIView *))actionSheet1;
+ (FPAlert * (^)(UIBarButtonItem *))actionSheet2;
+ (FPAlert * (^)(UIView *, CGRect))actionSheet3;
+ (FPAlert * (^)(UIBarButtonItem *, CGRect))actionSheet4;
@end

NS_ASSUME_NONNULL_END
