package com.noodleofdeath.screentimeapi;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

public class ScreenTimeAPIModule extends ReactContextBaseJavaModule {

    public ScreenTimeAPIModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @NonNull
    @Override
    public String getName() {
        return "ScreenTimeAPI";
    }

    @ReactMethod
    public void getBlockedApplications(Promise promise) {
        WritableArray apps = Arguments.createArray();
        promise.resolve(apps);
    }

    @ReactMethod
    public void setBlockedApplications(ReadableArray apps, Promise promise) {
        promise.resolve("success");
    }

    @ReactMethod
    public void clearBlockedApplications(Promise promise) {
        promise.resolve("success");
    }

    @ReactMethod
    public void denyAppRemoval(Promise promise) {
        promise.resolve("success");
    }

    @ReactMethod
    public void allowAppRemoval(Promise promise) {
        promise.resolve("success");
    }

    @ReactMethod
    public void denyAppInstallation(Promise promise) {
        promise.resolve("success");
    }

    @ReactMethod
    public void allowAppInstallation(Promise promise) {
        promise.resolve("success");
    }

}