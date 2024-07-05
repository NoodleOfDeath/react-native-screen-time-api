//
//  ReactNativeScreenTimeAPI.swift
//  ReactNativeScreenTimeAPI
//
//  Created by noodleofdeath on 2/16/24.
//

import DeviceActivity
import FamilyControls
import Foundation
import ManagedSettings

import SwiftUI

struct RNTFamilyActivityPickerView: View {
  @State var model = ScreenTimeAPI.shared

  let headerText: String
  let footerText: String

  init(activitySelection _: FamilyActivitySelection? = nil,
       headerText: String = "",
       footerText: String = "")
  {
    self.headerText = headerText
    self.footerText = footerText
  }

  var body: some View {
    FamilyActivityPicker(headerText: headerText,
                         footerText: footerText,
                         selection: $model.activitySelection)
  }
}

struct RNTFamilyActivityPickerModalView: View {
  @Environment(\.presentationMode) var presentationMode

  @State var activitySelection: FamilyActivitySelection

  let title: String
  let headerText: String
  let footerText: String
  let onDismiss: (_ selection: NSDictionary?) -> Void

  init(activitySelection: FamilyActivitySelection? = nil,
       title: String = "",
       headerText: String = "",
       footerText: String = "",
       onDismiss: @escaping (_ selection: NSDictionary?) -> Void)
  {
    _activitySelection = State(initialValue: activitySelection ?? ScreenTimeAPI.shared.activitySelection)
    self.title = title
    self.headerText = headerText
    self.footerText = footerText
    self.onDismiss = onDismiss
  }

  var cancelButton: some View {
    Button("Cancel") {
      presentationMode.wrappedValue.dismiss()
      onDismiss(nil)
    }
  }

  var doneButton: some View {
    Button("Done") {
      presentationMode.wrappedValue.dismiss()
      onDismiss(activitySelection.encoded)
    }
  }

