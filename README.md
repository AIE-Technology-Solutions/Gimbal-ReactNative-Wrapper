# Gimbal React Native development

A React Native module for the Gimbal Adapter.

### Issues

Please contact support@gimbal.com for any issues integrating or using this module.

### Requirements:
 - Xcode 11+
 - iOS: Deployment target 11.0+
 - Android: minSdkVersion 16+, compileSdkVersion 29+
 - React Native >= 0.60.0
 - React Native cli >= 2.0.1

## Install

```
# using yarn
yarn add gimbal-adapter-react-native
```

## iOS Setup

1) Install pods
```
cd ios && pod install
```

## Starting the adapter

In order to start the adapter, your app will need to call `start` with the app's Gimbal API Key:

```
import {
  ConsentType,
  ConsentState,
  ConsentRequirement,
  RegionEventType
 } from 'gimbal-adapter-react-native'

...

GimbalAdapter.setGimbalApiKey(<YOUR_GIMBAL_API_KEY>)
GimbalAdapter.start()
```

## Listening for events

Region enter/exits will automatically generate Airship events that can trigger Automation and Journeys. You can also listen for events directly by adding a listener to the `AirshipGimbalAdapter`:

```
    GimbalAdapter.addListener(RegionEventType.Enter, (event) => {
      console.log('regionEnter:', JSON.stringify(event))
    })

    GimbalAdapter.addListener(RegionEventType.Exit, (event) => {
      console.log('regionExit:', JSON.stringify(event))
    })
```

## GDPR

The adapter exposes Gimbal's GDPR APIs:


Check if GDPR consent is required:
```
    GimbalAdapter.getGdprConsentRequirement().then ((requirement) => {
      console.log('GDPR consent required:', requirement)
    })
```

Setting consent:
```
    GimbalAdapter.setUserConsent(ConsentType.Places, ConsentState.Granted)

    GimbalAdapter.getUserConsent(ConsentType.Places, (state) => {
      console.log('places consent:', state)
    })
```
