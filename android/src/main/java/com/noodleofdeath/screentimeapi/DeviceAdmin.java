package com.noodleofdeath.screentimeapi;

import android.app.admin.DeviceAdminReceiver;
import android.content.Context;
import android.content.Intent;

import androidx.core.app.ShareCompat;

public class DeviceAdmin extends DeviceAdminReceiver {

    @Override
    public void onEnabled(@androidx.annotation.NonNull Context context, @androidx.annotation.NonNull Intent intent) {
        super.onEnabled(context, intent);
    }

}
