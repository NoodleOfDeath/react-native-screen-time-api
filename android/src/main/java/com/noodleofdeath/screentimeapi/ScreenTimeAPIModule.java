package com.noodleofdeath.screentimeapi;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

public class ScreenTimeApiModule extends ReactContextBaseJavaModule {

    public ScreenTimeApiModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @NonNull
    @Override
    public String getName() {
        return "ScreenTimeApi";
    }

    @ReactMethod
    public void addListener(String eventName) {
        // Keep: Required for RN built in Event Emitter Calls.
    }

    @ReactMethod
    public void removeListeners(Integer count) {
        // Keep: Required for RN built in Event Emitter Calls.
    }

    @ReactMethod
    public void getInitStatus(Promise promise) {
        promise.resolve("");
    }

    @ReactMethod
    public void getBlockedApplications(Promise promise) {
        promise.resolve("");
    }

    @ReactMethod
    public void setBlockedApplications(ReadableMap params, Promise promise) {
        promise.resolve("");
    }

    @ReactMethod
    public void clearBlockedApplications(Promise promise) {
        promise.resolve("");
    }

    @ReactMethod
    public void denyAppRemoval(Promise promise) {
        promise.resolve("");
    }

    @ReactMethod
    public void allowAppRemoval(Promise promise) {
        promise.resolve("");
    }

    @ReactMethod
    public void denyAppInstallation(Promise promise) {
        promise.resolve("");
    }

    @ReactMethod
    public void allowAppInstallation(Promise promise) {
        promise.resolve("");
    }

    private void sendEvent(String eventName, WritableMap params) {
        getReactApplicationContext()
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }
}