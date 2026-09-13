# HyperOS-Dialer-Port

Systemless HyperOS China Dialer/InCallUI port for HyperOS EEA Android 15.

## Target

- Device: Xiaomi/Poco mondrian
- ROM: HyperOS OS3 EEA
- Android: 15
- Build tested during analysis: `OS3.0.2.0.VMNEUXM`

## v0.3 design

The port is intentionally conservative:

1. Use the China HyperOS `com.android.incallui` APK.
2. Use the China `com.android.contacts` APK where required.
3. Add only the required privileged permissions.
4. Apply only the required Dialer resource overlays.
5. Keep the EEA `com.android.phone` / TeleService unchanged.
6. Do not use `pm install` or remove Google Dialer/Contacts system updates.
7. Mount payload systemlessly through KernelSU/meta-overlayfs.

## Important

This repository is under active development. Do not flash a release until the Android 15 compatibility checks and boot/recovery tests pass.

The third-party Android 13/14 dialer module used as a reference is documented under `docs/`. Its installer is **not** reused because its Android-version branching does not support Android 15 and it changes the EEA Google Dialer/Contacts environment.
