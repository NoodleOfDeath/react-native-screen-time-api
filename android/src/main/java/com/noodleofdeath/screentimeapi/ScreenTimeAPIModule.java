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

    // App Store purchase restrictions are not supported on Android: the OS
    // exposes no system-level API to block in-app purchases or require a
    // password for purchases for a regular app. The flags are only persisted
    // here to mirror the iOS API; they are NOT enforced by the OS.

    /**
     * Not supported on Android. In-app purchase blocking has no Android
     * equivalent; the flag is persisted but never enforced by the OS.
     */
    @ReactMethod
    public void denyInAppPurchases(boolean deny, Promise promise) {
        getPrefs().edit().putBoolean(KEY_DENY_IN_APP_PURCHASES, deny).apply();
        promise.resolve("success");
    }

    /**
     * Not supported on Android. In-app purchase blocking has no Android
     * equivalent; the flag is persisted but never enforced by the OS.
     *
     * @deprecated Apple's {@code AppStoreSettings} has no {@code allowInAppPurchases}
     *     property; use {@link #denyInAppPurchases(boolean, Promise) denyInAppPurchases(false)}
     *     instead. Kept for backwards compatibility.
     */
    @Deprecated
    @ReactMethod
    public void allowInAppPurchases(Promise promise) {
        getPrefs().edit().putBoolean(KEY_DENY_IN_APP_PURCHASES, false).apply();
        promise.resolve("success");
    }

    /**
     * Not supported on Android. Requiring a password for purchases has no
     * Android equivalent; the flag is persisted but never enforced by the OS.
     */
    @ReactMethod
    public void requirePasswordForPurchases(boolean req, Promise promise) {
        getPrefs().edit().putBoolean(KEY_REQUIRE_PASSWORD_FOR_PURCHASES, req).apply();
        promise.resolve("success");
    }

}