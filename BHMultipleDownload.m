#import "BHMultipleDownload.h"

@implementation BHMultipleDownload {
    NSMutableArray<NSURL *> *_downloadedFilePaths;

    NSMutableDictionary<NSNumber *, NSString *> *_extensionsByTaskID;
    NSInteger _completedDownloads;
    NSInteger _totalDownloads;
    NSInteger _failedDownloads;
    int64_t _aggregatedBytesWritten;
    int64_t _aggregatedTotalBytes;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return self;
}

- (void)downloadFiles:(NSArray<NSURL *> *)fileURLs {
    _downloadedFilePaths = [NSMutableArray array];
    _extensionsByTaskID = [NSMutableDictionary dictionary];
    _completedDownloads = 0;
    _failedDownloads = 0;
    _aggregatedBytesWritten = 0;
    _aggregatedTotalBytes = 0;
    _totalDownloads = fileURLs.count;

    for (NSURL *fileURL in fileURLs) {
        NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:fileURL];

        if (fileURL.pathExtension.length > 0) {
            _extensionsByTaskID[@(downloadTask.taskIdentifier)] = fileURL.pathExtension;
        }
        [downloadTask resume];
    }

    if (fileURLs.count == 0) {
        [self finishIfDone];
    }
}

- (NSString *)extensionForTask:(NSURLSessionDownloadTask *)downloadTask {
    return _extensionsByTaskID[@(downloadTask.taskIdentifier)] ?: @"";
}

- (void)finishIfDone {
    if (_completedDownloads + _failedDownloads < _totalDownloads) {
        return;
    }
    if (_completedDownloads > 0) {

        if ([self.delegate respondsToSelector:@selector(downloaderDidFinishDownloadingAllFiles:)]) {
            [self.delegate downloaderDidFinishDownloadingAllFiles:_downloadedFilePaths];
        }
    } else {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:-1009 userInfo:@{NSLocalizedDescriptionKey: @"All downloads failed"}];
        if ([self.delegate respondsToSelector:@selector(downloaderDidFailureWithError:)]) {
            [self.delegate downloaderDidFailureWithError:error];
        }
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {

    _aggregatedBytesWritten += bytesWritten;
    if (totalBytesExpectedToWrite > 0) {
        _aggregatedTotalBytes += totalBytesExpectedToWrite;
    }
    if (_aggregatedTotalBytes > 0 && [self.delegate respondsToSelector:@selector(downloaderProgress:)]) {
        float prog = (float)((double)_aggregatedBytesWritten / (double)_aggregatedTotalBytes);
        [self.delegate downloaderProgress:prog];
    }
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
  didFinishDownloadingToURL:(NSURL *)location {

    NSString *suggested = downloadTask.response.suggestedFilename;
    NSString *sourceExt = [self extensionForTask:downloadTask];
    NSString *suggestedExt = suggested.pathExtension;
    if (suggestedExt.length == 0 && sourceExt.length > 0) {
        suggested = [NSString stringWithFormat:@"%@.%@", suggested ?: NSUUID.UUID.UUIDString, sourceExt];
    }
    if (suggested.length == 0) {
        suggested = [NSString stringWithFormat:@"%@.%@", NSUUID.UUID.UUIDString, sourceExt ?: @"jpeg"];
    }
    NSString *destinationPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", NSUUID.UUID.UUIDString, suggested]];

    NSError *error;
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:destinationPath] error:&error];

    if (error == nil) {
        [_downloadedFilePaths addObject:[NSURL fileURLWithPath:destinationPath]];
    }

    _completedDownloads++;
    [self finishIfDone];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (!error || [task isKindOfClass:[NSURLSessionDownloadTask class]] == NO) {
        return;
    }

    _failedDownloads++;
    [self finishIfDone];
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(downloaderDidFailureWithError:)]) {
        [self.delegate downloaderDidFailureWithError:error];
    }
}
@end
