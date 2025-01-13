import { NativeModules, requireNativeComponent } from 'react-native';

const { ScreenTimeAPI } = NativeModules;

const ScreenTime = ScreenTimeAPI;

export const activitySelectionIsEmpty = (selection) => {
  if (!selection) return true;
  return Object.values(selection).every((v) => !v || (Array.isArray(v) && v.length === 0));
}

const FamilyActivityPickerView = requireNativeComponent('RNTFamilyActivityPickerView');

export class DateInterval {

  startDate;
  endDate;
  duration;

  constructor(startDate, durationOrEndDate) {
    if (!(startDate instanceof Date)) {
      throw new Error('Invalid argument startDate must be a Date objec');
    }
    this.startDate = startDate;
    if (durationOrEndDate instanceof Date) {
      this.endDate = durationOrEndDate;
      this.duration = durationOrEndDate.valueOf() - startDate.valueOf();
    } else if (typeof durationOrEndDate === 'number') {
      this.duration = durationOrEndDate;
      this.endDate = new Date(startDate.valueOf() + durationOrEndDate);
    } else {
      throw new Error('Invalid argument durationOrEndDate must be a Date object or a number');
    }
  }

}

export { FamilyActivityPickerView, ScreenTime };
