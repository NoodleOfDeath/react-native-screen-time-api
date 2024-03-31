package com.noodleofdeath.screentimeapi.interfaces;

public interface OnPasswordResetListener {
    void onOkClicked(String email);

    void onCancelClicked();
}
