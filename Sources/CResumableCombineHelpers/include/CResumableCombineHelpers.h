//
//  CResumableCombineHelpers.h
//  
//
//  Created by Sergej Jaskiewicz on 23/09/2019.
//

#ifndef CRESUMABLECOMBINEHELPERS_H
#define CRESUMABLECOMBINEHELPERS_H

#include <stdint.h>

#if __has_attribute(swift_name)
# define RESUMABLECOMBINE_SWIFT_NAME(_name) __attribute__((swift_name(#_name)))
#else
# define RESUMABLECOMBINE_SWIFT_NAME(_name)
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma mark - CombineIdentifier

uint64_t resumablecombine_next_combine_identifier(void)
    RESUMABLECOMBINE_SWIFT_NAME(__nextCombineIdentifier());

#pragma mark - ResumableCombineUnfairLock

/// A wrapper around an opaque pointer for type safety in Swift.
typedef struct ResumableCombineUnfairLock {
    void* _Nonnull opaque;
} RESUMABLECOMBINE_SWIFT_NAME(__UnfairLock) ResumableCombineUnfairLock;

/// Allocates a lock object. The allocated object must be destroyed by calling
/// the destroy() method.
ResumableCombineUnfairLock resumablecombine_unfair_lock_alloc(void)
    RESUMABLECOMBINE_SWIFT_NAME(__UnfairLock.allocate());

void resumablecombine_unfair_lock_lock(ResumableCombineUnfairLock)
    RESUMABLECOMBINE_SWIFT_NAME(__UnfairLock.lock(self:));

void resumablecombine_unfair_lock_unlock(ResumableCombineUnfairLock)
    RESUMABLECOMBINE_SWIFT_NAME(__UnfairLock.unlock(self:));

void resumablecombine_unfair_lock_assert_owner(ResumableCombineUnfairLock mutex)
    RESUMABLECOMBINE_SWIFT_NAME(__UnfairLock.assertOwner(self:));

void resumablecombine_unfair_lock_dealloc(ResumableCombineUnfairLock lock)
    RESUMABLECOMBINE_SWIFT_NAME(__UnfairLock.deallocate(self:));

#pragma mark - ResumableCombineUnfairRecursiveLock

/// A wrapper around an opaque pointer for type safety in Swift.
typedef struct ResumableCombineUnfairRecursiveLock {
    void* _Nonnull opaque;
} RESUMABLECOMBINE_SWIFT_NAME(__UnfairRecursiveLock) ResumableCombineUnfairRecursiveLock;

ResumableCombineUnfairRecursiveLock resumablecombine_unfair_recursive_lock_alloc(void)
    RESUMABLECOMBINE_SWIFT_NAME(__UnfairRecursiveLock.allocate());

void resumablecombine_unfair_recursive_lock_lock(ResumableCombineUnfairRecursiveLock)
    RESUMABLECOMBINE_SWIFT_NAME(__UnfairRecursiveLock.lock(self:));

void resumablecombine_unfair_recursive_lock_unlock(ResumableCombineUnfairRecursiveLock)
    RESUMABLECOMBINE_SWIFT_NAME(__UnfairRecursiveLock.unlock(self:));

void resumablecombine_unfair_recursive_lock_dealloc(ResumableCombineUnfairRecursiveLock lock)
    RESUMABLECOMBINE_SWIFT_NAME(__UnfairRecursiveLock.deallocate(self:));

#pragma mark - Breakpoint

void resumablecombine_stop_in_debugger(void) RESUMABLECOMBINE_SWIFT_NAME(__stopInDebugger());

#ifdef __cplusplus
} // extern "C"
#endif

#endif /* CRESUMABLECOMBINEHELPERS_H */
