package com.noodleofdeath.screentimeapi;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;

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

    private static final String PREFS_NAME = "ScreenTimeAPIPrefs";
    private static final String KEY_DENY_IN_APP_PURCHASES = "denyInAppPurchases";
    private static final String KEY_REQUIRE_PASSWORD_FOR_PURCHASES = "requirePasswordForPurchases";

    public ScreenTimeAPIModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    private SharedPreferences getPrefs() {
        return getReactApplicationContext()
            .getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
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

    // Android exposes no system-level in-app purchase restriction for a
    // regular app, so the flags are only persisted here to mirror the iOS
    // API; they are not enforced by the OS.

    @ReactMethod
    public void denyInAppPurchases(Promise promise) {
        getPrefs().edit().putBoolean(KEY_DENY_IN_APP_PURCHASES, true).apply();
        promise.resolve("success");
    }

    @ReactMethod
    public void allowInAppPurchases(Promise promise) {
        getPrefs().edit().putBoolean(KEY_DENY_IN_APP_PURCHASES, false).apply();
        promise.resolve("success");
    }

    @ReactMethod
    public void requirePasswordForPurchases(boolean req, Promise promise) {
        getPrefs().edit().putBoolean(KEY_REQUIRE_PASSWORD_FOR_PURCHASES, req).apply();
        promise.resolve("success");
    }

}