export type FamilyControlsMember = 'child' | 'individual';
export type AuthorizationStatus = 'approved' | 'denied' | 'notDetermined';

export type Token = {
  data: string;
}

export class FamilyActivitySelection {
  applicationTokens: Token[];
  categoryTokens: Token[];
  webDomainTokens: Token[];
  includeEntireCategory: boolean;
  untokenizedApplicationIdentifiers: string[];
  untokenizedCategoryIdentifiers: string[];
  untokenizedWebDomainIdentifiers: string[];
}

export declare function activitySelectionIsEmpty(selection?: FamilyActivitySelection): boolean;

export type FamilyActivityPickerOptions = {
  title?: String;
  headerText?: String;
  footerText?: String;
  activitySelection?: FamilyActivitySelection;
};

export type AccountSettings = {
  lockAccounts?: boolean;
}

export type Application = {
  bundleIdentifier?: string;
  token?: Token;
  localizedDisplayName?: string;
}

export type ApplicationSettings = {
  blockedApplications?: Application[];
  denyAppInstallation?: boolean;
  denyAppRemoval?: boolean;
}

export type AppStoreSettings = {
  denyInAppPurchases?: boolean;
  maximumRating?: number;
  requirePasswordForPurchases?: boolean;
}

export type CellularSettings = {
  lockAppCellularData?: boolean;
  lockCellularPlan?: boolean;
  lockESIM?: boolean;
}

export type DateAndTimeSettings = {
  requireAutomaticDateAndTime?: boolean;
}

export type GameCenterSettings = {
  denyAddingFriends?: boolean;
  denyMultiplayerGaming?: boolean;
}

export type MediaSettings = {
  denyBookstoreErotica?: boolean;
  denyExplicitContent?: boolean;
  denyMusicService?: boolean;
  maximumMovieRating?: number;
  maximumTVShowRating?: number;
}

export type PasscodeSettings = {
  lockPasscode?: boolean;
}

export type SafariSettings = {
  denyAutoFill?: boolean;
  cookiePolicy?: string;
}

export type ShieldSettings = {
  applications?: boolean;
  applicationCategories?: string;
  webDomains?: boolean;
  webDomainCategories?: string;
}

export type SiriSettings = {
  denySiri?: boolean;
}

export type WebContentSettings = {
  blockedByFilter?: string;
}

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

export type IScreenTimeAPI = {
  requestAuthorization: (member: FamilyControlsMember) => Promise<void>;
  getAuthorizationStatus: () => Promise<AuthorizationStatus>;
  getStore: () => Promise<ManagedSettingsStore>;
  displayFamilyActivityPicker: (options: FamilyActivityPickerOptions) => Promise<FamilyActivitySelection>;
  getActivitySelection: () => Promise<FamilyActivitySelection>;
  setActivitySelection: (selection: FamilyActivitySelection) => Promise<void>;
  clearActivitySelection: () => Promise<void>;
  setDenyAppInstallation: () => Promise<void>;
  setDenyAppRemoval: () => Promise<void>;
};

declare const ScreenTime: IScreenTimeAPI;

declare const FamilyActivityPickerView: React.ComponentType<FamilyActivityPickerOptions>;

export { FamilyActivityPickerView, ScreenTime };
