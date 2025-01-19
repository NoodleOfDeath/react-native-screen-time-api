//
//  AppDelegate.swift
//  DrunkMode
//
//  Created by thom on 4/13/24.
//

import Foundation
import UserNotifications

@UIApplicationMain
class AppDelegate: RCTAppDelegate, UNUserNotificationCenterDelegate {
  
  public override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    self.moduleName = "ScreenTimeExample";
    // You can add your custom initial props in the dictionary below.
    // They will be passed down to the ViewController used by React Native.
    self.initialProps = [:]
    return super.application(application, didFinishLaunchingWithOptions: launchOptions);
  }
  
  @objc(bundleURL)
  public override func bundleURL() -> URL? {
#if DEBUG
    RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
#else
    Bundle.main.url(forResource: "main", withExtension: "jsbundle")
#endif
  }
  
  @objc(sourceURLForBridge:)
  public func sourceURLForBridge(_ bridge: RCTBridge) -> URL? {
    bundleURL()
  }

}
