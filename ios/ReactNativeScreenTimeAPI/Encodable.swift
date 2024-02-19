//
//  Encodable.swift
//  ReactNativeScreenTimeAPI
//
//  Created by thom on 2/19/24.
//

import Foundation
import FamilyControls
import ManagedSettings

extension AccountSettings: Encodable {
  
  enum CodingKeys: String, CodingKey {
    case lockAccounts
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(lockAccounts, forKey: .lockAccounts)
  }
  
}

extension Application: Encodable {
  
  enum CodingKeys: String, CodingKey {
    case bundleIdentifier
    case token
    case localizedDisplayName
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(bundleIdentifier, forKey: .bundleIdentifier)
    try container.encode(token, forKey: .token)
    try container.encode(localizedDisplayName, forKey: .localizedDisplayName)
  }
  
}

extension ApplicationSettings: Encodable {
  
  enum CodingKeys: String, CodingKey {
    case blockedApplications
    case denyAppInstallation
    case denyAppRemoval
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(Array(blockedApplications ?? Set()), forKey: .blockedApplications)
    try container.encode(denyAppInstallation, forKey: .denyAppInstallation)
    try container.encode(denyAppRemoval, forKey: .denyAppRemoval)
  }
  
}

extension AppStoreSettings: Encodable {
  
  enum CodingKeys: String, CodingKey {
    case denyInAppPurchases
    case maximumRating
    case requirePasswordForPurchases
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(denyInAppPurchases, forKey: .denyInAppPurchases)
    try container.encode(maximumRating, forKey: .maximumRating)
    try container.encode(requirePasswordForPurchases, forKey: .requirePasswordForPurchases)
  }
  
}

extension CellularSettings: Encodable {
  
  enum CodingKeys: String, CodingKey {
    case lockAppCellularData
    case lockCellularPlan
    case lockESIM
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(lockAppCellularData, forKey: .lockAppCellularData)
    try container.encode(lockCellularPlan, forKey: .lockCellularPlan)
    try container.encode(lockESIM, forKey: .lockESIM)
  }
  
}

extension DateAndTimeSettings: Encodable {
  
  enum CodingKeys: String, CodingKey {
    case requireAutomaticDateAndTime
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(requireAutomaticDateAndTime, forKey: .requireAutomaticDateAndTime)
  }
  
}

extension GameCenterSettings: Encodable {
  
  enum CodingKeys: String, CodingKey {
    case denyAddingFriends
    case denyMultiplayerGaming
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(denyAddingFriends, forKey: .denyAddingFriends)
    try container.encode(denyMultiplayerGaming, forKey: .denyMultiplayerGaming)
  }
  
}

extension MediaSettings: Encodable {
  
  enum CodingKeys: String, CodingKey {
    case denyBookstoreErotica
    case denyExplicitContent
    case denyMusicService
    case maximumMovieRating
    case maximumTVShowRating
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(denyBookstoreErotica, forKey: .denyBookstoreErotica)
    try container.encode(denyExplicitContent, forKey: .denyExplicitContent)
    try container.encode(denyMusicService, forKey: .denyMusicService)
    try container.encode(maximumMovieRating, forKey: .maximumMovieRating)
    try container.encode(maximumTVShowRating, forKey: .maximumTVShowRating)
  }
  
}

extension PasscodeSettings: Encodable {
  
  enum CodingKeys: String, CodingKey {
    case lockPasscode
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(lockPasscode, forKey: .lockPasscode)
  }
  
}

extension SafariSettings: Encodable {
  
  enum CodingKeys: String, CodingKey {
    case denyAutoFill
    case cookiePolicy
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(denyAutoFill, forKey: .denyAutoFill)
    try container.encode(cookiePolicy?.rawValue, forKey: .cookiePolicy)
  }
  
}

extension ShieldSettings: Encodable {
  
  enum CodingKeys: String, CodingKey {
    case applications
    case applicationCategories
    case webDomains
    case webDomainCategories
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(applications, forKey: .applications)
    try container.encode(applicationCategories.debugDescription, forKey: .applicationCategories)
    try container.encode(webDomains, forKey: .webDomains)
    try container.encode(webDomainCategories.debugDescription, forKey: .webDomainCategories)
  }
  
}

extension SiriSettings: Encodable {
  
  enum CodingKeys: String, CodingKey {
    case denySiri
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(denySiri, forKey: .denySiri)
  }
  
}

extension WebContentSettings: Encodable {
  
  enum CodingKeys: String, CodingKey {
    case blockedByFilter
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(blockedByFilter.debugDescription, forKey: .blockedByFilter)
  }
  
}

extension ManagedSettingsStore: Encodable {
  
  enum CodingKeys: String, CodingKey {
    case account
    case application
    case appStore
    case cellular
    case dateAndTime
    case gameCenter
    case media
    case passcode
    case safari
    case shield
    case siri
    case webContent
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(account, forKey: .account)
    try container.encode(application, forKey: .application)
    try container.encode(appStore, forKey: .appStore)
    try container.encode(cellular, forKey: .cellular)
    try container.encode(dateAndTime, forKey: .dateAndTime)
    try container.encode(gameCenter, forKey: .gameCenter)
    try container.encode(media, forKey: .media)
    try container.encode(passcode, forKey: .passcode)
    try container.encode(safari, forKey: .safari)
    try container.encode(shield, forKey: .shield)
    try container.encode(siri, forKey: .siri)
    try container.encode(webContent, forKey: .webContent)
  }
  
}
