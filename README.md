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

### Add FamilyControls capability to your app
See https://developer.apple.com/documentation/Xcode/adding-capabilities-to-your-app

In addition to adding the Family Controls entitlement, for distribution, you will also need to [request Family Controls capabilities](https://developer.apple.com/contact/request/family-controls-distribution)


Open `ios/[your-app]/[your-app].entitlements` file, add this definition:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>com.apple.developer.family-controls</key>
    <true/>
  </dict>
</plist>
```

### Sample code
```javascript
import { ScreenTime } from 'react-native-screen-time-api';

React.useEffect(() => {
  ScreenTime.requestAuthorization('individual').then(async () => {
    const status = await ScreenTime.getAuthorizationStatus();
    console.log('Authorization status:', status); // 'approved', 'denied', or 'notDetermined'
    if (status !== 'approved') {
      throw new Error('user denied screen time access');
    }
    const selection = await ScreenTime.displayFamilyActivityPicker();
    console.log('Family activity selection:', selection);
    // selection will be `null` if user presses cancel
    if (selection) {
      await ScreenTime.setActivitySelection(selection); // sets the shields
    }
  }).catch((e) => {
    console.error(e);
  });
}, []);
```
