#import "AppDelegate+FirebaseDynamicLinksPlugin.h"
#import "FirebaseDynamicLinksPlugin.h"
#import <objc/runtime.h>


@implementation AppDelegate (FirebaseDynamicLinksPlugin)

// [START continueuseractivity]
- (BOOL)application:(UIApplication *)application
        continueUserActivity:(NSUserActivity *)userActivity
          restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    FirebaseDynamicLinksPlugin* dl = [self.viewController getCommandInstance:@"FirebaseDynamicLinks"];

    BOOL handled = [[FIRDynamicLinks dynamicLinks]
        handleUniversalLink:userActivity.webpageURL
        completion:^(FIRDynamicLink * _Nullable dynamicLink, NSError * _Nullable error) {
            if (dynamicLink) {
                [dl postDynamicLink:dynamicLink];
            }
        }];

    if (handled) {
        return YES;
    }

    return NO;
}
// [END continueuseractivity]



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *, id> *)options {
  return [self application:application
                   openURL:url
         sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  
  FirebaseDynamicLinksPlugin* dl = [self.viewController getCommandInstance:@"FirebaseDynamicLinks"];
  BOOL handled = [[FIRDynamicLinks dynamicLinks]
        handleUniversalLink:url
        completion:^(FIRDynamicLink * _Nullable dynamicLink, NSError * _Nullable error) {
            if (dynamicLink) {
                [dl postDynamicLink:dynamicLink];
            }
            else {
              FIRDynamicLink *dynamicLink2 = [[FIRDynamicLinks dynamicLinks] dynamicLinkFromCustomSchemeURL:url];
              if (dynamicLink2) {
                [dl postDynamicLink:dynamicLink2];
              }
            }
        }];

    if (handled) {
        return YES;
    }

    return NO;
}


@end
