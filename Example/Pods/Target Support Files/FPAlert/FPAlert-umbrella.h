#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FPAlert.h"
#import "UIAlertController+FPAlert.h"

FOUNDATION_EXPORT double FPAlertVersionNumber;
FOUNDATION_EXPORT const unsigned char FPAlertVersionString[];

