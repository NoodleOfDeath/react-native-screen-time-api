import { NativeModules, requireNativeComponent } from 'react-native';

const { ScreenTimeAPI } = NativeModules;

const ScreenTime = ScreenTimeAPI;

export const activitySelectionIsEmpty = (selection) => {
  if (!selection) return true;
  return Object.values(selection).every((v) => !v || Array.isArray(v) && v.length === 0);
}

const FamilyActivityPickerView = requireNativeComponent('RNTFamilyActivityPickerView');

export { FamilyActivityPickerView, ScreenTime };