  var body: some View {
    NavigationView {
      VStack {
        FamilyActivityPicker(headerText: headerText,
                             footerText: footerText,
                             selection: $activitySelection)
      }
      .navigationBarItems(leading: cancelButton, trailing: doneButton)
      .navigationTitle(title)
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

@objc(RNTFamilyActivityPickerViewFactory)
public class RNTFamilyActivityPickerViewFactory: NSObject {
  @objc public static func view() -> UIView {
    let view = RNTFamilyActivityPickerView()
    let vc = UIHostingController(rootView: view)
    return vc.view
  }
}

@objc(ScreenTimeAPI)
public class ScreenTimeAPI: NSObject {
  public static let shared = ScreenTimeAPI()

  lazy var store: ManagedSettingsStore = {
    let store = ManagedSettingsStore()
    store.application.denyAppRemoval = true
    return store
  }()

  var activitySelection = FamilyActivitySelection() {
    willSet(value) {
        // We whitelist by default, TODO: possibility to change blacklist/whitelist behavior
        store.shield.applicationCategories = .all(except: value.applicationTokens)
        store.shield.webDomainCategories = .all(except: value.webDomainTokens)
    }
  }
    
  @objc
  static func requiresMainQueueSetup() -> Bool { return true }

  @objc
  public func getAuthorizationStatus(_ resolve: @escaping RCTPromiseResolveBlock,
                                     rejecter reject: @escaping RCTPromiseRejectBlock)
  {
    let _ = AuthorizationCenter.shared.$authorizationStatus.sink {
      switch $0 {
      case .notDetermined:
        resolve("notDetermined")
      case .denied:
        resolve("denied")
      case .approved:
        resolve("approved")
      @unknown default:
        reject("0", "Unhandled Authorization Status Type", nil)
      }
    }
  }

  @objc
  public func getStore(_ resolve: RCTPromiseResolveBlock? = nil,
                       rejecter _: RCTPromiseRejectBlock? = nil)
  {
    resolve?(store.encoded)
  }
    
    @objc
    public func setWebsitesWhitelist(_ websites: String,
                                     resolver resolve: RCTPromiseResolveBlock? = nil,
                                     rejecter reject: RCTPromiseRejectBlock? = nil)
    {
        /*let domains = Set(websites.map { website in
            WebDomain(domain: website as! String)
        })*/
        let domains: Set<WebDomain> = [WebDomain(domain: websites)]
        
        store.webContent.blockedByFilter = .all(except: domains)
        
        resolve?(nil)
    }

  @objc
  public func getActivitySelection(_ resolve: RCTPromiseResolveBlock? = nil,
                                   rejecter _: RCTPromiseRejectBlock? = nil)
  {
    resolve?(activitySelection.encoded)
  }

  @objc
  public func setActivitySelection(_ selection: NSDictionary,
                                   resolver resolve: RCTPromiseResolveBlock? = nil,
                                   rejecter reject: RCTPromiseRejectBlock? = nil)
  {
    if let selection = FamilyActivitySelection.from(selection) {
      activitySelection = selection
      resolve?(nil)
      return
    }
    reject?("0", "unable to parse selection", nil)
  }

  @objc
  public func clearActivitySelection() {
    activitySelection = FamilyActivitySelection()
  }

  @objc
  public func requestAuthorization(_ memberName: String,
                                   resolver resolve: RCTPromiseResolveBlock? = nil,
                                   rejecter reject: RCTPromiseRejectBlock? = nil)
  {
    guard let member: FamilyControlsMember =
      memberName == "child" ? .child :
      memberName == "individual" ? .individual : nil
    else {
      reject?("0", "invalid member type", nil)
      return
    }
    Task {
      do {
        try await AuthorizationCenter.shared.requestAuthorization(for: member)
        resolve?(nil)
      } catch {
        reject?("0", error.localizedDescription, nil)
        print(error)
      }
    }
  }

  @objc
  public func revokeAuthorization(_ resolve: RCTPromiseResolveBlock? = nil,
                                  rejecter reject: RCTPromiseRejectBlock? = nil)
  {
    AuthorizationCenter.shared.revokeAuthorization {
      do {
        try $0.get()
        resolve?(nil)
      } catch {
        reject?("0", error.localizedDescription, nil)
      }
    }
  }

  @objc
  public func denyAppRemoval() {
    store.application.denyAppRemoval = true
  }

  @objc
  public func allowAppRemoval() {
    store.application.denyAppRemoval = false
  }

  @objc
  public func denyAppInstallation() {
    store.application.denyAppInstallation = true
  }

  @objc
  public func allowAppInstallation() {
    store.application.denyAppInstallation = false
  }

  @objc
  public func initiateMonitoring(_ startTimestamp: String = "00:00",
                                 end endTimestamp: String = "23:59",
                                 resolver resolve: RCTPromiseResolveBlock? = nil,
                                 rejecter reject: RCTPromiseRejectBlock? = nil)
  {
    do {
      guard let start = DateFormatter().date(from: startTimestamp),
            let end = DateFormatter().date(from: endTimestamp)
      else {
        reject?("0", "invalid date provided", nil)
        return
      }
      let scheduleStart = Calendar.current.dateComponents([.hour, .minute], from: start)
      let scheduleEnd = Calendar.current.dateComponents([.hour, .minute], from: end)
      let schedule = DeviceActivitySchedule(intervalStart: scheduleStart,
                                            intervalEnd: scheduleEnd,
                                            repeats: true,
                                            warningTime: nil)
      let center = DeviceActivityCenter()
      try center.startMonitoring(.daily, during: schedule)
      resolve?(nil)
    } catch {
      reject?("0", error.localizedDescription, nil)
      print("Could not start monitoring \(error)")
    }
  }

  @objc
  public func displayFamilyActivityPicker(_ options: NSDictionary,
                                          resolver resolve: RCTPromiseResolveBlock? = nil,
                                          rejecter reject: RCTPromiseRejectBlock? = nil)
  {
    let activitySelection = FamilyActivitySelection.from(options["activitySelection"] as? NSDictionary)
    let title = options["title"] as? String ?? ""
    let headerText = options["headerText"] as? String ?? ""
    let footerText = options["footerText"] as? String ?? ""
    DispatchQueue.main.async {
      let view = RNTFamilyActivityPickerModalView(activitySelection: activitySelection,
                                                  title: title,
                                                  headerText: headerText,
                                                  footerText: footerText)
      {
        resolve?($0)
      }
      let vc = UIHostingController(rootView: view)
      guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else {
        reject?("0", "could not find root view controller", nil)
        return
      }
      rootViewController.present(vc, animated: true)
    }
  }
}

extension DeviceActivityName {
  static let daily = Self("daily")
}
