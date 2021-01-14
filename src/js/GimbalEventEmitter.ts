import {
  NativeModules,
  NativeEventEmitter,
  EmitterSubscription,
  Platform,
} from "react-native";

/**
 * @hidden
 */
const { GimbalAdapterModule } = NativeModules;

/**
 * @hidden
 */
export default class GimbalEventEmitter extends NativeEventEmitter {
  constructor() {
    super(GimbalAdapterModule);
  }

  addListener(
    eventType: string,
    listener: (event: any) => void,
    context?: Object
  ): EmitterSubscription {
    if (Platform.OS === "android") {
      GimbalAdapterModule.addAndroidListener(eventType);
    }
    // @ts-ignore
    return super.addListener(eventType, listener, context);
  }

  removeAllListeners(eventType: string) {
    if (Platform.OS === "android") {
      // @ts-ignore
      const count = this.listeners(eventType).length;
      GimbalAdapterModule.removeAndroidListeners(count);
    }

    super.removeAllListeners(eventType);
  }

  removeSubscription(subscription: EmitterSubscription) {
    if (Platform.OS === "android") {
      GimbalAdapterModule.removeAndroidListeners(1);
    }
    super.removeSubscription(subscription);
  }
}
