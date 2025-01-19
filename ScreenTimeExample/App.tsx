import React from 'react';
import {
  StyleSheet,
  Text,
  TouchableHighlight,
  View,
} from 'react-native';

import { FamilyActivitySelection, ScreenTime } from 'react-native-screen-time-api';

const MyApp = () => {

  const [activitySelection, setActivitySelection] = React.useState<FamilyActivitySelection>();

  const selectActivities = React.useCallback(async () => {
    try {
      await ScreenTime.requestAuthorization('individual');
      const status = await ScreenTime.getAuthorizationStatus();
      console.log('Authorization status:', status); // 'approved', 'denied', or 'notDetermined'
      if (status !== 'approved') {
        throw new Error('user denied screen time access');
      }
      const selection = await ScreenTime.displayFamilyActivityPicker({});
      console.log('Family activity selection:', selection);
      // selection will be `null` if user presses cancel
      if (selection) {
        setActivitySelection(selection);
        await ScreenTime.setActivitySelection(selection); // sets the shields
      }
    } catch (error) {
      console.error(error);
    }
  }, []);

  const getNames = React.useCallback(async () => {
    try {

      if (!activitySelection) {
        throw new Error('no activity selection');
      }

      const applicationName = await ScreenTime.getApplicationNames(activitySelection.applicationTokens);
      console.log('Applications:', applicationName);

      const categoryName = await ScreenTime.getCategoryNames(activitySelection.categoryTokens);
      console.log('Categories:', categoryName);

    } catch (error) {
      console.error(error);
    }
  }, [activitySelection]);

  return (
    <View style={ styles.view }>
      <TouchableHighlight onPress={ () => selectActivities() }>
        <Text>Select Activities</Text>
      </TouchableHighlight>
      {activitySelection && (
        <TouchableHighlight onPress={ () => getNames() }>
          <Text>Get Names</Text>
        </TouchableHighlight>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  view: {
    alignItems: 'center',
    flexDirection: 'column',
    flexGrow: 1,
    backgroundColor: 'white',
    gap: 6,
    justifyContent: 'center',
  },
});

export default MyApp;
