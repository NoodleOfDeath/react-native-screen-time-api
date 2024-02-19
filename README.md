# React Native Screen Time API <!-- omit in toc -->

Access the Screen Time API for iOS and Wellbeing API for Android (coming soon).

## Table of Contents <!-- omit in toc -->

- [Installation](#installation)
- [Usage](#usage)

## Installation

```sh
npm install react-native-screen-time-api
```

or

```sh
yarn add react-native-screen-time-api
```

## Usage

```javascript
import { ScreenTime } from 'react-native-screen-time-api';

React.useEffect(() => {
  ScreenTime.requestAuthorization('individual').then(() => {
    ScreenTime.getAuthorizationStatus().then((status) => {
      console.log('Authorization status:', status); // 'approved', 'deniied', or 'notDetermined'
      ScreenTime.displayFamilyActivityPicker().then((result) => {
        console.log('Family activity picker result:', result);
      });
    });
  });
}, []);
```