//
//  FamilyPickerModalView.swift
//  ReactNativeScreenTimeAPI
//
//  Created by thom on 8/8/24.
//

import Foundation
import FamilyControls

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
