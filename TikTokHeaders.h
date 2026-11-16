#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BHIManager.h"
#import "SecurityViewController.h"
#import "BHDownload.h"
#import "BHMultipleDownload.h"
#import "JGProgressHUD/JGProgressHUD.h"
#import <Photos/Photos.h>
#import "Settings/ViewController.h"
#import "Settings/PlaybackSpeed.h"

@interface AppDelegate : NSObject <UIApplicationDelegate>
@end

@interface TTKCommentPanelViewController: UIViewController
@end

@interface AWEUserNameLabel: UILabel
-(void)addVerifiedIcon:(BOOL)arg1;
@end

@interface TTKProfileRootView: UIView
@end

@interface BDImageView: UIImageView
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
- (void)addHandleLongPress;
- (id)bd_baseImage;
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@end

@interface TTTAttributedLabel: UILabel
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
- (void)addHandleLongPress;
- (void)infinitokTranslateInPlace:(NSString *)originalText;
@end

@interface AWEPlayInteractionAuthorView: UIView
- (void)addSubview:(id)arg1;
@end
@interface TTKProfileUserRelationInfoItemComponent: NSObject
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *titleLabel;
- (NSInteger)p_getCurrentItemIndex;
- (NSString *)getSubTitle;
@end
@interface TUXButton: UIButton
- (BOOL)isLiquidGlassEnabled;
@end
@interface SparkViewController: UIViewController
@property(nonatomic, strong, readwrite) NSURL *originURL;
- (void)didTapCloseButton;
@end

@interface AWEWebViewController: UIViewController
@property(nonatomic, strong, readwrite) NSURL *originURL;
@end

@interface AWEAwemeACLItem: NSObject
- (void)setWatermarkType:(NSUInteger)arg1;
- (NSUInteger)watermarkType;
@end

@interface ACCCreationPublishAction: NSObject
- (BOOL)is_open_hd;
- (void)setIs_open_hd:(BOOL)arg1;
- (BOOL)is_have_hd;
- (void)setIs_have_hd:(BOOL)arg1;
@end

@interface AWEMaskInfoModel
- (BOOL)showMask;
- (void)setShowMask:(BOOL)arg1;
@end

@interface UIView (RCTViewUnmounting)
@property(retain, nonatomic) UIViewController *yy_viewController;
@end
@interface AWECommentPanelCell: UITableView
- (void)onLikeAction:(id)arg1;
- (void)onDislikeAction:(id)arg1;
@end

@interface AWECommentPanelBaseCell: UITableViewCell
@property (nonatomic, strong, readwrite) UIButton *translateButton;
- (BOOL)shouldShowTranslateButton;
- (BOOL)shouldAddTranslateLabel;
- (BOOL)shouldShowCommentTranslationLabel;
@end
@interface TikTokFeedTabControl: UIView
@end

@interface AWEFeedVideoButton: UIButton
@property(copy, nonatomic, readwrite) NSString *imageNameString;
@end

@interface AWEURLModel : NSObject
@property(retain, nonatomic) NSArray* originURLList;
- (NSURL *)recommendUrl;
- (NSURL *)bestURLtoDownload;
- (NSString *)bestURLtoDownloadFormat;
@end

@interface AWEVideoModel : NSObject
@property(readonly, nonatomic) AWEURLModel *playURL;
@property(readonly, nonatomic) AWEURLModel *downloadURL;
@property(readonly, nonatomic) NSNumber *duration;
@end

@interface AWEMusicModel : NSObject
@property(readonly, nonatomic) AWEURLModel *playURL;
@end

@interface AWEPhotoAlbumPhoto: NSObject
@property(readonly, nonatomic) AWEURLModel *originPhotoURL;
@end

@interface AWEPhotoAlbumModel: NSObject
@property(readonly, nonatomic) NSArray <AWEPhotoAlbumPhoto *> *photos;
@end

@interface AWEAwemeStatisticsModel: NSObject
@property (nonatomic, strong, readwrite) NSNumber *diggCount;
@property (nonatomic, strong, readwrite) NSNumber *commentCount;
@property (nonatomic, strong, readwrite) NSNumber *shareCount;
@property (nonatomic, strong, readwrite) NSNumber *playCount;
@property (nonatomic, strong, readwrite) NSNumber *collectCount;
@end

@interface TUXLabel: UILabel
@end

