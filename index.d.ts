/**
 * @platform ios
 */
export type FamilyControlsMember = 'child' | 'individual';

/**
 * @platform ios
 */
export type AuthorizationStatus = 'approved' | 'approvedWithDataAccess' | 'denied' | 'notDetermined';

/**
 * @platform ios
 */
export type Token = {
  data: string;
}

/**
 * @platform ios
 */
export type TokenNamePair = {
  token: Token;
  name: string;
}

/**
 * @platform ios
 */
export type FamilyActivitySelection = {
  applicationTokens: Token[];
  categoryTokens: Token[];
  webDomainTokens: Token[];
  includeEntireCategory: boolean;
  untokenizedApplicationIdentifiers: string[];
  untokenizedCategoryIdentifiers: string[];
  untokenizedWebDomainIdentifiers: string[];
}

/**
 * 
 * @param {FamilyActivitySelection|undefined} selection 
 */
export declare function activitySelectionIsEmpty(selection?: FamilyActivitySelection): boolean;

/**
 * @platform ios
 */
export type FamilyActivityPickerOptions = {
  title?: String;
  headerText?: String;
  footerText?: String;
  activitySelection?: FamilyActivitySelection;
};

/**
 * @platform ios
 */
export type AccountSettings = {
  lockAccounts?: boolean;
}

/**
 * @platform ios
 * @platform android
 */
export type Application = {
  /**
   * @platform ios
   */
  bundleIdentifier?: string;
  /**
   * @platform ios
   */
  token?: Token;
  /**
   * @platform ios
   */
  localizedDisplayName?: string;
  /**
   * @platform android
   */
  packageName?: string;
}

/**
 * @platform ios
 */
export type ApplicationSettings = {
  blockedApplications?: Application[];
  denyAppInstallation?: boolean;
  denyAppRemoval?: boolean;
}

/**
 * @platform ios
 */
export type AppStoreSettings = {
  denyInAppPurchases?: boolean;
  maximumRating?: number;
  requirePasswordForPurchases?: boolean;
}

/**
 * @platform ios
 */
export type CellularSettings = {
  lockAppCellularData?: boolean;
  lockCellularPlan?: boolean;
  lockESIM?: boolean;
}

/**
 * @platform ios
 */
export type DateAndTimeSettings = {
  requireAutomaticDateAndTime?: boolean;
}

/**
 * @platform ios
 */
export type GameCenterSettings = {
  denyAddingFriends?: boolean;
  denyMultiplayerGaming?: boolean;
}

/**
 * @platform ios
 */
export type MediaSettings = {
  denyBookstoreErotica?: boolean;
  denyExplicitContent?: boolean;
  denyMusicService?: boolean;
  maximumMovieRating?: number;
  maximumTVShowRating?: number;
}

/**
 * @platform ios
 */
export type PasscodeSettings = {
  lockPasscode?: boolean;
}

/**
 * @platform ios
 */
export type SafariSettings = {
  denyAutoFill?: boolean;
  cookiePolicy?: string;
}

/**
 * @platform ios
 */
export type ShieldSettings = {
  applications?: boolean;
  applicationCategories?: string;
  webDomains?: boolean;
  webDomainCategories?: string;
}

/**
 * @platform ios
 */
export type SiriSettings = {
  denySiri?: boolean;
}

/**
 * @platform ios
 */
export type WebContentSettings = {
  blockedByFilter?: string;
}

/**
 * @platform ios
 */
export type ManagedSettingsStore = {
  account: AccountSettings;
  application: ApplicationSettings;
  appStore: AppStoreSettings;
  cellular: CellularSettings;
  dateAndTime: DateAndTimeSettings;
  gameCenter: GameCenterSettings;
  media: MediaSettings;
  passcode: PasscodeSettings;
  safari: SafariSettings;
  shield: ShieldSettings;
  siri: SiriSettings;
  webContent: WebContentSettings;
}

/**
 * @platform ios
 */
export type ScreenTimeConfiguration = { 
  enforcesChildRestrictions: boolean;
};

/**
 * Which iOS 26+ Screen Time APIs the current device supports.
 * @platform ios
 */
