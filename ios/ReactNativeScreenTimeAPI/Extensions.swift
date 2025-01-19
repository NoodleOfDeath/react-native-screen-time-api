//
//  Extensions.swift
//  ReactNativeScreenTimeAPI
//
//  Created by thom on 1/18/25.
//

import Foundation
import FamilyControls
import ManagedSettings
import SwiftUI
import UIKit

extension View {
  
  func toImage(size: CGSize? = nil) -> UIImage? {
    DispatchQueue.main.sync {
      let controller = UIHostingController(rootView: self)
      guard let view = controller.view else {
        return nil
      }
      
      view.bounds = CGRect(origin: .zero, size: size ?? UIScreen.main.bounds.size)
      
      let imageRenderer = UIGraphicsImageRenderer(bounds: view.bounds)
      if let format = imageRenderer.format as? UIGraphicsImageRendererFormat {
        format.opaque = true
      }
      let image = imageRenderer.image { context in
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
      }
      return image
    }
  }
  
}

extension UIImage {
  
  func detectText(completion: @escaping ((String) -> Void)) {
    detectNamedEntities(in: self) { boxes in
      completion(boxes.map { $0.text }.reduce("") { prev, box in prev + " " + box}.trimmingCharacters(in: .whitespaces))
    }
  }
  
}

extension ApplicationToken {
  
  public static func toImage(token: Any, size: CGSize? = nil) -> UIImage? {
    let tokenDict = token as? NSDictionary ?? [ "data": token as? String ?? "" ]
    guard let data = try? JSONSerialization.data(withJSONObject: tokenDict, options: []),
          let token = try? JSONDecoder().decode(ApplicationToken.self, from: data) else {
      return nil
    }
    return Label(token).labelStyle(.titleOnly).toImage(size: size)
  }
  
}

extension ActivityCategoryToken {
  
  public static func toImage(token: Any, size: CGSize? = nil) -> UIImage? {
    let tokenDict = token as? NSDictionary ?? [ "data": token as? String ?? "" ]
    guard let data = try? JSONSerialization.data(withJSONObject: tokenDict, options: []),
          let token = try? JSONDecoder().decode(ActivityCategoryToken.self, from: data) else {
      return nil
    }
    return Label(token).labelStyle(.titleOnly).toImage(size: size)
  }
  
}