@interface AWEUserModel: NSObject
@property(nonatomic, copy, readwrite) NSString *bioUrl;
@property(nonatomic, copy, readwrite) NSString *nickname;
@property(nonatomic, copy, readwrite) NSString *signature;
@property(nonatomic, copy, readwrite) NSString *socialName;
@property (nonatomic, strong, readwrite) NSNumber *visibleVideosCount;
@property (nonatomic, copy, readonly) NSString *userID;
- (BOOL)infinitokIsSignedInUser;
@end

@interface AWEUser : NSObject
+ (id)currentUser;
@end

@interface AWEAwemeModel : NSObject
@property(nonatomic) BOOL isAds;
@property(retain, nonatomic) AWEVideoModel *video;
@property(retain, nonatomic) id music;
@property (nonatomic, copy, readwrite) NSString *itemID;
@property(retain, nonatomic) AWEPhotoAlbumModel *photoAlbum;
@property(nonatomic) NSString *music_songName;
@property(nonatomic) NSString *music_artistName;
@property(nonatomic, strong, readwrite) AWEAwemeModel *currentPlayingStory;
@property (nonatomic, copy, readwrite) NSString *region;
@property (nonatomic, strong, readwrite) AWEAwemeStatisticsModel *statistics;
@property (nonatomic, strong, readwrite) NSNumber *createTime;
@property (nonatomic, strong, readwrite) AWEUserModel *author;
@property (nonatomic, assign, readwrite) BOOL isUserRecommendBigCard;
@property (nonatomic, assign, readwrite) NSInteger aigcLabelType;
+ (id)liveStreamURLJSONTransformer;
+ (id)relatedLiveJSONTransformer;
+ (id)rawModelFromLiveRoomModel:(id)arg1;
+ (id)aweLiveRoom_subModelPropertyKey;
- (void)live_callInitWithDictyCategoryMethod:(id)arg1;
@end

@interface AWEUserWorkCollectionViewCell: UICollectionView
@property (nonatomic, strong, readwrite) AWEAwemeModel *model;
- (NSString *)formattedNumber:(NSInteger)number;
- (NSString *)formattedDateStringFromTimestamp:(NSTimeInterval)timestamp;
- (id)contentView;
@end

@interface TTKProfileOtherViewController :UIViewController
@property (nonatomic, strong, readwrite) AWEUserModel *user;
@end

@interface AWESettingItemModel: NSObject
@property(nonatomic, copy, readwrite) NSString *identifier;
@property(nonatomic, copy, readwrite) NSString *title;
@property(nonatomic, copy, readwrite) NSString *detail;
@property(nonatomic, strong, readwrite) UIImage *iconImage;
@property(nonatomic, assign, readwrite) NSUInteger type;
- (instancetype)initWithIdentifier:(NSString *)identifier;
@end

@interface TTKSettingsBaseCellPlugin: NSObject
@property(nonatomic, weak, readwrite) id context;
@property(nonatomic, strong, readwrite) AWESettingItemModel *itemModel;
- (instancetype)initWithPluginContext:(id)context;
@end

@interface AWEBaseListSectionViewModel: NSObject
@property(nonatomic, copy, readwrite) NSArray *modelsArray;
- (void)insertModel:(id)model atIndex:(NSInteger)index animated:(bool)animated;
@end

@interface AWESettingsNormalSectionViewModel: AWEBaseListSectionViewModel
@property(nonatomic, weak, readwrite) id context;
@property(nonatomic, copy, readwrite) NSString *sectionHeaderTitle;
@property(nonatomic, copy, readwrite) NSString *sectionIdentifier;
- (void)addInfinitokSettingsRowIfNeeded;
@end

@interface AWEBaseListViewModel: NSObject
- (NSArray *)sectionViewModelsArray;
@end

@interface AWEPluginBaseViewModel: AWEBaseListViewModel
@end

@interface AWESettingsBaseViewModel: AWEPluginBaseViewModel
@end

@interface TTKSettingsViewModel: AWESettingsBaseViewModel
@end

@interface TIKTOKProfileHeaderViewController: UIViewController
@property(nonatomic, strong) AWEUserModel *user;
@end

@interface TIKTOKProfileHeaderView: UIView
- (void)addHandleLongPress;
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
@end

@interface AWEProfileImagePreviewView: UIView
@property(strong, nonatomic, readwrite) UIImageView *avatar;
- (void)addHandleLongPress;
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
@end

@interface AWEAwemeBaseViewController: UIViewController
@property(nonatomic, strong, readwrite) AWEAwemeModel *model;
@property (nonatomic, copy, readwrite) NSString *referString;
@property (nonatomic) id interactionController;
@end