export type ScreenTimeCapabilities = {
  systemVersion: string;
  /** iOS 26.0+: `getEffectiveDenyExplicitContent` */
  effectiveDenyExplicitContent: boolean;
  /** iOS 26.4+: `getInstalledApplications`, `getVisitedWebDomains`, `getActivityCategories` */
  familyActivityData: boolean;
  /** iOS 26.4+: `getDeviceActivityData` */
  deviceActivityData: boolean;
  /** iOS 26.5+: `getStoreNames`, `isStoreActive`, `setStoreActive`, `deleteStores` */
  storeManagement: boolean;
  /** iOS 26.5+: `refreshTokens` */
  tokenRefresh: boolean;
};

/**
 * @platform ios
 */
export type ActivityCategory = {
  token?: Token;
  localizedDisplayName?: string;
};

/**
 * @platform ios
 */
export type WebDomain = {
  token?: Token;
  domain?: string;
};

/**
 * @platform ios
 */
export type ActivityTokens = {
  applicationTokens?: Token[];
  categoryTokens?: Token[];
  webDomainTokens?: Token[];
};

/**
 * Start and end dates are ISO 8601 strings; `duration` is in milliseconds.
 * @platform ios
 */
export type EncodedDateInterval = {
  startDate: string;
  endDate: string;
  duration: number;
};

/**
 * @platform ios
 */
export type DeviceActivityDataOptions = {
  /** Milliseconds since epoch or an ISO 8601 string. Defaults to the start of today. */
  startDate?: number | string;
  /** Milliseconds since epoch or an ISO 8601 string. Defaults to now. */
  endDate?: number | string;
  /** Defaults to `daily`. */
  segment?: 'hourly' | 'daily' | 'weekly';
  /** Defaults to `cached`. */
  policy?: 'cached' | 'live';
};

/**
 * All durations are in milliseconds and all dates are ISO 8601 strings.
 * @platform ios
 */
export type DeviceActivityData = {
  device: { name: string | null; model: 'iPhone' | 'iPad' | 'iPod' | 'mac' | 'unknown' };
  user: { appleID: string | null; name: string | null; role: 'child' | 'individual' | 'unknown' };
  lastUpdatedDate: string;
  activitySegments: {
    dateInterval: EncodedDateInterval;
    totalActivityDuration: number;
    firstPickup: string | null;
    longestActivity: EncodedDateInterval | null;
    totalPickupsWithoutApplicationActivity: number;
    categories: {
      category: ActivityCategory | null;
      totalActivityDuration: number;
      applications: {
        application: Application | null;
        totalActivityDuration: number;
        numberOfPickups: number;
        numberOfNotifications: number;
      }[];
      webDomains: {
        webDomain: WebDomain | null;
        totalActivityDuration: number;
      }[];
    }[];
  }[];
};

/**
 * @platform ios
 */
export declare class DateInterval {

  startDate: Date;
  endDate: Date;
  duration: number;

  constructor(startDate: Date, durationOrEndDate: number | Date);

}

