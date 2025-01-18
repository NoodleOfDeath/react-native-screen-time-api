//
//  RNTDeviceActivityReportView.swift
//  ReactNativeScreenTimeAPI
//
//  Created by thom on 8/8/24.
//

import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity

import SwiftUI

struct RNTDeviceActivityReportView: View {
  
  let selectedApps: Set<ApplicationToken>
  let selectedCategories: Set<ActivityCategoryToken>
  let selectedWebDomains: Set<WebDomainToken>
  
  @State private var context: DeviceActivityReport.Context = .base
  @State private var filter = DeviceActivityFilter(
    segment: .daily(
      during: Calendar.current.dateInterval(
        of: .weekOfYear, for: .now
      )!
    ),
    users: .children,
    devices: .init([.iPhone, .iPad]),
    applications: selectedApps,
    categories: selectedCategories,
    webDomains: selectedWebDomains
  )
  
  public var body: some View {
    VStack {
      DeviceActivityReport(context, filter: filter)
      
      // A picker used to change the report's context.
      Picker(selection: $context, label: Text("Context: ")) {
        Text("Base")
          .tag(DeviceActivityReport.Context.base)
      }
      
      // A picker used to change the filter's segment interval.
      Picker(
        selection: $filter.segmentInterval,
        label: Text("Segment Interval: ")
      ) {
        Text("Hourly")
          .tag(DeviceActivityFilter.SegmentInterval.hourly())
        Text("Daily")
          .tag(DeviceActivityFilter.SegmentInterval.daily(
            during: Calendar.current.dateInterval(
              of: .weekOfYear, for: .now
            )!
          ))
        Text("Weekly")
          .tag(DeviceActivityFilter.SegmentInterval.weekly(
            during: Calendar.current.dateInterval(
              of: .month, for: .now
            )!
          ))
      }
      
    }
  }
}

extension DeviceActivityReport.Context {
  static let base = Self("base")
}

@objc(RNTDeviceActivityReportViewFactory)
public class RNTDeviceActivityReportViewFactory: NSObject {
  
  @objc public static func view(_ selection: NSDictionary) throws -> UIView {
    guard let selection = FamilyActivitySelection.from(selection) else {
      throw RNTScreenTimeError.unableToDecodeFamilySelectionObject("Unable to decode family selection object")
    }
    let view = RNTDeviceActivityReportView(selectedApps: selection.applicationTokens,
                                           selectedCategories: selection.categoryTokens,
                                           selectedWebDomains: selection.webDomainTokens)
    let vc = UIHostingController(rootView: view)
    return vc.view
  }
  
}

