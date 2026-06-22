/**
 * @platform ios
 */
export type FamilyControlsMember = 'child' | 'individual';

/**
 * @platform ios
 */
export type AuthorizationStatus = 'approved' | 'denied' | 'notDetermined';

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
   * Sets whether app installation is denied.
   *
   * Mirrors Apple's
   * [`ApplicationSettings.denyAppInstallation`](https://developer.apple.com/documentation/managedsettings/applicationsettings/denyappinstallation).
   * On iOS this sets `ManagedSettingsStore.application.denyAppInstallation`; the
   * current value is readable via {@link getStore} (`application.denyAppInstallation`).
   * @platform ios
   * @platform android
   * @param {boolean} deny whether app installation is denied
   * @returns {Promise<void>}
   */
  denyAppInstallation: (deny: boolean) => Promise<void>;

  /**
   * Allows app installation.
   *
   * @deprecated Apple's `ApplicationSettings` has no `allowAppInstallation`
   * property; use {@link denyAppInstallation}`(false)` instead. Kept for
   * backwards compatibility.
   * @platform ios
   * @platform android
   * @returns {Promise<void>}
   */
  allowAppInstallation: () => Promise<void>;

  /**
   * Sets whether app removal is denied.
   *
   * Mirrors Apple's
   * [`ApplicationSettings.denyAppRemoval`](https://developer.apple.com/documentation/managedsettings/applicationsettings/denyappremoval).
   * On iOS this sets `ManagedSettingsStore.application.denyAppRemoval`; the
   * current value is readable via {@link getStore} (`application.denyAppRemoval`).
   * @platform ios
   * @platform android
   * @param {boolean} deny whether app removal is denied
   * @returns {Promise<void>}
   */
  denyAppRemoval: (deny: boolean) => Promise<void>;

  /**
   * Allows app removal.
   *
   * @deprecated Apple's `ApplicationSettings` has no `allowAppRemoval`
   * property; use {@link denyAppRemoval}`(false)` instead. Kept for
   * backwards compatibility.
   * @platform ios
   * @platform android
   * @returns {Promise<void>}
   */
  allowAppRemoval: () => Promise<void>;

  /**
   * Sets whether in-app purchases are denied.
   *
   * Mirrors Apple's
   * [`AppStoreSettings.denyInAppPurchases`](https://developer.apple.com/documentation/managedsettings/appstoresettings/denyinapppurchases).
   * On iOS this sets `ManagedSettingsStore.appStore.denyInAppPurchases`; the
   * current value is readable via {@link getStore} (`appStore.denyInAppPurchases`).
   *
   * Not supported on Android — Android exposes no system-level API to block
   * in-app purchases for a regular app, so this call has no effect there.
   * @platform ios
   * @param {boolean} deny whether in-app purchases are denied
   * @returns {Promise<void>}
   */
  denyInAppPurchases: (deny: boolean) => Promise<void>;

  /**
   * Allows in-app purchases.
   *
   * @deprecated Apple's `AppStoreSettings` has no `allowInAppPurchases`
   * property; use {@link denyInAppPurchases}`(false)` instead. Kept for
   * backwards compatibility.
   *
   * Not supported on Android — Android exposes no system-level API to block
   * in-app purchases for a regular app, so this call has no effect there.
   * @platform ios
   * @returns {Promise<void>}
   */
  allowInAppPurchases: () => Promise<void>;

  /**
   * Sets whether a password is required for purchases.
   *
   * Mirrors Apple's
   * [`AppStoreSettings.requirePasswordForPurchases`](https://developer.apple.com/documentation/managedsettings/appstoresettings/requirepasswordforpurchases).
   * On iOS this sets `ManagedSettingsStore.appStore.requirePasswordForPurchases`;
   * the current value is readable via {@link getStore} (`appStore.requirePasswordForPurchases`).
   *
   * Not supported on Android — Android exposes no system-level API to require
   * a password for purchases for a regular app, so this call has no effect there.
   * @platform ios
   * @param {boolean} req whether a password is required for purchases
   * @returns {Promise<void>}
   */
  requirePasswordForPurchases: (req: boolean) => Promise<void>;

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


};

declare const ScreenTime: IScreenTimeAPI;

/**
 * @platform ios
 */
declare const FamilyActivityPickerView: React.ComponentType<FamilyActivityPickerOptions>;

export { FamilyActivityPickerView, ScreenTime };
