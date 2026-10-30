//
//  ScreenTimeAPI+iOS26.swift
//  ReactNativeScreenTimeAPI
//
//  Screen Time APIs introduced in iOS 26.x, available on iOS 26.4+ / 27 devices.
//  Every method checks availability at runtime and rejects with the code
//  "unavailable" on older systems, so callers can feature-detect with
//  `getCapabilities()` before using them.
//

import DeviceActivity
import FamilyControls
import Foundation
import ManagedSettings

extension ScreenTimeAPI {

  // capabilities

  @objc
  public func getCapabilities(_ resolve: RCTPromiseResolveBlock? = nil,
                              rejecter _: RCTPromiseRejectBlock? = nil)
  {
    let version = ProcessInfo.processInfo.operatingSystemVersion
    var capabilities: [String: Any] = [
      "systemVersion": "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)",
      "effectiveDenyExplicitContent": false,
      "familyActivityData": false,
      "deviceActivityData": false,
      "storeManagement": false,
      "tokenRefresh": false,
    ]
    if #available(iOS 26.0, *) {
      capabilities["effectiveDenyExplicitContent"] = true
    }
    if #available(iOS 26.4, *) {
      capabilities["familyActivityData"] = true
      capabilities["deviceActivityData"] = true
    }
    if #available(iOS 26.5, *) {
      capabilities["storeManagement"] = true
      capabilities["tokenRefresh"] = true
    }
    resolve?(capabilities)
  }

  // effective settings (iOS 26.0)

  @objc
  public func getEffectiveDenyExplicitContent(_ resolve: @escaping RCTPromiseResolveBlock,
                                              rejecter reject: @escaping RCTPromiseRejectBlock)
  {
    guard #available(iOS 26.0, *) else {
      return ScreenTimeAPI.rejectUnavailable(reject, "26.0")
    }
    resolve(store.effectiveDenyExplicitContent)
  }

  // family activity data (iOS 26.4, requires `approvedWithDataAccess`)

  @objc
  public func getInstalledApplications(_ resolve: @escaping RCTPromiseResolveBlock,
                                       rejecter reject: @escaping RCTPromiseRejectBlock)
  {
    guard #available(iOS 26.4, *) else {
      return ScreenTimeAPI.rejectUnavailable(reject, "26.4")
    }
    Task {
      do {
        let applications = try await FamilyActivityData.shared.installedApplications
        resolve(applications.compactMap { ScreenTimeAPI.jsonObject($0) })
      } catch {
        reject("0", error.localizedDescription, error)
      }
    }
  }

  @objc
  public func getVisitedWebDomains(_ resolve: @escaping RCTPromiseResolveBlock,
                                   rejecter reject: @escaping RCTPromiseRejectBlock)
  {
    guard #available(iOS 26.4, *) else {
      return ScreenTimeAPI.rejectUnavailable(reject, "26.4")
    }
    Task {
      do {
        let webDomains = try await FamilyActivityData.shared.visitedWebDomains
        resolve(webDomains.compactMap { ScreenTimeAPI.jsonObject($0) })
      } catch {
        reject("0", error.localizedDescription, error)
      }
    }
  }

  @objc
  public func getActivityCategories(_ resolve: @escaping RCTPromiseResolveBlock,
                                    rejecter reject: @escaping RCTPromiseRejectBlock)
  {
    guard #available(iOS 26.4, *) else {
      return ScreenTimeAPI.rejectUnavailable(reject, "26.4")
    }
    Task {
      do {
        let categories = try await FamilyActivityData.shared.activityCategories
        resolve(categories.compactMap { ScreenTimeAPI.jsonObject($0) })
      } catch {
        reject("0", error.localizedDescription, error)
      }
    }
  }

  @objc
  public func getDeviceActivityData(_ options: NSDictionary,
                                    resolver resolve: @escaping RCTPromiseResolveBlock,
                                    rejecter reject: @escaping RCTPromiseRejectBlock)
  {
    guard #available(iOS 26.4, *) else {
      return ScreenTimeAPI.rejectUnavailable(reject, "26.4")
    }
    let start = ScreenTimeAPI.date(from: options["startDate"]) ?? Calendar.current.startOfDay(for: .now)
    let end = ScreenTimeAPI.date(from: options["endDate"]) ?? .now
    guard start <= end else {
      return reject("0", "startDate must not be after endDate", nil)
    }
    let interval = DateInterval(start: start, end: end)
    let segment: DeviceActivityFilter.SegmentInterval
    switch options["segment"] as? String {
    case "hourly":
      segment = .hourly(during: interval)
    case "weekly":
      segment = .weekly(during: interval)
    default:
      segment = .daily(during: interval)
    }
    let filter = DeviceActivityFilter(segment: segment)
    let policy: DeviceActivityData.Policy = options["policy"] as? String == "live" ? .live : .cached
    Task {
      do {
        var results: [[String: Any]] = []
        for try await data in DeviceActivityData.activityData(filteredBy: filter, using: policy) {
          results.append(try await data.encoded())
        }
        resolve(results)
      } catch {
        reject("0", error.localizedDescription, error)
      }
    }
  }

  // store management (iOS 26.5)

  @objc
  public func getStoreNames(_ resolve: @escaping RCTPromiseResolveBlock,
                            rejecter reject: @escaping RCTPromiseRejectBlock)
  {
    guard #available(iOS 26.5, *) else {
      return ScreenTimeAPI.rejectUnavailable(reject, "26.5")
    }
    resolve(ManagedSettingsStore.stores.map { $0.rawValue })
  }

  @objc
  public func isStoreActive(_ name: String?,
                            resolver resolve: @escaping RCTPromiseResolveBlock,
                            rejecter reject: @escaping RCTPromiseRejectBlock)
  {
    guard #available(iOS 26.5, *) else {
      return ScreenTimeAPI.rejectUnavailable(reject, "26.5")
    }
    resolve(managedStore(named: name).isActive)
  }

  @objc
  public func setStoreActive(_ active: Bool,
                             name: String?,
                             resolver resolve: @escaping RCTPromiseResolveBlock,
                             rejecter reject: @escaping RCTPromiseRejectBlock)
  {
    guard #available(iOS 26.5, *) else {
      return ScreenTimeAPI.rejectUnavailable(reject, "26.5")
    }
    managedStore(named: name).isActive = active
    resolve(nil)
  }

  @objc
  public func deleteStores(_ names: [String],
                           resolver resolve: @escaping RCTPromiseResolveBlock,
                           rejecter reject: @escaping RCTPromiseRejectBlock)
  {
    guard #available(iOS 26.5, *) else {
      return ScreenTimeAPI.rejectUnavailable(reject, "26.5")
    }
    ManagedSettingsStore.deleteStores(Set(names.map { ManagedSettingsStore.Name($0) }))
    resolve(nil)
  }

  @objc
  public func refreshTokens(_ tokens: NSDictionary,
                            resolver resolve: @escaping RCTPromiseResolveBlock,
                            rejecter reject: @escaping RCTPromiseRejectBlock)
  {
    guard #available(iOS 26.5, *) else {
      return ScreenTimeAPI.rejectUnavailable(reject, "26.5")
    }
    do {
      var applicationTokens: [ApplicationToken] = try ScreenTimeAPI.decode(tokens["applicationTokens"])
      var categoryTokens: [ActivityCategoryToken] = try ScreenTimeAPI.decode(tokens["categoryTokens"])
      var webDomainTokens: [WebDomainToken] = try ScreenTimeAPI.decode(tokens["webDomainTokens"])
      try ManagedSettingsStore.refresh(&applicationTokens)
      try ManagedSettingsStore.refresh(&categoryTokens)
      try ManagedSettingsStore.refresh(&webDomainTokens)
      let refreshed: [String: Any] = [
        "applicationTokens": ScreenTimeAPI.jsonObject(applicationTokens) ?? [Any](),
        "categoryTokens": ScreenTimeAPI.jsonObject(categoryTokens) ?? [Any](),
        "webDomainTokens": ScreenTimeAPI.jsonObject(webDomainTokens) ?? [Any](),
      ]
      resolve(refreshed)
    } catch {
      reject("0", error.localizedDescription, error)
    }
  }

  // helpers

  func managedStore(named name: String?) -> ManagedSettingsStore {
    guard let name else { return store }
    return ManagedSettingsStore(named: ManagedSettingsStore.Name(name))
  }

  static func rejectUnavailable(_ reject: RCTPromiseRejectBlock, _ version: String) {
    reject("unavailable", "This feature requires iOS \(version) or later", nil)
  }

  static func jsonObject<T: Encodable>(_ value: T) -> Any? {
    guard let data = try? JSONEncoder().encode(value) else { return nil }
    return try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
  }

  static func decode<T: Decodable>(_ object: Any?) throws -> [T] {
    guard let object else { return [] }
    let data = try JSONSerialization.data(withJSONObject: object)
    return try JSONDecoder().decode([T].self, from: data)
  }

  /// Accepts milliseconds since epoch or an ISO 8601 string.
  static func date(from value: Any?) -> Date? {
    if let ms = value as? NSNumber {
      return Date(timeIntervalSince1970: ms.doubleValue / 1000)
    }
    if let string = value as? String {
      let formatter = ISO8601DateFormatter()
      formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
      return formatter.date(from: string) ?? ISO8601DateFormatter().date(from: string)
    }
    return nil
  }

}