export type IScreenTimeAPI = {

  /**
   * @platform ios
   * @param {FamilyControlsMember} member
   * @returns {Promise<void>}
   */
  requestAuthorization: (member: FamilyControlsMember) => Promise<void>;

  /**
   * @platform ios
   */
  revokeAuthorization: () => Promise<void>;

  /**
   * @platform ios
   * @returns {Promise<AuthorizationStatus>}
   */
  getAuthorizationStatus: () => Promise<AuthorizationStatus>;

  /**
   * @platform ios
   * @returns {Promise<ManagedSettingsStore>} 
   */
  getStore: () => Promise<ManagedSettingsStore>;

  /**
   * @platform ios
   * @returns {Promise<FamilyActivitySelection>}
   */
  getActivitySelection: () => Promise<FamilyActivitySelection>;

  /**
   * @platform ios
   * @param {FamilyActivitySelection} selection
   * @returns {Promise<void>}
   */
  setActivitySelection: (selection: FamilyActivitySelection) => Promise<void>;

  /**
   * @platform ios
   * @returns {Promise<void>}
   */
  clearActivitySelection: () => Promise<void>;

  /**
   * @platform android
   * @returns {Promise<Application[]>}
   */
  getBlockedApplications: () => Promise<Application[]>;

  /**
   * @platform android
   * @param {Application[]} applications
   * @returns {Promise<void>}
   */
  setBlockedApplications: (applications: Application[]) => Promise<void>;

  /**
   * @platform android
   * @returns {Promise<void>}
   */
  clearBlockedApplications: () => Promise<void>;

  /**
   * @platform ios
   * @platform android
   * @returns {Promise<void>}
   */
  denyAppInstallation: () => Promise<void>;

  /**
   * @platform ios
   * @platform android
   * @returns {Promise<void>}
   */
  allowAppInstallation: () => Promise<void>;

  /**
   * @platform ios
   * @platform android
   * @returns {Promise<void>}
   */
  denyAppRemoval: () => Promise<void>;

  /**
   * @platform ios
   * @platform android
   * @returns {Promise<void>}
   */
  allowAppRemoval: () => Promise<void>;
  
  /**
   * @platform ios
   * @returns {Promise<string>}
   */
  getApplicationName: (token: string | Token) => Promise<string>
  
  /**
   * @platform ios
   * @beta currently crashing a lot
   * @returns {Promise<TokenNamePair>[]>}
   */
  getApplicationNames: (token: (string | Token)[]) => Promise<TokenNamePair[]>
  
  /**
   * @platform ios
   * @returns {Promise<string>}
   */
  getCategoryName: (token: string | Token) => Promise<string>
  
  /**
   * @platform ios
   * @beta currently crashing a lot
   * @returns {Promise<TokenNamePair>[]>}
   */
  getCategoryNames: (token: (string | Token)[]) => Promise<TokenNamePair[]>

  /**
   * @platform ios
   * @returns {Promise<FamilyActivitySelection>}
   */
  displayFamilyActivityPicker: (options: FamilyActivityPickerOptions) => Promise<FamilyActivitySelection>;

  /**
   * @platform ios
   * @returns {Promise<void>}
   */
  deleteAllWebHistory: (identifier?: string) => Promise<void>;

  /**
   * @platform ios
   * @param {DateInterval} interval
   * @returns {Promise<void>}
   */
  deleteWebHistoryDuring(interval: DateInterval, identifier?: string): Promise<void>;

  /**
   * @platform ios
   * @param {string} url
   * @returns {Promise<void>}
   */
  deleteWebHistoryForURL(url: string, identifier?: string): Promise<void>;

  // iOS 26+ APIs. These reject with code `unavailable` on older systems;
  // use `getCapabilities()` to check support first.

  /**
   * @platform ios
   * @returns {Promise<ScreenTimeCapabilities>}
   */
  getCapabilities: () => Promise<ScreenTimeCapabilities>;

  /**
   * Whether explicit content is denied on this device by any store.
   * @platform ios 26.0+
   */
  getEffectiveDenyExplicitContent: () => Promise<boolean>;

  /**
   * Installed apps with real bundle identifiers and display names.
   * Requires `approvedWithDataAccess` authorization and the
   * `com.apple.developer.family-controls.app-and-website-usage` entitlement.
   * Apple only grants this to customer installs in the EU.
   * @platform ios 26.4+
   */
  getInstalledApplications: () => Promise<Application[]>;

  /**
   * Visited web domains with real domain names. Same requirements as `getInstalledApplications`.
   * @platform ios 26.4+
   */
  getVisitedWebDomains: () => Promise<WebDomain[]>;

  /**
   * All activity categories with display names. Same requirements as `getInstalledApplications`.
   * @platform ios 26.4+
   */
  getActivityCategories: () => Promise<ActivityCategory[]>;

  /**
   * Exports device activity (usage) data. Same requirements as `getInstalledApplications`.
   * @platform ios 26.4+
   */
  getDeviceActivityData: (options?: DeviceActivityDataOptions) => Promise<DeviceActivityData[]>;

  /**
   * Names of all ManagedSettings stores configured by this app.
   * @platform ios 26.5+
   */
  getStoreNames: () => Promise<string[]>;

  /**
   * @platform ios 26.5+
   * @param {string|null} name store name, or `null` for this library's default store
   */
  isStoreActive: (name: string | null) => Promise<boolean>;

  /**
   * Inactive stores are excluded from the device's effective settings.
   * @platform ios 26.5+
   * @param {string|null} name store name, or `null` for this library's default store
   */
  setStoreActive: (active: boolean, name: string | null) => Promise<void>;

  /**
   * @platform ios 26.5+
   */
  deleteStores: (names: string[]) => Promise<void>;

  /**
   * Refreshes expired tokens, e.g. ones persisted from a previous `FamilyActivitySelection`.
   * @platform ios 26.5+
   */
  refreshTokens: (tokens: ActivityTokens) => Promise<Required<ActivityTokens>>;


};

declare const ScreenTime: IScreenTimeAPI;

/**
 * @platform ios
 */
declare const FamilyActivityPickerView: React.ComponentType<FamilyActivityPickerOptions>;

export { FamilyActivityPickerView, ScreenTime };
