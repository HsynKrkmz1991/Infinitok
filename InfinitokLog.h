#ifndef INFINITOK_LOG_H
#define INFINITOK_LOG_H

#import <Foundation/Foundation.h>
#import <os/log.h>

static inline os_log_t InfinitokLogHandle(void) {
    static os_log_t handle;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        handle = os_log_create("com.mod4.infinitok", "tweak");
    });
    return handle;
}

static inline BOOL InfinitokDebugLoggingEnabled(void) {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"debug_logging"];
}

static inline NSString *InfinitokDebugLogFilePath(void) {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"infinitok_debug.log"];
}

static inline void InfinitokWriteDebugLogFile(NSString *message) {
    @try {
        NSString *logPath = InfinitokDebugLogFilePath();
        NSString *timestamp = [[NSDate date] description];
        NSString *logMessage = [NSString stringWithFormat:@"[%@] %@\n", timestamp, message];
        NSData *logData = [logMessage dataUsingEncoding:NSUTF8StringEncoding];
        if (!logData) return;

        if ([[NSFileManager defaultManager] fileExistsAtPath:logPath]) {
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logPath];
            [fileHandle seekToEndOfFile];
            [fileHandle writeData:logData];
            [fileHandle closeFile];
        } else {
            [logMessage writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    } @catch (__unused NSException *exception) {

    }
}

#define ITLog(tag, fmt, ...) \
    do { \
        NSString *_itMsg = [NSString stringWithFormat:(fmt), ##__VA_ARGS__]; \
        os_log(InfinitokLogHandle(), "INFINITOK [" tag "] %{public}s", [_itMsg UTF8String]); \
        InfinitokWriteDebugLogFile([NSString stringWithFormat:@"[%s] %@", tag, _itMsg]); \
    } while (0)

#define ITError(tag, fmt, ...) \
    do { \
        NSString *_itMsg = [NSString stringWithFormat:(fmt), ##__VA_ARGS__]; \
        os_log_error(InfinitokLogHandle(), "INFINITOK [" tag "] ERROR: %{public}s", [_itMsg UTF8String]); \
        InfinitokWriteDebugLogFile([NSString stringWithFormat:@"[%s] ERROR: %@", tag, _itMsg]); \
    } while (0)

#define ITDebug(tag, fmt, ...) \
    do { if (InfinitokDebugLoggingEnabled()) ITLog(tag, fmt, ##__VA_ARGS__); } while (0)

#endif
