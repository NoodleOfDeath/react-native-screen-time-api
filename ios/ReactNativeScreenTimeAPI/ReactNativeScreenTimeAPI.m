//
//  ReactNativeScreenTimeAPI.m
//  ReactNativeScreenTimeAPI
//
//  Created by noodleofdeath on 2/18/24.
//

#import <Foundation/Foundation.h>

#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(ScreenTimeAPI, NSObject)
RCT_EXTERN_METHOD(requestAuthorization: (NSString *) memberName
                  resolver: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(revokeAuthorization: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(getAuthorizationStatus: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(getStore: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(getActivitySelection: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(setActivitySelection: (NSDictionary *) selection
                  resolver: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(clearActivitySelection)
RCT_EXTERN_METHOD(denyAppRemoval)
RCT_EXTERN_METHOD(allowAppRemoval)
RCT_EXTERN_METHOD(denyAppInstallation)
RCT_EXTERN_METHOD(allowAppInstallation)
RCT_EXTERN_METHOD(displayFamilyActivityPicker: (NSDictionary *) options
                  resolver: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(initializeMonitoring: (NSString *) start
                  end: (NSString *) end
                  resolver: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject)
@end

@interface RNTFamilyActivityPickerViewFactory: NSObject
+ (UIView *)view;
@end

@interface RNTFamilyActivityPickerViewManager: RCTViewManager
@end

@implementation RNTFamilyActivityPickerViewManager

RCT_EXPORT_MODULE(RNTFamilyActivityPickerView)

- (UIView *)view
{
  return [RNTFamilyActivityPickerViewFactory view];
}

@end
