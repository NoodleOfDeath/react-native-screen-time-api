# React Native Screen Time API <!-- omit in toc -->

<p align="center">
  <a href="https://github.com/facebook/react-native/blob/HEAD/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="React Native is released under the MIT license." />
  </a>
  <a href="https://www.npmjs.org/package/react-native-screen-time-api">
    <img src="https://img.shields.io/npm/v/react-native-screen-time-api?color=brightgreen&label=npm%20package" alt="Current npm package version." />
  </a>
  <a href="https://www.npmjs.org/package/react-native-screen-time-api">
    <img src="https://img.shields.io/npm/dt/react-native-screen-time-api" alt="Npm downloads." />
  </a>
  <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" alt="PRs welcome!" />
</p>

Access the Screen Time API for iOS and Wellbeing API for Android (coming soon). This is far from complete and needs more work. Please don't hesitate to request specific screen time features

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

## Usage

```javascript
import { ScreenTime } from 'react-native-screen-time-api';

React.useEffect(() => {
  ScreenTime.requestAuthorization('individual').then(async () => {
    const status = await ScreenTime.getAuthorizationStatus();
    console.log('Authorization status:', status); // 'approved', 'denied', or 'notDetermined'
    await selection = await ScreenTime.displayFamilyActivityPicker();
    console.log('Family activity selection:', selection);
    // selection will be `null` if user presses cancel
    if (selection) {
      await ScreenTime.setActivitySelection(selection); // sets the shields
    }
  });
}, []);
```
