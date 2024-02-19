import { NativeModules, requireNativeComponent } from 'react-native';

const { ScreenTimeAPI } = NativeModules;

export type FamilyControlsMember = 'child' | 'individual';
export type AuthorizationStatus = 'approved' | 'denied' | 'notDetermined';

export type IScreenTimeAPI = {
  requestAuthorization: (member: FamilyControlsMember) => Promise<void>;
  getAuthorizationStatus: () => Promise<AuthorizationStatus>;
  displayFamilyActivityPicker: () => Promise<void>
};

const ScreenTime = ScreenTimeAPI as IScreenTimeAPI;

const FamilyActivityPickerView = requireNativeComponent('RNTFamilyActivityPickerView');

export { FamilyActivityPickerView, ScreenTime };
