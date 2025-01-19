// This file is used as workaround to get the label text from
// family acitivty applications and categories

import NaturalLanguage
import SwiftUI
import UIKit
import Vision

struct NLBoundingBox: Encodable {
  enum CodingKeys: String, CodingKey {
    case text
    case boundingBox
    case tag
  }
  
  let text: String
  let boundingBox: CGRect
  var tag: NLTag?
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(text, forKey: .text)
    try container.encode([
      "x": boundingBox.origin.x,
      "y": boundingBox.origin.y,
      "width": boundingBox.width,
      "height": boundingBox.height,
    ], forKey: .boundingBox)
    try container.encodeIfPresent(tag?.rawValue, forKey: .tag)
  }
  
  public var encoded: NSDictionary? {
    guard let jsonData = try? JSONEncoder().encode(self) else {
      return nil
    }
    return try? JSONSerialization.jsonObject(with: jsonData) as? NSDictionary
  }
}

extension CGRect: @retroactive Hashable {
  public func hash(into hasher: inout Hasher) {
    "\(self.origin.x),\(self.origin.y),\(self.width),\(self.height)".hash(into: &hasher)
  }
}

func detectNamedEntities(in image: UIImage, completion: @escaping ([NLBoundingBox]) -> Void) {
  guard let cgImage = image.cgImage else {
    completion([])
    return
  }
  
  let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
  
  let textRecognitionRequest = VNRecognizeTextRequest { request, _ in
    
    guard let observations = request.results as? [VNRecognizedTextObservation] else {
      completion([])
      return
    }
    
    var boundingBoxes: [NLBoundingBox] = []
    
    // Extract recognized text and bounding boxes for each word
    for observation in observations {
      for candidate in observation.topCandidates(1) {
        let text = candidate.string
        let words = text.split(separator: " ").map{ String($0) }
        var index = text.startIndex
        for word in words {
          if let range = text.range(of: word, range: index ..< text.endIndex),
             let boundingBox = try? candidate.boundingBox(for: range)?.boundingBox {
            boundingBoxes.append(NLBoundingBox(text: word, boundingBox: boundingBox))
            index = range.upperBound
          }
        }
      }
    }
    
    completion(boundingBoxes)
  }
  
  textRecognitionRequest.recognitionLevel = .fast
  
  // Perform the text recognition request
  do {
    try requestHandler.perform([textRecognitionRequest])
  } catch {
    print("Failed to perform text recognition: \(error)")
    completion([])
  }
}