@interface TTKFeedInteractionContainerElement: NSObject
- (void)hideAllElements:(BOOL)hide exceptArray:(id)array;
@end

@interface TTKFeedInteractionMainContainerElement: TTKFeedInteractionContainerElement
@end

@interface TTKFeedInteractionLegacyMainContainerElement: TTKFeedInteractionMainContainerElement
@end

@interface AWEPlayPhotoAlbumViewController: UIViewController
@property(nonatomic, strong, readwrite) AWEAwemeModel *model;
- (NSIndexPath *)currentIndexPath;
@end

@interface TTKPhotoAlbumFeedCellController: AWEAwemeBaseViewController
{
    AWEPlayPhotoAlbumViewController *_photoAlbumController;
}
@end

@interface TTKPhotoAlbumDetailCellController: AWEAwemeBaseViewController
{
    AWEPlayPhotoAlbumViewController *_photoAlbumController;
}
@end

@interface AWEFeedCellViewController: AWEAwemeBaseViewController;
@property (nonatomic, strong, readwrite) AWEAwemeModel *model;
- (NSInteger)indexPath;
@end

@interface AWEAwemeDetailCellViewController: AWEAwemeBaseViewController
@end

@interface AWEFeedViewTemplateCell: UITableViewCell
@property(nonatomic, strong, readwrite) UIViewController *viewController;
@property(nonatomic, strong, readwrite) UIViewController *parentVC;
@property(nonatomic, assign) BOOL elementsHidden;
@property (nonatomic, strong) JGProgressHUD *hud;
@property (nonatomic, retain) NSString *fileextension;
@property (nonatomic, retain) UIProgressView *progressView;
@property (nonatomic, assign) BOOL isVideoDownload;
@property (nonatomic, retain) NSString *pendingVideoFilename;
@property (nonatomic, retain) NSArray *pendingPhotoSourceURLs;
- (void)addHandleLongPress;
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
- (void)addHideElementButton;
- (void)hideElementButtonHandler:(UIButton *)sender;
- (void)addDownloadButton;
- (void) downloadButtonHandler:(UIButton *)sender;
- (void)downloadVideo:(AWEAwemeBaseViewController *)rootVC;
- (void)downloadMusic:(AWEAwemeBaseViewController *)rootVC;
- (void)copyMusic:(AWEAwemeBaseViewController *)rootVC;
- (void)copyVideo:(AWEAwemeBaseViewController *)rootVC;
- (void)downloadHDVideo:(AWEAwemeBaseViewController *)rootVC;
- (void)copyDecription:(AWEAwemeBaseViewController *)rootVC;
- (void)downloadPhotos:(AWEAwemeBaseViewController *)rootVC photoIndex:(unsigned long)index;
- (void)downloadPhotos:(AWEAwemeBaseViewController *)rootVC;
- (void)tapDownloadVideo;
- (void)addRegionBadgeWithModel:(id)model;
- (void)applyGlobalHideStateIfNeeded;
- (void)setElementsHiddenState:(BOOL)hidden sender:(UIButton *)sender;
@end
@interface AWEFeedViewTemplateCell () <BHDownloadDelegate, BHMultipleDownloadDelegate>
@end

@interface AWEFeedViewCell: AWEFeedViewTemplateCell
@end

@interface AWEAwemeDetailTableViewCell: UITableViewCell
@property(nonatomic, strong, readwrite) UIViewController *viewController;
@property(nonatomic, strong, readwrite) UIViewController *parentVC;
@property(nonatomic, assign) BOOL elementsHidden;
@property (nonatomic, strong) JGProgressHUD *hud;
@property (nonatomic, retain) NSString *fileextension;
@property (nonatomic, retain) UIProgressView *progressView;
@property (nonatomic, assign) BOOL isVideoDownload;
@property (nonatomic, retain) NSString *pendingVideoFilename;
@property (nonatomic, retain) NSArray *pendingPhotoSourceURLs;
- (void)addHandleLongPress;
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
- (void)addHideElementButton;
- (void)hideElementButtonHandler:(UIButton *)sender;
- (void)addDownloadButton;
- (void) downloadButtonHandler:(UIButton *)sender;
- (void)downloadVideo:(AWEAwemeBaseViewController *)rootVC;
- (void)downloadHDVideo:(AWEAwemeBaseViewController *)rootVC;
- (void)downloadMusic:(AWEAwemeBaseViewController *)rootVC;
- (void)copyMusic:(AWEAwemeBaseViewController *)rootVC;
- (void)copyVideo:(AWEAwemeBaseViewController *)rootVC;
- (void)copyDecription:(AWEAwemeBaseViewController *)rootVC;
- (void)downloadPhotos:(AWEAwemeBaseViewController *)rootVC photoIndex:(unsigned long)index;
- (void)downloadPhotos:(AWEAwemeBaseViewController *)rootVC;
- (void)showPostStats:(AWEAwemeBaseViewController *)rootVC;
- (void)applyGlobalHideStateIfNeeded;
- (void)setElementsHiddenState:(BOOL)hidden sender:(UIButton *)sender;
@end
@interface AWEAwemeDetailTableViewCell () <BHDownloadDelegate, BHMultipleDownloadDelegate>
@end

