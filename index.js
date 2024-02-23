import { NativeModules, requireNativeComponent } from 'react-native';

const { ScreenTimeAPI } = NativeModules;

const ScreenTime = ScreenTimeAPI;

export const activitySelectionIsEmpty = (selection) => {
  return !selection || (selection.applicationTokens.length === 0 && selection.categoryTokens.length === 0 && selection.webDomainTokens.length === 0)
}

const FamilyActivityPickerView = requireNativeComponent('RNTFamilyActivityPickerView');

export { FamilyActivityPickerView, ScreenTime };