// MARK: - DeviceActivityData serialization

private let isoFormatter = ISO8601DateFormatter()

private func orNull(_ value: Any?) -> Any {
  value ?? NSNull()
}

private func iso(_ date: Date?) -> Any {
  guard let date else { return NSNull() }
  return isoFormatter.string(from: date)
}

/// Durations are reported in milliseconds to match `DateInterval.duration` in JS.
private func ms(_ interval: TimeInterval) -> Double {
  interval * 1000
}

private func encodeInterval(_ interval: DateInterval?) -> Any {
  guard let interval else { return NSNull() }
  return [
    "startDate": iso(interval.start),
    "endDate": iso(interval.end),
    "duration": ms(interval.duration),
  ]
}

extension DeviceActivityData {

  func encoded() async throws -> [String: Any] {
    var segments: [[String: Any]] = []
    for try await segment in activitySegments {
      segments.append(try await segment.encoded())
    }
    return [
      "device": device.encoded,
      "user": user.encoded,
      "lastUpdatedDate": iso(lastUpdatedDate),
      "activitySegments": segments,
    ]
  }

}

extension DeviceActivityData.Device {

  var encoded: [String: Any] {
    let modelName: String
    switch model {
    case .iPhone: modelName = "iPhone"
    case .iPad: modelName = "iPad"
    case .iPod: modelName = "iPod"
    case .mac: modelName = "mac"
    @unknown default: modelName = "unknown"
    }
    return ["name": orNull(name), "model": modelName]
  }

}

