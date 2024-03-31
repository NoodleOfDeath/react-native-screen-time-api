package com.noodleofdeath.screentimeapi.interfaces;

public interface OnPermissionExplanationListener {
    void onOk(int requestCode);

    void onCancel(int switchId);
}
