package com.noodleofdeath.screentimeapi;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableArray;

public class ScreenTimeAPIModule extends ReactContextBaseJavaModule {

    private static final int REQUEST_CODE_ENABLE_ADMIN = 1;

    public ScreenTimeAPIModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @NonNull
    @Override
    public String getName() {
        return "ScreenTimeAPI";
    }

    @ReactMethod
    public void requestAuthorization(String type, Promise promise) {
        AdminActivity activity = new AdminActivity();
        activity.enableDeviceAdmin();
        promise.resolve("approved");
    }

    @ReactMethod
    public void revokeAuthorization(Promise promise) {
        AdminActivity activity = new AdminActivity();
        activity.disableDeviceAdmin();
        promise.resolve("notDetermined");
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