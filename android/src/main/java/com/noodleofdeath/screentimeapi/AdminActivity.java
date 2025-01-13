package com.noodleofdeath.screentimeapi;

import android.app.Activity;
import android.app.admin.DevicePolicyManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;

public class AdminActivity extends Activity {

    private static final int REQUEST_CODE_ENABLE_ADMIN = 1;

    public void enableDeviceAdmin() {
        ComponentName deviceAdminSample = new ComponentName(this, DeviceAdmin.class);
        Intent intent = new Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN);
        intent.putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, deviceAdminSample);
        intent.putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, "Provide these permissions to manage the application");
        startActivityForResult(intent, REQUEST_CODE_ENABLE_ADMIN);
    }

    public void disableDeviceAdmin() {
        DevicePolicyManager mDPM = (DevicePolicyManager) getSystemService(Context.DEVICE_POLICY_SERVICE);
        ComponentName deviceAdminSample = new ComponentName(this, DeviceAdmin.class);
        mDPM.removeActiveAdmin(deviceAdminSample);
    }
    
}
