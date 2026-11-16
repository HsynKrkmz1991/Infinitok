
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NSBundle * _Nullable InfinitokBundle(void);

NSString *InfinitokLocalizedString(NSString *key);

#define IKLocalize(key) InfinitokLocalizedString(key)

NS_ASSUME_NONNULL_END
