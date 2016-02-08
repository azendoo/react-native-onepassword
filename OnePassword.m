#import "OnePassword.h"
#import "RCTUtils.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "OnePasswordExtension.h"
#import "RCTUIManager.h"

@implementation OnePassword
@synthesize bridge = _bridge;
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(isSupported: (RCTResponseSenderBlock)callback)
{
    if ([[OnePasswordExtension sharedExtension] isAppExtensionAvailable]) {
        callback(@[[NSNull null], @true]);
    }
    else {
        callback(@[RCTMakeError(@"OnePassword is not supported.", nil, nil)]);
        return;
    }
}

RCT_EXPORT_METHOD(findLogin: (NSString *)url
                  tag: (nonnull NSNumber *) tag
                  callback: (RCTResponseSenderBlock)callback)
{
    UIViewController *controller = RCTKeyWindow().rootViewController;
    dispatch_async(self.bridge.uiManager.methodQueue, ^{
        [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
            UIView *sender = viewRegistry[tag];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[OnePasswordExtension sharedExtension] findLoginForURLString:url
                  forViewController:controller sender:sender completion:^(NSDictionary *loginDictionary, NSError *error) {
                      if (loginDictionary.count == 0) {
                          callback(@[RCTMakeError(@"Error while getting login credentials.", nil, nil)]);
                          return;
                      }

                      callback(@[[NSNull null], @{
                                     @"username": loginDictionary[AppExtensionUsernameKey],
                                     @"password": loginDictionary[AppExtensionPasswordKey]
                                     }]);
                  }];
            });
        }];
    });
}

@end
