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
  - [Add FamilyControls capability to your app](#add-familycontrols-capability-to-your-app)
  - [Sample code](#sample-code)
  - [Getting Application/Category Names](#getting-applicationcategory-names)
- [Contributing](#contributing)
- [Contributors](#contributors)

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
```typescript
import React from 'react';

import { FamilyActivitySelection, ScreenTime } from 'react-native-screen-time-api';

export const MyComponent = () => {

  const [activitySelection, setActivitySelection] = React.useState<FamilyActivitySelection>();

  React.useEffect(() => {
    try {
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
          setActivitySelection(selection);
          await ScreenTime.setActivitySelection(selection); // sets the shields
        }
      })
    } catch (error) {
      console.error(error);
    }
  }, []);

  return null;
}
```

### Getting Application/Category Names

After the use has given authorization you can then use the tokens they select to retrieve the names of each application or category selected

```typescript
import React from 'react';

import { FamilyActivitySelection, ScreenTime } from 'react-native-screen-time-api';

export const MyComponent = () => {

  const [activitySelection, setActivitySelection] = React.useState<FamilyActivitySelection>();

  React.useEffect(() => 'request auth', []);

  const getNames = React.useCallback(async () => {
    try {
  
      const applicationToken = activitySelection?.applicationTokens[0];
      const applicationName = await ScreenTime.getApplicationName(applicationToken);
      console.log('Application name:', applicationName);
  
      const categoryToken = activitySelection?.categoryTokens[0];
      const categoryName = await ScreenTime.getCategoryName(categoryToken);
      console.log('Category name:', categoryName);
      
    } catch (error) {
      console.error(error);
    }
  }, []);

  return (
    <Button onPress={ getNames() }>Get Names</Button>
  );
}
```

## Contributing

[TODO: @ashish-rama]

To contribute feel free to either make a PR or request to be added as a collaborator. Once your feature is added you may also add yourself to the Contributors list below.

## Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%">
        <a href="https://github.com/noodleofdeath">
          <img src="https://avatars.githubusercontent.com/u/14790443?v=4" width="100px;" alt="Thom Morgan"/><br />
          <sub>
            <b>Thom Morgan</b>
          </sub>
        </a>
      </td>
      <td align="center" valign="top" width="14.28%">
        <a href="https://github.com/ducfilan">
          <img src="https://avatars.githubusercontent.com/u/1677524?v=4" width="100px;" alt="Thom Morgan"/><br />
          <sub>
            <b>Duc Filan</b>
          </sub>
        </a>
      </td>
      <td align="center" valign="top" width="14.28%">
        <a href="https://github.com/ashish-rama">
          <img src="https://avatars.githubusercontent.com/u/11560399?v=4" width="100px;" alt="Thom Morgan"/><br />
          <sub>
            <b>Ashish Ramachandran</b>
          </sub>
        </a>
      </td>
    </tr>
  </tbody>
</table>