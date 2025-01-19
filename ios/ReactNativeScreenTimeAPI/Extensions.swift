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
  func asUIImage(size: CGSize? = nil) -> UIImage {
    let controller = UIHostingController(rootView: self)
    let view = controller.view
    
    // Set the desired size
    view?.bounds = CGRect(origin: .zero, size: size ?? UIScreen.main.bounds.size)
    view?.backgroundColor = .clear
    
    // Render the view to an image
    let renderer = UIGraphicsImageRenderer(size: size ?? UIScreen.main.bounds.size)
    return renderer.image { context in
      view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
    }
  }
}

extension ApplicationToken {
  
  public static func asImage(token: NSObject, size: CGSize? = nil) -> UIImage? {
    let tokenDict = token as? NSDictionary ?? [ "data": token as? String ?? "" ]
    guard let data = try? JSONSerialization.data(withJSONObject: tokenDict, options: []),
          let token = try? JSONDecoder().decode(ApplicationToken.self, from: data) else {
      return nil
    }
    return Label(token).asUIImage(size: size)
  }
  
}

extension ActivityCategoryToken {
  
  public static func asImage(token: NSObject, size: CGSize? = nil) -> UIImage? {
    let tokenDict = token as? NSDictionary ?? [ "data": token as? String ?? "" ]
    guard let data = try? JSONSerialization.data(withJSONObject: tokenDict, options: []),
          let token = try? JSONDecoder().decode(ActivityCategoryToken.self, from: data) else {
      return nil
    }
    return Label(token).asUIImage(size: size)
  }
  
}
