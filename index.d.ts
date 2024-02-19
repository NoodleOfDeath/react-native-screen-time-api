import { NativeModules, requireNativeComponent } from 'react-native';

const { ScreenTimeAPI } = NativeModules;

export type FamilyControlsMember = 'child' | 'individual';
export type AuthorizationStatus = 'approved' | 'denied' | 'notDetermined';

export type FamilyActivityPickerOptions = {
  title?: String;
  headerText?: String;
  footerText?: String;
};

export type Token = {
  data: string;
}

export type FamilyActivitySelection = {
  applicationTokens: Token[];
  categoryTokens: Token[];
  webDomainTokens: Token[];
  includeEntireCategory: boolean;
  untokenizedApplicationIdentifiers: string[];
  untokenizedCategoryIdentifiers: string[];
  untokenizedWebDomainIdentifiers: string[];
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
};

const ScreenTime = ScreenTimeAPI as IScreenTimeAPI;

const FamilyActivityPickerView = requireNativeComponent('RNTFamilyActivityPickerView');

export { FamilyActivityPickerView, ScreenTime };