@interface TTKFeedPassthroughStackView: UIStackView
@end

@interface TUXActionSheetAction: NSObject
@property(nonatomic) NSString *title;
@property(nonatomic) NSString *subtitle;
@property(nonatomic) NSString *imageLabel;
@property(nonatomic) UIImage *image;
- (instancetype)initWithStyle:(NSUInteger)style title:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image imageLabel:(NSString *)imageLabel handler:(void (^ __nullable)(TUXActionSheetAction *action))handler;
@end

@interface TUXActionSheetController: UIViewController
@property(nonatomic, assign, readwrite) BOOL dismissOnDraggingDown;
@property(nonatomic, strong, readwrite) UITableView *tableView;
- (instancetype)initWithTitle:(NSString *)title;
- (void)addAction:(TUXActionSheetAction *)action;
@end

@interface AWEUIAlertView: UIView
+ (void)showAlertWithTitle:(NSString *)title description:(NSString *)description image:(UIImage *)image actionButtonTitle:(NSString *)actionButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle actionBlock:(void (^)(void))actionBlock cancelBlock:(void (^)(void))cancelBlock;
@end

@interface AWEToast: NSObject
+ (void)showSuccess:(NSString *)title;
@end

@interface AWEPlayVideoPlayerController : NSObject
@property(nonatomic) AWEAwemeBaseViewController *container;
- (void)setPlayerSeekTime:(double)arg1 completion:(id)arg2;
@end

@interface TTKSearchEntranceButton: UIButton
@end

@interface AWEPlayInteractionDescriptionElement : UIView
@end
@interface AWEPlayInteractionCommentElement : UIView
@end
@interface AWEPlayInteractionLikeElement : UIView
@end
@interface AWEPlayInteractionMusicElement : UIView
@end
@interface AWEPlayInteractionMusicInfoElement : UIView
@end
@interface AWEPlayInteractionShareElement : UIView
@end

@interface AWEPlayInteractionProgressManager : NSObject
- (BOOL)isShowStableProgressSlider;
- (BOOL)progressBarDraggable;
- (BOOL)progressBarVisible;
@end

@interface TUXLiquidGlassConfiguration : NSObject
- (BOOL)isInteractive;
@end

@interface AWEPlayInteractionAuthorElement : UIView
@property (nonatomic, strong) UIView *authorView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *stackView;
- (BOOL)shouldShowTimeStampLabel;
- (void)updateWithModel:(id)model;
@end

@interface AWEPlayInteractionWarningElementView: UIView
- (id)warningImage;
- (id)warningLabel;
@end
@interface AWEFeedContainerViewController: UIViewController
@property(nonatomic, strong, readwrite) TTKSearchEntranceButton *searchEntranceView;
@end

@interface AWENewFeedTableViewController : UIViewController
@property(nonatomic, weak, readwrite) UIViewController *tabContainerController;
@property (nonatomic, assign, readonly) AWEAwemeModel *currentAweme;
- (void)scrollToNextVideo;
- (void)pause;
- (void)stop;
@end

@interface TTKProfileBaseComponentModel : NSObject
@property (nonatomic, strong) NSString *componentID;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSArray *components;
@property (nonatomic, copy, readwrite) NSDictionary *bizData;
- (NSString *)formattedStringFromNumber:(NSNumber *)number;
- (NSNumber *)numberFromUserDefaultsForKey:(NSString *)key;
@end

@interface TTKProfileExternalUserRelationInfoFollowerComponent : NSObject
@property (nonatomic, strong, readwrite) UILabel *countLabel;
@end

@interface TTKProfileExternalUserRelationInfoFollowingComponent : NSObject
@property (nonatomic, strong, readwrite) UILabel *countLabel;
@end

