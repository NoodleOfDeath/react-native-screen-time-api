//
//  ReactNativeScreenTimeAPI.swift
//  ReactNativeScreenTimeAPI
//
//  Created by noodleofdeath on 2/16/24.
//

import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettings

import SwiftUI

struct RNTFamilyActivityPickerView: View {
  
  @State var model = ScreenTimeAPI.shared;
  
  let headerText: String
  let footerText: String
  
  init(activitySelection: FamilyActivitySelection? = nil,
       headerText: String = "",
       footerText: String = "") {
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
       onDismiss: @escaping (_ selection: NSDictionary?) -> Void) {
    _activitySelection = State(initialValue: activitySelection ?? ScreenTimeAPI.shared.activitySelection)
    self.title = title
    self.headerText = headerText
    self.footerText = footerText
    self.onDismiss = onDismiss
  }
  
  var encodedSelection: NSDictionary? {
    guard let jsonData = try? JSONEncoder().encode(activitySelection) else {
      return nil
    }
    return try? JSONSerialization.jsonObject(with: jsonData) as? NSDictionary
  }
  
  var cancelButton: some View {
    Button("cancel") {
      presentationMode.wrappedValue.dismiss()
      onDismiss(nil)
    }
  }
  
  var doneButton: some View {
    Button("done") {
      presentationMode.wrappedValue.dismiss()
      onDismiss(encodedSelection)
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

@objc(RNTFamilyActivityPickerViewFactory) class RNTFamilyActivityPickerViewFactory: NSObject {
  
  @objc public static func view() -> UIView {
    let view = RNTFamilyActivityPickerView()
    let vc = UIHostingController(rootView: view)
    return vc.view
  }
  
}

@objc(ScreenTimeAPI) class ScreenTimeAPI: NSObject {
  
  static let shared = ScreenTimeAPI()
  
  lazy var store: ManagedSettingsStore = {
    let store = ManagedSettingsStore()
    store.application.denyAppRemoval = true
    return store
  }()
  
  var activitySelection = FamilyActivitySelection() {
    didSet(value) {
      store.shield.applications = value.applicationTokens.isEmpty ? nil : value.applicationTokens
      store.shield.applicationCategories =
      ShieldSettings.ActivityCategoryPolicy.specific(value.categoryTokens, except: Set())
      store.shield.webDomains = value.webDomainTokens
      store.shield.webDomainCategories =
      ShieldSettings.ActivityCategoryPolicy.specific(value.categoryTokens, except: Set())
    }
  }
  
  @objc static func requiresMainQueueSetup() -> Bool { return true }
  
  @objc public func requestAuthorization(_ memberName: String,
                                         resolver resolve: @escaping RCTPromiseResolveBlock,
                                         rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
    guard let member: FamilyControlsMember =
            memberName == "child" ? .child :
              memberName == "individual" ? .individual : nil
    else {
      reject("0", "invalid member type", nil)
      return
    }
    Task {
      do {
        try await AuthorizationCenter.shared.requestAuthorization(for: member)
        resolve(nil)
      } catch {
        reject("0", error.localizedDescription, nil)
        print(error)
      }
    }
  }
  
  @objc public func getAuthorizationStatus(_ resolve: @escaping RCTPromiseResolveBlock,
                                           rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
    let _ = AuthorizationCenter.shared.$authorizationStatus.sink() {
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
  
  @objc public func initiateMonitoring(_ startTimestamp: String = "00:00",
                                       end endTimestamp: String = "23:59",
                                       resolver resolve: RCTPromiseResolveBlock,
                                       rejecter reject: RCTPromiseRejectBlock) -> Void {
    do {
      guard let start = DateFormatter().date(from: startTimestamp),
            let end = DateFormatter().date(from: endTimestamp)
      else {
        reject("0", "invalid date provided", nil)
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
      resolve(nil)
    }
    catch {
      reject("0", error.localizedDescription, nil)
      print ("Could not start monitoring \(error)")
    }
  }
  
  @objc public func displayFamilyActivityPicker(_ options: NSDictionary,
                                                resolver resolve: @escaping RCTPromiseResolveBlock,
                                                rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
    let activitySelection = FamilyActivitySelection.from(options["activitySelection"] as? NSDictionary)
    let title = options["title"] as? String ?? ""
    let headerText = options["headerText"] as? String ?? ""
    let footerText = options["footerText"] as? String ?? ""
    DispatchQueue.main.async {
      let view = RNTFamilyActivityPickerModalView(activitySelection: activitySelection,
                                                  title: title,
                                                  headerText: headerText,
                                                  footerText: footerText) {
        resolve($0)
      }
      let vc = UIHostingController(rootView: view)
      guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else {
        reject("0", "could not find root view controller", nil)
        return
      }
      rootViewController.present(vc, animated: true)
    }
  }
  
  @objc public func getStore(_ resolve: @escaping RCTPromiseResolveBlock,
                             rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
    resolve(store.encoded)
  }
  
  @objc public func getActivitySelection(_ resolve: @escaping RCTPromiseResolveBlock,
                                         rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
    resolve(activitySelection.encoded)
  }
  
  @objc public func setActivitySelection(_ selection: NSDictionary,
                                         resolver resolve: RCTPromiseResolveBlock,
                                         rejecter reject: RCTPromiseRejectBlock) -> Void {
    if let selection = FamilyActivitySelection.from(selection) {
      activitySelection = selection
      resolve(nil)
      return
    }
    reject("0", "unable to parse selection", nil)
  }
  
  @objc public func clearActivitySelection() -> Void {
    activitySelection = FamilyActivitySelection()
  }
  
}

extension DeviceActivityName {
  static let daily = Self("daily")
}
