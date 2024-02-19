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
  
  var body: some View {
    FamilyActivityPicker(headerText: "Test", selection: $model.activitySelection)
  }
  
}

struct RNTFamilyActivityPickerModalView: View {
  @Environment(\.presentationMode) var presentationMode
  
  @State var model = ScreenTimeAPI.shared;
  
  @State var activitySelection: FamilyActivitySelection
  
  let title: String
  
  init(title: String) {
    _activitySelection = State(initialValue: ScreenTimeAPI.shared.activitySelection)
    self.title = title
  }
  
  var cancelButton: some View {
    Button("cancel") { presentationMode.wrappedValue.dismiss() }
  }
  
  var doneButton: some View {
    Button("done") {
      model.activitySelection = activitySelection
      presentationMode.wrappedValue.dismiss()
    }
  }
  
  var body: some View {
    NavigationView {
      VStack {
        FamilyActivityPicker(headerText: "Test", selection: $activitySelection)
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
      let applications = value.applicationTokens
      let categories = value.categoryTokens
      let webCategories = value.webDomainTokens
      store.shield.applications = applications.isEmpty ? nil : applications
      store.shield.applicationCategories =
      ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
      store.shield.webDomains = webCategories
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
  
  @objc public func displayFamilyActivityPicker(_ resolve: @escaping RCTPromiseResolveBlock,
                                                rejecter reject: @escaping RCTPromiseRejectBlock) -> Void {
    DispatchQueue.main.async {
      let view = RNTFamilyActivityPickerModalView(title: "Test")
      let vc = UIHostingController(rootView: view)
      guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else {
        reject("0", "could not find root view controller", nil)
        return
      }
      rootViewController.present(vc, animated: true) {
        resolve(nil)
      }
    }
  }
  
}

extension DeviceActivityName {
  static let daily = Self("daily")
}
