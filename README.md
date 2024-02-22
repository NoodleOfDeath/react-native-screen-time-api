# React Native Screen Time API <!-- omit in toc -->

![NPM Downloads](https://img.shields.io/npm/dm/react-native-screen-time-api)

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

Then run `npx pod-install`.

**NOTE:** Screen time only works on device, not the simulator.

## Usage

```javascript
import { ScreenTime } from 'react-native-screen-time-api';

React.useEffect(() => {
  ScreenTime.requestAuthorization('individual').then(async () => {
    const status = await ScreenTime.getAuthorizationStatus()
    console.log('Authorization status:', status); // 'approved', 'denied', or 'notDetermined'
    await selection = await ScreenTime.displayFamilyActivityPicker()
    console.log('Family activity selection:', selection);
    await ScreenTime.setActivitySelection(selection); // sets the shields
  });
}, []);
```