@interface TTKProfileExternalUserRelationInfoLikeComponent : NSObject
@property (nonatomic, strong, readwrite) UILabel *countLabel;
@end

@interface TTKProfileViewsVisitor : NSObject
- (void)reportProfileView;
@end

@interface TTKStoryNetworkService : NSObject
+ (void)reportStoryViewedWithStoryID:(NSString *)storyID uid:(NSString *)uid completion:(id)completion;
+ (void)reportStoryViewedWithStoryID:(NSString *)storyID uid:(NSString *)uid unlocked:(BOOL)unlocked completion:(id)completion;
@end

@interface TIMMessageMarkAsReadOperator : NSObject
- (void)markAsRead:(id)arg1;
@end

@interface TTKFeedFYPBottomRightTakoEntranceComponent : NSObject
- (BOOL)shouldShowTakoEntranceWithAwemeModel:(id)model referString:(NSString *)referString playlistPreviousPage:(id)playlistPreviousPage;
- (BOOL)isTakoEntranceCurrentlyShown;
@end
@interface TTKFeedRightTakoElement : NSObject
- (BOOL)shouldShowTakoEntranceWithAwemeModel:(id)model referString:(NSString *)referString playlistPreviousPage:(id)playlistPreviousPage;
- (BOOL)isTakoEntranceCurrentlyShown;
@end

@interface TTKRichContentDetailViewController : UIViewController
@property (nonatomic, strong, readwrite) AWEAwemeModel *model;
@end

@interface TIMInputStatusManager : NSObject
- (void)sendInputStatusWithConversationID:(id)conversationID inputStatus:(NSInteger)inputStatus;
@end

@interface AWEIMMessageReadComponent : NSObject
- (void)p_markReadSyncToServerWithMessage:(id)message;
@end

@interface TIMOMessage : NSObject
@property (nonatomic, assign, readwrite) BOOL isRecalled;
@property (nonatomic, strong, readwrite) id content;
@end

@interface AWEIMMessageListViewController : UIViewController
- (void)willDeleteMessage:(id)message;
@end

@interface AWEIMConversationController : UIViewController
@end

@interface AWEFavoriteAwemeViewController : UIViewController
@end

@interface AWEFeedRootViewController : UIViewController
- (void)handleTabBarSelectedRefresh;
@end

@interface _TtC12TUXSwiftBase14TUXExperiments : NSObject
@end

@interface TTKMediaVideoPlayerController : NSObject
@property (nonatomic) AWEAwemeBaseViewController *container;
- (BOOL)loop;
- (void)setLoop:(BOOL)arg1;
@end

@interface UIKBBackdropView : UIView
@end

@interface TTKFeedRootViewController : UIViewController
- (void)handleTabBarSelectedRefresh;
@end

@interface AWESettingLoginOrSwitchCellPlugin : NSObject
- (void)didTapLogoutOneClickLogin;
- (void)didTapLogoutSettingItem;
@end

@interface AWEUserService : NSObject
- (BOOL)canShowThirdPartyPhoneBindingPopup;
@end

@interface TTKStoryMarkReadService : NSObject
- (void)markAsRead:(id)arg1;
@end

@interface TTKFeedInteractionLikeManager : NSObject
- (void)onLikeButtonClicked;
- (void)doubleTapLikeWithAnimation:(id)arg1;
@end

@interface TTKPersonalAdsPopup : NSObject
- (BOOL)canShow:(id)arg1 context:(id)arg2;
@end
@interface TTKPersonalAdsOptimizationPopup : NSObject
- (BOOL)canShow:(id)arg1 context:(id)arg2;
@end

@interface AWEIMChatRoomPictureDisplayViewController : UIViewController
@end

static BOOL is_iPad() {
    if ([(NSString *)[UIDevice currentDevice].model hasPrefix:@"iPad"]) {
        return YES;
    }
    return NO;
}

static UIViewController * _Nullable _topMostController(UIViewController * _Nonnull cont) {
    UIViewController *topController = cont;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if ([topController isKindOfClass:[UINavigationController class]]) {
        UIViewController *visible = ((UINavigationController *)topController).visibleViewController;
        if (visible) {
            topController = visible;
        }
    }
    return (topController != cont ? topController : nil);
}
static UIViewController * _Nonnull topMostController() {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *next = nil;
    while ((next = _topMostController(topController)) != nil) {
        topController = next;
    }
    return topController;
}
