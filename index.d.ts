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
export type ActivityLabel = {
  title: string;
  subtitle: string;
  type: string;
  icon: string;
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

  /**
   * @platform ios
   * @param {string} token Base64 encoded activity token
   * @returns {Promise<ActivityLabel>}
   */
  getActivityLabel(token: string): Promise<ActivityLabel>;
};

declare const ScreenTime: IScreenTimeAPI;

/**
 * @platform ios
 */
declare const FamilyActivityPickerView: React.ComponentType<FamilyActivityPickerOptions>;

export { FamilyActivityPickerView, ScreenTime };