extension DeviceActivityData.User {

  var encoded: [String: Any] {
    let roleName: String
    switch role {
    case .child: roleName = "child"
    case .individual: roleName = "individual"
    @unknown default: roleName = "unknown"
    }
    let name = nameComponents.map { PersonNameComponentsFormatter().string(from: $0) }
    return ["appleID": orNull(appleID), "name": orNull(name), "role": roleName]
  }

}

extension DeviceActivityData.ActivitySegment {

  func encoded() async throws -> [String: Any] {
    var categoryActivities: [[String: Any]] = []
    for try await category in categories {
      categoryActivities.append(try await category.encoded())
    }
    return [
      "dateInterval": encodeInterval(dateInterval),
      "totalActivityDuration": ms(totalActivityDuration),
      "firstPickup": iso(firstPickup),
      "longestActivity": encodeInterval(longestActivity),
      "totalPickupsWithoutApplicationActivity": totalPickupsWithoutApplicationActivity,
      "categories": categoryActivities,
    ]
  }

}

extension DeviceActivityData.CategoryActivity {

  func encoded() async throws -> [String: Any] {
    var applicationActivities: [[String: Any]] = []
    for try await activity in applications {
      applicationActivities.append([
        "application": ScreenTimeAPI.jsonObject(activity.application) ?? NSNull(),
        "totalActivityDuration": ms(activity.totalActivityDuration),
        "numberOfPickups": activity.numberOfPickups,
        "numberOfNotifications": activity.numberOfNotifications,
      ])
    }
    var webDomainActivities: [[String: Any]] = []
    for try await activity in webDomains {
      webDomainActivities.append([
        "webDomain": ScreenTimeAPI.jsonObject(activity.webDomain) ?? NSNull(),
        "totalActivityDuration": ms(activity.totalActivityDuration),
      ])
    }
    return [
      "category": ScreenTimeAPI.jsonObject(category) ?? NSNull(),
      "totalActivityDuration": ms(totalActivityDuration),
      "applications": applicationActivities,
      "webDomains": webDomainActivities,
    ]
  }

}
