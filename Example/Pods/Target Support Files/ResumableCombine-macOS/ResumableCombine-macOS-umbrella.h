#ifdef __OBJC__
#import <Cocoa/Cocoa.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CResumableCombineHelpers.h"

FOUNDATION_EXPORT double ResumableCombineVersionNumber;
FOUNDATION_EXPORT const unsigned char ResumableCombineVersionString[];

